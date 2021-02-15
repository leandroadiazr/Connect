//
//  ChatViewCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/15/21.
//

import UIKit

class ChatViewCell: UICollectionViewCell {
    static let reuseID = "ChatViewCell"
    
    let senderTextArea = CustomTextView(textAlignment: .right, fontSize: 12)
    let recipientTextArea = CustomTextView(textAlignment: .left, fontSize: 12)
    var recipientBubbleWidthAnchor: NSLayoutConstraint?
    let recipientBubbleView = UIView()
    
    var senderBubbleWidthAnchor: NSLayoutConstraint?
    let senderBubbleView = UIView()
    
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureGrid(with chat: Messages) {
        senderTextArea.text = chat.textMessage
        recipientTextArea.text = chat.textMessage
    }
    private func configure() {
//        backgroundColor = .blue
    
//        layer.borderWidth = 2
//        senderTextArea.layer.borderWidth = 1
//        senderTextArea.layer.borderColor = UIColor.blue.cgColor
//        addSubview(senderTextArea)
        
        addSubview(recipientBubbleView)
        recipientBubbleView.translatesAutoresizingMaskIntoConstraints = false
        recipientBubbleView.backgroundColor = .systemBlue//  = Images.recipientChatBubble
        recipientBubbleView.layer.cornerRadius = 20
        recipientTextArea.textColor = .white
        recipientTextArea.layer.borderWidth = 0
        recipientTextArea.backgroundColor = .clear
    
        recipientBubbleWidthAnchor = recipientBubbleView.widthAnchor.constraint(equalToConstant: 200)
        recipientBubbleWidthAnchor?.isActive = true
        recipientTextArea.layer.borderColor = UIColor.red.cgColor
        addSubview(recipientTextArea)
        
        //MARK:-SENDER
        addSubview(senderBubbleView)
        senderBubbleView.translatesAutoresizingMaskIntoConstraints = false
        senderBubbleView.backgroundColor = .systemGreen//  = Images.recipientChatBubble
        senderBubbleView.layer.cornerRadius = 20
        senderTextArea.textColor = .white
        senderTextArea.layer.borderWidth = 0
        senderTextArea.backgroundColor = .clear
    
        senderBubbleWidthAnchor = senderBubbleView.widthAnchor.constraint(equalToConstant: 200)
        senderBubbleWidthAnchor?.isActive = true
        senderTextArea.layer.borderColor = UIColor.red.cgColor
        addSubview(senderTextArea)
        

        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let areaPading: CGFloat = 2
        
        NSLayoutConstraint.activate([
            senderTextArea.topAnchor.constraint(equalTo: self.topAnchor, constant: areaPading),
            senderTextArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            senderTextArea.widthAnchor.constraint(equalToConstant: 260),
            senderTextArea.heightAnchor.constraint(equalTo: self.heightAnchor ,constant: -areaPading)
        ])
        
        NSLayoutConstraint.activate([
            senderBubbleView.topAnchor.constraint(equalTo: self.topAnchor,constant: areaPading),
            senderBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            senderBubbleView.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -areaPading)
        ])
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            recipientTextArea.topAnchor.constraint(equalTo: self.topAnchor, constant: areaPading),
            recipientTextArea.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            recipientTextArea.widthAnchor.constraint(equalToConstant: 260),
            recipientTextArea.heightAnchor.constraint(equalTo: self.heightAnchor ,constant: -areaPading)
        ])
        
        NSLayoutConstraint.activate([
            recipientBubbleView.topAnchor.constraint(equalTo: self.topAnchor,constant: areaPading),
            recipientBubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            recipientBubbleView.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -areaPading)
        ])
        
        
        
    }
    
}
