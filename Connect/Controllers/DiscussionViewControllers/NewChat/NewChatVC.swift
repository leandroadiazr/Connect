//
//  NewChatVC.swift
//  Connect
//
//  Created by Leandro Diaz on 2/9/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class NewChatVC: UIViewController, UITextFieldDelegate {
    var isNewConversation = false
    var tableView: UITableView?
    var collectionView: UICollectionView?
    var generics = [String]()
    var conversations = [Messages]()
    let containerView = UIView()
    var bottom: NSLayoutConstraint!
    var messageManager  = MessagesManager.shared
    var usersManager    = UserManager.shared
    var storage         = FireStorageManager.shared
    var inputViewContainerBottomConstraint: NSLayoutConstraint?
    
    var recipientUser: UserProfile?
    var recipientID: String!
    var sender = UserManager.shared.currentUserProfile
    
    let separator = UIView()
    let inputTextField = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "New cMessage...")
    let sendBtn = CustomGenericButton(backgroundColor: .link, title: "Send")
    let cameraBtn = CustomMainButton(backgroundColor: .red, title: "", textColor: .label, borderWidth: 0, borderColor: UIColor.clear.cgColor, buttonImage: Images.camera)
    var isMessageEntered: Bool { return !inputTextField.text!.isEmpty }
    
    lazy var textFieldContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 55)
        containerView.backgroundColor = .systemBackground
        containerView.addSubview(inputTextField)
        inputTextField.returnKeyType = .send
        containerView.addSubview(cameraBtn)
        return containerView
    }()

    override var inputAccessoryView: UIView? {
        get {
            return textFieldContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    init(recipientUser: UserProfile) {
        self.recipientUser = recipientUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        if !isNewConversation {
            updateConversations(for: recipientID)
            configureNavigationBar()
        }
        configureCollectionView()
        inputTextField.delegate = self
        manageInputEventsForTheSubViews()
        uploadImage()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    private func configureNavigationBar() {
        guard let recipient = self.recipientUser else { return }
        let profileView = CustomProfileView(frame: .zero, profilePic: recipient.profileImage, userName: recipient.name)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileView)
        profileView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant:  -50).isActive = true
        self.navigationItem.titleView = containerView
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    private func updateConversations(for recipientID: String ) {
        self.messageManager.observeSingleSenderRecipientConversation(for: recipientID) { result in
            self.conversations.removeAll()
            switch result {
            case .success(let messages):
                self.conversations.append(contentsOf: messages)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            case .failure(let error):
                self.showAlert(title: "There is an Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView?.keyboardDismissMode = .interactive
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.autoresizingMask = [.flexibleHeight]
        collectionView?.backgroundColor = .systemBackground
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(CustomChatCell.self, forCellWithReuseIdentifier:CustomChatCell.reuseID)
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 28, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
    }
    
    
    @objc private func sendMessage() {
        guard isMessageEntered else {
            showAlert(title: "Empty Field", message: "Please check your input...", buttonTitle: "Ok")
            return
        }
        guard let textMessage = inputTextField.text else { return  }
        guard let sender = sender else { return}
        
        guard let recipient = recipientUser else { return }
        self.messageManager.createNewMessage(sender: sender, recipient: recipient, textMessage: textMessage, media: nil) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(_):
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableView), userInfo: nil, repeats: false)
            case .failure(let error):
                self.showAlert(title: "Unable send message", message: "Ups.. Check your network connection", buttonTitle: "Ok")
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func reloadTableView() {
        self.conversations.sort { (message1, message2) -> Bool in
            return message1.timeStamp.intValue < message2.timeStamp.intValue
        }
        DispatchQueue.main.async {
            self.inputTextField.text = ""
            self.collectionView?.reloadData()
            
        }
    }
    
    
    @objc private func dismissVC() {
        self.dismiss(animated: true) {
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

extension NewChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomChatCell.reuseID, for: indexPath) as! CustomChatCell
        cell.layer.borderWidth = 1
        let message = conversations[indexPath.item]
        cell.configureGrid(with: message)
        setupCell(cell: cell, message: message)
//        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        return cell
    }
    
    private func setupCell(cell: CustomChatCell, message: Messages) {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: message.textMessage).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        estimatedFrame.size.height += 18
        
        if message.textMessage != "" {
            
            
            let nameSize = NSString(string: message.textMessage).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], context: nil)
            
            let maxValue = max(estimatedFrame.width, nameSize.width)
            estimatedFrame.size.width = maxValue
            
            if message.senderID == usersManager.currentUserProfile?.userID {
                cell.profileImage.frame = CGRect(x: self.collectionView!.bounds.width - 38, y: estimatedFrame.height - 18, width: 35, height: 35)
                cell.profileImage.backgroundColor = .green
                guard let collectionView = self.collectionView else { return }
                cell.messageText.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 75, y: 5, width: estimatedFrame.width + 26, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 90, y: 0, width: estimatedFrame.width + 45, height: estimatedFrame.height + 20)
                cell.textBubbleView.backgroundColor = CustomColors.CustomGreen
            }
            else {
                cell.profileImage.frame = CGRect(x: 8, y: estimatedFrame.height - 18, width: 35, height: 35)
                cell.profileImage.backgroundColor = .red
                cell.messageText.frame = CGRect(x: 56, y: 5, width: estimatedFrame.width + 26, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 45, height: estimatedFrame.height + 20)
                cell.textBubbleView.backgroundColor = .lightGray
            }
        } else if message.media != nil {
            if message.senderID == usersManager.currentUserProfile?.userID {
                cell.profileImage.frame = CGRect(x: self.collectionView!.bounds.width - 38, y: estimatedFrame.height + 68, width: 35, height: 35)
                cell.profileImage.backgroundColor = .green
                guard let collectionView = self.collectionView else { return }
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 190, y: 0, width: 150, height: 150)
            }
        } else {
            cell.profileImage.frame = CGRect(x: 8, y: estimatedFrame.height - 8, width: 35, height: 35)
            cell.profileImage.backgroundColor = .red
            cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: 150, height: 150)
            cell.textBubbleView.backgroundColor = .red
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let message = conversations[indexPath.item]
        if let chatCell = cell as? CustomChatCell {
            chatCell.profileImage.getImage(from: message.senderProfileImage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = conversations[indexPath.item]
        var estimatedFrame: CGRect?
        
        if message.textMessage != "" {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            estimatedFrame = NSString(string: message.textMessage).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            estimatedFrame?.size.height += 18
            return CGSize(width: collectionView.frame.width, height: estimatedFrame!.height + 20)
            
        } else if message.media != nil {
            let size = CGSize(width: 250, height: 600)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            estimatedFrame = NSString(string: message.media!).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            estimatedFrame?.size.height += 18
            
            return CGSize(width: collectionView.frame.width, height: estimatedFrame!.height + 20)
        }
        
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    private func uploadImage() {
        cameraBtn.addTarget(self, action: #selector(includeImage), for: .touchUpInside)
    }
    
    @objc private func includeImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
}


extension NewChatVC {
    
    private func setupConstraints() {
        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            
            inputTextField.trailingAnchor.constraint(equalTo: textFieldContainerView.trailingAnchor, constant: -8),
            inputTextField.topAnchor.constraint(equalTo: textFieldContainerView.topAnchor, constant: padding),
            inputTextField.leadingAnchor.constraint(equalTo: cameraBtn.trailingAnchor, constant: padding),
            inputTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            cameraBtn.topAnchor.constraint(equalTo: textFieldContainerView.topAnchor, constant: padding),
            cameraBtn.leadingAnchor.constraint(equalTo: textFieldContainerView.leadingAnchor, constant: padding),
            cameraBtn.widthAnchor.constraint(equalToConstant: 60),
            cameraBtn.heightAnchor.constraint(equalToConstant: 35)
        ])
        
    }
    
}

