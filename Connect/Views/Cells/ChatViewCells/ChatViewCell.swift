//
//  ChatViewCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/15/21.
//

import UIKit

class ChatViewCell: UICollectionViewCell {
    static let reuseID = "ChatViewCell"
    let profileImage    = CustomAvatarImage(frame: .zero)
//    let senderTextArea = CustomTextView(textAlignment: .right, fontSize: 12)
    let senderTextArea = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .white)
    let recipientTextArea = CustomTextView(textAlignment: .left, fontSize: 12)
    let recipientBubbleView = UIView()
    
    var senderBubbleWidthAnchor: NSLayoutConstraint?
    var senderRightTextAreaAligment: NSLayoutConstraint?
    var senderLeftTextAreaAligment: NSLayoutConstraint?
    var bubbleRightAligment: NSLayoutConstraint?
    var bubbleLeftAligment: NSLayoutConstraint?
    let senderBubbleView = UIView()
    var usersManager = UserManager.shared

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureGrid(with chat: Messages) {
        senderTextArea.text = chat.textMessage
        
        if chat.senderID == usersManager.currentUserProfile?.userID {
        profileImage.cacheImage(from: chat.senderProfileImage)
        } else {
            profileImage.cacheImage(from: chat.recipientProfileImage)
        }
    }
    private func configure() {

        //MARK:-SENDER
        addSubview(senderBubbleView)
        senderBubbleView.translatesAutoresizingMaskIntoConstraints = false
//        senderBubbleView.backgroundColor = .systemGreen//  = Images.recipientChatBubble
        senderBubbleView.layer.cornerRadius = 20
        senderBubbleView.addSubview(senderTextArea)
        senderTextArea.textColor = .white
        senderTextArea.lineBreakMode = .byWordWrapping
        senderTextArea.numberOfLines = 0
        senderTextArea.layer.borderWidth = 0
        senderTextArea.backgroundColor = .clear
        senderTextArea.textAlignment = .center
    
        senderBubbleWidthAnchor = senderBubbleView.widthAnchor.constraint(equalToConstant: 200)
        senderBubbleWidthAnchor?.isActive = true
        
        senderTextArea.layer.borderColor = UIColor.red.cgColor
//        addSubview(senderTextArea)
        
        profileImage.layer.cornerRadius = 15
        profileImage.layer.borderWidth = 2
        addSubview(profileImage)
        setupConstraints()
        let padding: CGFloat = 10
        bubbleRightAligment = senderBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
//        senderRightTextAreaAligment = senderTextArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        
//        senderRightTextAreaAligment?.isActive = true
        bubbleRightAligment?.isActive = true
        
        bubbleLeftAligment = senderBubbleView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 5)
//        senderLeftTextAreaAligment = senderTextArea.trailingAnchor.constraint(equalTo: senderBubbleView.trailingAnchor, constant: -20)
//        senderLeftTextAreaAligment?.isActive = true
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let areaPading: CGFloat = 2
        
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: areaPading),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            profileImage.widthAnchor.constraint(equalToConstant: 30),
            profileImage.heightAnchor.constraint(equalToConstant: 30)
        ])
 
        NSLayoutConstraint.activate([
            senderBubbleView.topAnchor.constraint(equalTo: self.topAnchor,constant: areaPading),
            senderBubbleView.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -areaPading)
        ])
        NSLayoutConstraint.activate([
            senderTextArea.topAnchor.constraint(equalTo: senderBubbleView.topAnchor, constant: areaPading),
           senderTextArea.widthAnchor.constraint(equalTo: senderBubbleView.widthAnchor),
            senderTextArea.heightAnchor.constraint(equalTo: senderBubbleView.heightAnchor ,constant: -areaPading)
        ])

    }
    
}
