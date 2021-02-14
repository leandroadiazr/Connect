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
    
    var conversations = [Conversations]()
    var conversationsToBe = [Messages]()
    var conversationsDictionary = [String: Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateConversations()
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        updateConversations()
        //        guard let recipientUser = recipientUser else { return }
        //        if !discussions.contains(recipientUser) {
        //            discussions.append(recipientUser)
        //        }
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
        tableView?.backgroundColor = .systemBlue
        tableView?.removeEmptyCells()
        
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
    }
    
    private func updateConversations() {
        
        self.messagesManager.retreivedAllUsersMessages { result in
            switch result {
            case .success(let messages):
                for newMessage in messages {
                    let recipient = newMessage
                    
                    if recipient.recipientID == newMessage.recipientID {
                        self.conversationsDictionary[recipient.recipientID] = newMessage
                        self.conversationsToBe = Array(self.conversationsDictionary.values)
                        self.conversationsToBe.sort { (message1, message2) -> Bool in
                            return message1.timeStamp.intValue > message2.timeStamp.intValue
                        }
                    }
              
                    self.messagesManager.observeRecipientUserProfile(userID: recipient.recipientID) { result in
                    switch result {
                    case .success(let recipientReceived):
                        self.chathingWith.append(recipientReceived)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                }
                DispatchQueue.main.async {
                               self.tableView?.reloadData()
                           }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
//        let ref = Database.database().reference().child("messages")
//        ref.observe( .childAdded) { snapshot in
//            guard let data = snapshot.value else {
//                print("unable to fetch message please change to error messages")
//                return }
//
//            guard let dictionary = data as? [String: Any],
//                  let senderID              = dictionary["senderID"] as? String,
//                  let senderName            = dictionary["senderName"] as? String,
//                  let senderProfileImage    = dictionary["senderProfileImage"] as? String,
//                  let recipientID           = dictionary["recipientID"] as? String,
//                  let recipientName         = dictionary["recipientName"] as? String,
//                  let recipientProfileImage = dictionary["recipientProfileImage"] as? String,
//                  let textMessage           = dictionary["textMessage"] as? String,
//                  let timeStamp             = dictionary["timeStamp"] as? NSNumber,
//                  let isRead                = dictionary["isRead"] as? String else { return }
//
//            let readed: Bool = isRead == "false" ? false : true
//
//            let newMessage = Messages(senderID: senderID, senderName: senderName, senderProfileImage: senderProfileImage, recipientID: recipientID, recipientName: recipientName, recipientProfileImage: recipientProfileImage, textMessage: textMessage, timeStamp: timeStamp, isRead: readed)
//            self.conversationsToBe.append(newMessage)
            
//            let recipient = newMessage
//            if recipient.recipientID == newMessage.recipientID {
//                self.conversationsDictionary[recipient.recipientID] = newMessage
//                self.conversationsToBe = Array(self.conversationsDictionary.values)
//                self.conversationsToBe.sort { (message1, message2) -> Bool in
//                    return message1.timeStamp.intValue > message2.timeStamp.intValue
//                }
//            }
//
//
//            self.messagesManager.observeRecipientUserProfile(userID: recipientID) { result in
//                switch result {
//                case .success(let recipientReceived):
//                    self.chathingWith.append(recipientReceived)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
            
            
            
            
//            DispatchQueue.main.async {
//                self.tableView?.reloadData()
//            }
//        }
    }
}


//MARK:- TABLEVIEW DELEGATES
extension DiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsToBe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscussionsViewCell.reuseID, for: indexPath) as! DiscussionsViewCell
        let conversation =    conversationsToBe[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.configureCell(with: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentDiscusion = conversationsToBe[indexPath.row]
        
        
        print("when click did selected row this is the user that is here :", currentDiscusion.recipientID)
        
        for user in chathingWith {
            if user.userID == currentDiscusion.recipientID {
                let chatVC = NewChatVC(recipientUser: user)
                
                chatVC.conversationToBe.append(currentDiscusion)
                print(currentDiscusion)
                
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
        
    }
}
