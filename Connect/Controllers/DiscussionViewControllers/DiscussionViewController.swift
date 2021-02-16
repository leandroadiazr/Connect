//
//  DiscussionViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit
import Firebase

struct Conversations {
    var userID: String
    var userProfileImage: String
    var messageId: String
    var name: String
    var email: String
    var recipientID: String
    var recipientName: String
    var recipientProfileImage: String
    var date: String
    var latestMessage: LatestMessage
}

struct LatestMessage {
    var dateReceived: String
    var message: String
    var isRead: Bool
}


class DiscussionViewController: UIViewController {
    var messagesManager = MessagesManager.shared
    var usersManager = UserManager.shared
    var tableView: UITableView?
    var discussions = [UserProfile]()
    var user: UserProfile?
    var chathingWith = [UserProfile]()
    var recipientUser: UserProfile?
    var persistenceManager = PersistenceManager.shared
//    let usernameLabel = CustomTitleLabel(title: "", textAlignment: .center, fontSize: 18)
//    let profilePic = CustomAvatarImage(frame: .zero)
//    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    var conversations = [Messages]()
    var conversationsDictionary = [String: Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cleanUpOnLoad()
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoadingView()
//        updateConversations()
    }
    
    private func cleanUpOnLoad() {
        conversations.removeAll()
        conversationsDictionary.removeAll()
        self.tableView?.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                self.dismissLoadingView()
    }
    private func configureNavigationBar() {
        let addChat = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewChat))
        navigationItem.rightBarButtonItem = addChat

        guard let currentUser = usersManager.currentUserProfile else { return }
        let profileView = CustomProfileView(frame: .zero, profilePic: currentUser.profileImage, userName: currentUser.name)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileView)
        profileView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant:  -50).isActive = true
        self.navigationItem.titleView = containerView
    }

    @objc private func createNewChat() {
        let createVC = CreateChatViewController()
        createVC.completion = {[weak self] receivedUserFromCreateChat in
            self?.createNewConversation(recipientUser: receivedUserFromCreateChat)
        }
        
        let navVC = UINavigationController(rootViewController: createVC)
        navVC.modalPresentationStyle = .automatic
        self.present(navVC, animated: true, completion: nil)
    }
    
    private func createNewConversation(recipientUser: UserProfile?) {
        guard let receivedUser = recipientUser else { return }
        self.chathingWith.append(receivedUser)
        let newChat = NewChatVC(recipientUser: receivedUser)
        newChat.isNewConversation = true
        self.navigationController?.pushViewController(newChat, animated: true)
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.rowHeight = 60
        tableView?.register(DiscussionsViewCell.self, forCellReuseIdentifier: DiscussionsViewCell.reuseID)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.removeEmptyCells()
        
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
    }
    
    private func updateConversations() {
        
        self.messagesManager.observeSingleUserMessages { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                
                    for newMessage in messages {
                        let recipient = newMessage
                    
                        if recipient.recipientID == newMessage.recipientID {
//                            print(recipient.recipientID, recipient)
                            self.conversationsDictionary[recipient.recipientID] = newMessage
                            self.conversations = Array(self.conversationsDictionary.values)
                            self.conversations.sort { (message1, message2) -> Bool in
                                return message1.timeStamp.intValue > message2.timeStamp.intValue
                            }
                        }

                        self.messagesManager.observeRecipientUserProfile(userID: newMessage.recipientID) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let recipientReceived):
                                self.chathingWith.append(recipientReceived)
                            case .failure(let error):
                                self.showAlert(title: "Unable send message", message: error.rawValue, buttonTitle: "Ok")
                                print(error.localizedDescription)
                            }
                        }
                     
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


//MARK:- TABLEVIEW DELEGATES
extension DiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscussionsViewCell.reuseID, for: indexPath) as! DiscussionsViewCell
        let conversation =    conversations[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.configureCell(with: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentDiscusion = conversations[indexPath.row]
        print("discussion with :", currentDiscusion.recipientID)
  
        for recipient in chathingWith {
            if recipient.userID == currentDiscusion.recipientID {
                print("recipient at indexpath :", recipient.userID)
                self.recipientUser = recipient
            }
        }
        
        guard let currentRecipient = self.recipientUser else { return }
        let chatVC = NewChatVC(recipientUser: currentRecipient)
        chatVC.isNewConversation = false
        chatVC.recipientID = currentDiscusion.recipientID
        self.navigationController?.pushViewController(chatVC, animated: true)

    }
}


//extension DiscussionViewController {
//    private func setupNavConstraints() {
//        NSLayoutConstraint.activate([
//            profilePic.leadingAnchor.constraint(equalTo: titleView.centerXAnchor, constant: -50),
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
//}
