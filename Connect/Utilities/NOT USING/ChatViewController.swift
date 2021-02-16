//
//  ChatViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/7/21.
//
/*
import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var photoURL: String
}

class ChatViewController: MessagesViewController {
    public var isNewConversation = false
    public var recipientID: String?
    public var conversationID: String?
    
    var messagesManager = MessagesManager.shared
    var messages = [Message]()
    var userProfile = [UserProfile]()
    var conversation = [Conversations]()
    var user: UserProfile?
    var recepient: UserProfile?
    
    
    var userManager = UserManager.shared
    
    private var sender: Sender? {
        guard let userID = UserDefaults.standard.value(forKey: "userID") as? String else { return nil}
        guard let name = UserDefaults.standard.value(forKey: "name") as? String else { return nil}
        return Sender(senderId: userID, displayName: name, photoURL: Images.Avatar)
    }
    
    init(with recipientID: String?, id: String) {
        self.recipientID = recipientID
        self.conversationID = id
        super.init(nibName: nil, bundle: nil)
       
        if let conversationID = conversationID, let recepientID = recipientID {

            getRecipient(recipientID: recepientID)
            observeMessages(recipientID: recepientID, with: conversationID)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewController()
        guard let  recipientID = recipientID, let id = conversationID else { return }
        observeMessages(recipientID: recipientID, with: id)
        print(id)
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
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = cancelBtn
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
    
    func observeMessages(recipientID: String, with id: String) {
        print("message id required: ", id)
        self.messagesManager.usersMessages(userID: recipientID, messageID: id) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let message):
                guard !message.isEmpty else {
                    return
                }
                for message in message{
                    print(message.messageId)
                }
                self.messages.append(contentsOf: message)
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("failed to get messages : ",error.localizedDescription)
            }
        }
    }
}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let sender = self.sender else { return }
        print(text)
        guard let user = user else { return }
        print(user)
        guard let recepient = recepient else { return }
        print(recepient)
        
        if isNewConversation {
            let message = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
            self.messagesManager.createMessage(from: user, with: message, for: recepient) { suscess in
                print(suscess)
            }
        } else {
            let message = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
            self.messagesManager.createMessage(from: user, with: message, for: recepient) { suscess in
                print(suscess)
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
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}
*/
