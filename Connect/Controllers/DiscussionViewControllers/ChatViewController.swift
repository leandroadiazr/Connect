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
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var photoURL: String
}

class ChatViewController: MessagesViewController {
    public var isNewConversation = false
    public let otherEmail: String
    
    var messagesManager = MessagesManager.shared
    var messages = [Message]()
    var userProfile = [UserProfile]()
    var conversation = [Conversations]()
    var user: UserProfile?
    var userManager = UserManager.shared
    
    private var sender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil}
        return Sender(senderId: email, displayName: "Leo", photoURL: Images.Avatar)
      
    }
    
    init(with email: String) {
        self.otherEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViewController()
        testingData()
    }
    
    private func testingData() {
//        messages.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello there...")))
//        messages.append(Message(sender: sender, messageId: "2", sentDate: Date(), kind: .text("Hello there...")))
//        messages.append(Message(sender: sender, messageId: "3", sentDate: Date(), kind: .text("Hello there...")))
//        messages.append(Message(sender: sender, messageId: "4", sentDate: Date(), kind: .text("Hello there...")))
//        messages.append(Message(sender: sender, messageId: "5", sentDate: Date(), kind: .text("Hello there...")))
//        messages.append(Message(sender: sender, messageId: "6", sentDate: Date(), kind: .text("Hello there...")))
    }
    
    private func configureViewController() {
        user = userManager.currentUserProfile
        view.backgroundColor = CustomColors.CustomGreenGradient
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
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
    func observeMessages() {
        
    }
}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let sender = self.sender else { return }
        print(text)
        guard let user = user else { return }
        print(user)
        if isNewConversation {
            let message = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
            self.messagesManager.createMessage(with: message, user: user) { suscess in
                print(suscess)
            }
        } else {
            
        }
        //Send
    }
    func currentSender() -> SenderType {
        if let sender = sender {
            return sender
        }
        
        fatalError("sender emal should be cached")
        return Sender(senderId: "1", displayName: "", photoURL: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}
