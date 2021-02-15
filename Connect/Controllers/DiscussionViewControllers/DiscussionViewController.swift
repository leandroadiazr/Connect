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
        updateConversations()
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
    }
    
    @objc private func createNewChat() {
        let createVC = CreateChatViewController()
        createVC.completion = {[weak self] receivedUserFromCreateChat in
            print("receivedUserFromCreateChat :", receivedUserFromCreateChat)
            self?.createNewConversation(recipientUser: receivedUserFromCreateChat)
        }
        
        let navVC = UINavigationController(rootViewController: createVC)
        navVC.modalPresentationStyle = .automatic
        self.present(navVC, animated: true, completion: nil)
    }
    
    private func createNewConversation(recipientUser: UserProfile?) {
        guard let receivedUser = recipientUser else { return }
        self.recipientUser = receivedUser
        let newChat = NewChatVC(recipientUser: self.recipientUser!)
        //        save user to Cache
        persistenceManager.saveUserToDeviceCache(user: self.recipientUser) { result in
            print(result)
        }
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
//        tableView?.backgroundColor = .systemBlue
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
                            print(recipient.recipientID, recipient)
                            self.conversationsDictionary[recipient.recipientID] = newMessage
                            self.conversations = Array(self.conversationsDictionary.values)
                            self.conversations.sort { (message1, message2) -> Bool in
                                return message1.timeStamp.intValue > message2.timeStamp.intValue
                            }
                        }
                        print(recipient.recipientID)
                        self.messagesManager.observeRecipientUserProfile(userID: recipient.recipientID) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let recipientReceived):
                                self.recipientUser = recipientReceived
                                self.chathingWith.append(recipientReceived)
                                print(Auth.auth().currentUser?.uid)
                                print(recipientReceived.userID)
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
        
        
        print("when click did selected row this is the user that is here :", currentDiscusion.recipientID)
        
//        for user in chathingWith {
//            if user.userID == currentDiscusion.recipientID {
        guard let recipient = recipientUser else { return }
        print(recipient)
                let chatVC = NewChatVC(recipientUser: recipient)
                chatVC.recipientID = currentDiscusion.recipientID
        chatVC.isNewConversation = false
//                chatVC.conversations.append(currentDiscusion)
//                print(currentDiscusion)
                
                self.navigationController?.pushViewController(chatVC, animated: true)
//            }
//        }
        
    }
}
