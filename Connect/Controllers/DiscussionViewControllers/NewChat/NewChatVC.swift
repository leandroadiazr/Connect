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
    var generics = [String]()
    var conversations = [Messages]()
    let containerView = UIView()
    var messageManager = MessagesManager.shared
    
    var recipientUser: UserProfile?
    var sender = UserManager.shared.currentUserProfile
    
    let separator = UIView()
    let inputTextField = CustomTextField(textAlignment: .left, fontSize: 14, placeholder: "New cMessage...")
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
    
        configureTableView()
        configureNavigationBar()
        setupInputComponents()
        inputTextField.delegate = self
        print("user Received on newchat ", recipientUser)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      
    }
    private func updateConversations() {
        if conversations.isEmpty {
            print("nothingToShow")
        } else {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    private func configureNavigationBar() {
        //        let titleImageView = UIImageView.sd_setImage(recipientUser?.profileImage)
        //        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        //        titleImageView.contentMode = .scaleAspectFit
        //        titleImageView.tintColor = .blue
        //                navigationItem.titleView = titleImageView
        self.navigationItem.title = recipientUser?.name
        print(recipientUser?.name)
        
    }
    
    private func setupInputComponents() {
        
        containerView.backgroundColor = .systemGray6
        containerView.layer.borderWidth = 0.3
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cameraBtn)
        containerView.addSubview(inputTextField)
        var textFieldConstrait = inputTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        textFieldConstrait = KeyboardLayoutConstraint()
        containerView.addSubview(sendBtn)
        sendBtn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        containerView.addSubview(separator)
        separator.backgroundColor = .blue
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        setupConstraints()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.removeEmptyCells()
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
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
                    return message1.timeStamp.intValue > message2.timeStamp.intValue
                }
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
                
            case .failure(let error):
                self.showAlert(title: "Unable send message", message: "Ups.. Check your network connection", buttonTitle: "Ok")
                print(error.localizedDescription)
            }
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

extension NewChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = conversations[indexPath.row]
        
        cell.textLabel?.text = item.textMessage
        return cell
    }
}


extension NewChatVC {
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1),
            separator.heightAnchor.constraint(equalToConstant: 3),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
            inputTextField.widthAnchor.constraint(equalToConstant: 250),
            inputTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            cameraBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cameraBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            cameraBtn.widthAnchor.constraint(equalToConstant: 70),
            cameraBtn.heightAnchor.constraint(equalToConstant: 35)
        ])
        
    }
}


