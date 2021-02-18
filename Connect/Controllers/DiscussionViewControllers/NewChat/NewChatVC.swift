//
//  NewChatVC.swift
//  Connect
//
//  Created by Leandro Diaz on 2/9/21.
//

import UIKit
import Firebase

class NewChatVC: UIViewController, UITextFieldDelegate {
    var isNewConversation = false
    var tableView: UITableView?
    var collectionView: UICollectionView?
    var generics = [String]()
    var conversations = [Messages]()
    let containerView = UIView()
    var messageManager = MessagesManager.shared
    var usersManager    = UserManager.shared
    
    var recipientUser: UserProfile?
    var recipientID: String!
    var sender = UserManager.shared.currentUserProfile
    
    let separator = UIView()
    let inputTextField = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "New cMessage...")
    let sendBtn = CustomGenericButton(backgroundColor: .link, title: "Send")
    let cameraBtn = CustomMainButton(backgroundColor: .red, title: "", textColor: .label, borderWidth: 0, borderColor: UIColor.clear.cgColor, buttonImage: Images.camera)
    var isMessageEntered: Bool { return !inputTextField.text!.isEmpty }
    
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
        //
        setupInputComponents()
        inputTextField.delegate = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      
    }
    
    private func configureNavigationBar() {
        guard let recipient = self.recipientUser else { return }
        let profileView = CustomProfileView(frame: .zero, profilePic: recipient.profileImage, userName: recipient.name)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileView)
        profileView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant:  -50).isActive = true
        self.navigationItem.titleView = containerView
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
    
    private func setupInputComponents() {
        containerView.backgroundColor = .systemGray6
        containerView.layer.borderWidth = 0.3
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cameraBtn)

        containerView.addSubview(inputTextField)
        containerView.bringSubviewToFront(inputTextField)
        containerView.addSubview(sendBtn)
        sendBtn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        containerView.addSubview(separator)
        separator.backgroundColor = .blue
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        view.bringSubviewToFront(containerView)
        setupConstraints()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.autoresizingMask = [.flexibleHeight]
        collectionView?.backgroundColor = .systemBackground
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ChatViewCell.self, forCellWithReuseIdentifier:ChatViewCell.reuseID)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
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
        self.messageManager.createNewMessage(sender: sender, recipient: recipient, textMessage: textMessage) { [weak self] result in
            guard let self = self else {return}
         
            switch result {
            case .success(let newMessage):

                self.conversations.append(newMessage)
                self.conversations.sort { (message1, message2) -> Bool in
                    return message1.timeStamp.intValue < message2.timeStamp.intValue
                }
              
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableView), userInfo: nil, repeats: false)
                
            case .failure(let error):
                self.showAlert(title: "Unable send message", message: "Ups.. Check your network connection", buttonTitle: "Ok")
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func reloadTableView() {
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
        
        let grid = collectionView.dequeueReusableCell(withReuseIdentifier: ChatViewCell.reuseID, for: indexPath) as! ChatViewCell
        let message = conversations[indexPath.item]
        setupCell(grid: grid, message: message)
        grid.configureGrid(with: message)
        
        
        
        grid.senderBubbleWidthAnchor?.constant = estimatedFrameSize(string: message.textMessage).width + 30
        return grid
    }
    
    private func setupCell(grid: ChatViewCell, message: Messages) {
        if message.senderID == usersManager.currentUserProfile?.userID {
            grid.senderBubbleView.backgroundColor = .systemBlue
            grid.senderTextArea.textColor = .white
            grid.profileImage.isHidden = true
        } else if message.senderID != usersManager.currentUserProfile?.userID {
            grid.senderBubbleView.backgroundColor = CustomColors.CustomGreen
            grid.senderRightTextAreaAligment?.isActive = false
            grid.bubbleRightAligment?.isActive = false
            grid.profileImage.isHidden = false
            grid.senderTextArea.textColor = .white
            
            
            grid.senderLeftTextAreaAligment?.isActive = true
            grid.bubbleLeftAligment?.isActive = true
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = estimatedFrameSize(string: conversations[indexPath.item].textMessage).height
       
        return CGSize(width: view.frame.width, height: height + 35)
        
    }
 
    private func estimatedFrameSize(string: String) -> CGRect{
        let approximateWidth = view.frame.width / 1.8
        let size = CGSize(width: approximateWidth, height: 600)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        return NSString(string: string).boundingRect(with: size, options: .usesFontLeading, attributes: attributes, context: nil)
    }
}


extension NewChatVC {
    
    private func setupConstraints() {
//        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1),
            separator.heightAnchor.constraint(equalToConstant: 3),
            
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        //Button
        NSLayoutConstraint.activate([
            sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3),
            sendBtn.widthAnchor.constraint(equalToConstant: 90),
            sendBtn.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -3),
            inputTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            inputTextField.widthAnchor.constraint(equalToConstant: 250),
//            inputTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            cameraBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cameraBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            cameraBtn.widthAnchor.constraint(equalToConstant: 70),
            cameraBtn.heightAnchor.constraint(equalToConstant: 35)
        ])
        
    }
    
//    private func setupNavConstraints() {
//        NSLayoutConstraint.activate([
//            profilePic.centerXAnchor.constraint(equalTo: titleView.centerXAnchor, constant: 5),
//            profilePic.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
//            profilePic.widthAnchor.constraint(equalToConstant: 40),
//            profilePic.heightAnchor.constraint(equalToConstant: 40),
//
//            usernameLabel.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 5),
//            usernameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
//            usernameLabel.widthAnchor.constraint(equalToConstant: 55),
//            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
//
//        ])
//    }
}


