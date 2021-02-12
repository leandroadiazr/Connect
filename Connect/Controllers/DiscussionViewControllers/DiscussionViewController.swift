//
//  DiscussionViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit

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
    var tableView: UITableView?
    var discussions = [UserProfile]()
    var user: UserProfile?
    var chathingWith: UserProfile?
    
    var conversations = [Conversations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateConversations()
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = user else { return }
        if !discussions.contains(user) {
            discussions.append(user)
        }
        self.tableView?.reloadData()
    }
    private func configureNavigationBar() {
        let addChat = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewChat))
        navigationItem.rightBarButtonItem = addChat
    }
    
    @objc private func createNewChat() {
        let createVC = CreateChatViewController()
        createVC.completion = {[weak self] user in
            print(user)
           
            
            self?.createNewConversation(recepientUser: user)
        }
        
        let navVC = UINavigationController(rootViewController: createVC)
        navVC.modalPresentationStyle = .automatic
        self.present(navVC, animated: true, completion: nil)
    }
    
    private func createNewConversation(recepientUser: UserProfile?) {
        self.chathingWith = recepientUser
        guard let name = recepientUser?.name, let recepientID = recepientUser else { return }
        let chatVC = ChatViewController(with: recepientID, id: recepientID.userID)
        chatVC.user = recepientUser
        chatVC.isNewConversation = true
        chatVC.title = name
        let navVC = UINavigationController(rootViewController: chatVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.rowHeight = 80
        tableView?.register(DiscussionsViewCell.self, forCellReuseIdentifier: DiscussionsViewCell.reuseID)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .systemBlue
        tableView?.removeEmptyCells()
        
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
    }
    
    private func updateConversations() {
        guard let userID = UserDefaults.standard.value(forKey: "userID") as? String else { return }
        messagesManager.retreivedAllUsersMessages(userID: userID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let conversations):
                guard !conversations.isEmpty else {
                    return
                }
                self.conversations.append(contentsOf: conversations)

                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
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
        
       
        print(user?.userID)
        let chatVC = ChatViewController(with: user, id: currentDiscusion.messageId)
        
//        chatVC.recepientUser = chathingWith
        chatVC.conversation.append(currentDiscusion)
        let navVC = UINavigationController(rootViewController: chatVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        
    }
}
