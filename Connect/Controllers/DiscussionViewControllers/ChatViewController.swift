//
//  ChatViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/7/21.
//

import UIKit
import MessageKit

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
    private var messages = [Message]()
    private var sender = Sender(senderId: "123456", displayName: "Leo", photoURL: Images.Avatar)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.CustomGreenGradient
        messages.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello there...")))
        messages.append(Message(sender: sender, messageId: "2", sentDate: Date(), kind: .text("Hello there...")))
        messages.append(Message(sender: sender, messageId: "3", sentDate: Date(), kind: .text("Hello there...")))
        messages.append(Message(sender: sender, messageId: "4", sentDate: Date(), kind: .text("Hello there...")))
        messages.append(Message(sender: sender, messageId: "5", sentDate: Date(), kind: .text("Hello there...")))
        messages.append(Message(sender: sender, messageId: "6", sentDate: Date(), kind: .text("Hello there...")))
        
        configureNavigationBar()
        configureViewController()
    }
    
    
    private func configureViewController() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    
    private func configureNavigationBar() {

        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = cancelBtn
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true) {
            self.dismissLoadingView()
        }
    }

}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}
