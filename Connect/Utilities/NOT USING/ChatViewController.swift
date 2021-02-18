//
//  ChatViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/7/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var recipient: UserProfile
    var isRead: Bool
    
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var photoURL: String
}



class ChatViewController: MessagesViewController {
    public var isNewConversation = false
    public var conversationID: String?
    var messagesManager = MessagesManager.shared
    var usersManager = UserManager.shared
    var conversations = [Message]()
    
    var recipientUser: UserProfile?
    var recipientID: String!
    
    var userProfile = [UserProfile]()
  
    var user: UserProfile?
    var recepient: UserProfile?
    
    
    var userManager = UserManager.shared
    
//    var isMessageEntered: Bool { return !inputTextField.text!.isEmpty }
    
    private var sender: Sender? {
        guard let userID = userManager.currentUserProfile?.userID else { return nil}
        guard let name = userManager.currentUserProfile?.name else { return nil}
        guard let photo = userManager.currentUserProfile?.profileImage  else { return nil}
        return Sender(senderId: userID, displayName: name, photoURL: photo)
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
        configureViewController()
        if !isNewConversation {
            updateConversations(for: recipientID)
            configureNavigationBar()
        }
        
        print("RECIPIENT WENT ENTER THE CHAT VC :",recipientUser)

    }
    
    private func configureViewController() {
        user = userManager.currentUserProfile
        view.backgroundColor = CustomColors.CustomGreenGradient
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
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
    
    @objc private func dismissVC() {
        self.dismiss(animated: true) {
            //            self.dismissLoadingView()
        }
    }
}




extension ChatViewController {
    private func getRecipient(recipientID: String) {
        print("outside the if: ", recipientID)
        self.messagesManager.observeRecipientUserProfile(userID: recipientID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receivedUser):
                self.recepient = receivedUser
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateConversations(for recipientID: String ) {
        self.messagesManager.letsObserveSingleSenderRecipientConversation(for: recipientID) { result in
            self.conversations.removeAll()
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self.conversations.append(contentsOf:  messages)
              
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
                
            case .failure(let error):
                self.showAlert(title: "There is an Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let sender = self.sender else { return }
        print(text)
//        guard let user = user else { return }

        guard let recipient = recipientUser else { return }
        print("recipient on sending new message :", recepient)
        
        if isNewConversation {
            let newMessage = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text), recipient: recipient, isRead: false)
            
            self.messagesManager.letsCreateNewMessage(sender: sender, message: newMessage, recipient: recipient, textMessage: text) {  result in
//                guard let self = self else {return}
                print(result)
            }
        } else {
            let newMessage = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text), recipient: recipient, isRead: false)
            
            self.messagesManager.letsCreateNewMessage(sender: sender, message: newMessage, recipient: recipient, textMessage: text) {  result in
//                guard let self = self else {return}
                print(result)
            }
        }
        
    }
    func currentSender() -> SenderType {
        if let sender = self.sender {
            return sender
        }
        fatalError("sender emal should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return conversations[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        conversations.count
    }
}