extension NewChatVC {
    @objc private func dismissKeyboard() {
        textFieldContainerView.resignFirstResponder()
        inputTextField.resignFirstResponder()
    }
    private func manageInputEventsForTheSubViews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardFrameChangeNotfHandler(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            inputViewContainerBottomConstraint?.constant = isKeyboardShowing ? keyboardFrame.height : 0
            
            DispatchQueue.main.async {
                if isKeyboardShowing {
                    let lastItem = self.conversations.count - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.collectionView!.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    self.collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 128, right: 0)
                    self.view.layoutIfNeeded()
                }
            }
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 128, right: 0)
                self.view.layoutIfNeeded()
            }, completion: nil
            )}
    }
    
    
}

extension NewChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismissVC()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        var image: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
           image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage
        }
        
        if let selectedImage = image {
            saveImage(image: selectedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func saveImage(image: UIImage) {
        self.storage.uploadMessageImage(image) { [weak self] (uploadedImage) in
            guard let self = self else { return }
            self.sendImageMessage(imageURL: uploadedImage)
        }
    }
    
    private func sendImageMessage(imageURL: String) {
//        guard imageURL.isEmpty else {
//            showAlert(title: "Empty Field", message: "Please check your input...", buttonTitle: "Ok")
//            return
//        }
        guard let sender = sender else { return}
        guard let recipient = recipientUser else { return }
        self.messageManager.createNewMessage(sender: sender, recipient: recipient, textMessage: "", media: imageURL) { [weak self] result in
            guard let self = self else {return}
            print(result)
            switch result {
            case .success(_):
                
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableView), userInfo: nil, repeats: false)
            case .failure(let error):
                self.showAlert(title: "Unable send Image", message: "Ups.. Check your network connection", buttonTitle: "Ok")
                print(error.localizedDescription)
            }
        }
        
    }
    
}

