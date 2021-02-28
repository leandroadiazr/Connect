//
//  ChatViewCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/15/21.
//

import UIKit

class ChatViewCell: UICollectionViewCell {
    static let reuseID = "ChatViewCell"
//    let profileImage    = CustomAvatarImage(frame: .zero)
//    let senderTextArea = CustomTextView(textAlignment: .right, fontSize: 12)
//    let senderTextArea = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .white)
//    let recipientTextArea = CustomTextView(textAlignment: .left, fontSize: 12)
//    let recipientBubbleView = UIView()
//
//    var senderBubbleWidthAnchor: NSLayoutConstraint?
//    var senderRightTextAreaAligment: NSLayoutConstraint?
//    var senderLeftTextAreaAligment: NSLayoutConstraint?
//    var bubbleRightAligment: NSLayoutConstraint?
//    var bubbleLeftAligment: NSLayoutConstraint?
//    let senderBubbleView = UIView()
    var usersManager = UserManager.shared
    
    //MARK: SENDER AREA
    let senderProfileImage          = CustomAvatarImage(frame: .zero)
    let senderText                  = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .white)
    let senderBubble                = UIView()
    var senderBubbleWidthAnchor: NSLayoutConstraint?
    
    
    //MARK: RECIPIENT AREA
    let recipientProfileImage       = CustomAvatarImage(frame: .zero)
    let recipientText               = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .black)
    let recipientBubble             = UIView()
    var recipientBubbleWidthAnchor: NSLayoutConstraint?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureGrid(with chat: Messages) {

        if chat.senderID == usersManager.currentUserProfile?.userID {
            senderText.text = chat.textMessage
            recipientBubble.isHidden = true
     
        } else {
            recipientProfileImage.cacheImage(from: chat.recipientProfileImage)
            recipientText.text = chat.textMessage
            senderBubble.isHidden = true
        }
    }
    
    func configureSender(with message: Messages) {
        senderText.text = message.textMessage
        recipientBubble.isHidden = true
        
    }

    func configureRecipient(with message: Messages) {
        recipientProfileImage.cacheImage(from: message.recipientProfileImage)
        recipientText.text = message.textMessage
        senderBubble.isHidden = true
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipientText.text = nil
        self.recipientProfileImage.image = nil
        self.senderText.text = nil
        
    }
    
    
    private func configure() {
        //MARK:-SENDER
        senderProfileImage.isHidden = true
        senderText.lineBreakMode = .byWordWrapping
        senderText.numberOfLines = 0
        senderText.backgroundColor = .clear
        senderText.textAlignment = .left
        senderBubble.addSubview(senderText)
        senderBubble.layer.cornerRadius = 20
        senderBubble.backgroundColor = CustomColors.CustomGreen
        senderBubble.translatesAutoresizingMaskIntoConstraints = false
        senderBubbleWidthAnchor = senderBubble.widthAnchor.constraint(equalToConstant: 200)
        senderBubbleWidthAnchor?.isActive = true
        addSubview(senderBubble)
        
        
        //MARK:-RECIPIENT
        recipientText.lineBreakMode = .byWordWrapping
        recipientText.numberOfLines = 0
        recipientText.backgroundColor = .clear
        recipientText.textAlignment = .left
        recipientBubble.addSubview(recipientText)
        recipientBubble.addSubview(recipientProfileImage)
        recipientBubble.layer.cornerRadius = 20
        recipientBubble.backgroundColor = .systemGray6
        recipientBubble.translatesAutoresizingMaskIntoConstraints = false
        recipientBubbleWidthAnchor = recipientBubble.widthAnchor.constraint(equalToConstant: 200)
        recipientBubbleWidthAnchor?.isActive = true
        addSubview(recipientBubble)
        
        setupConstraints()
//        addSubview(senderBubbleView)
//        senderBubbleView.translatesAutoresizingMaskIntoConstraints = false
////        senderBubbleView.backgroundColor = .systemGreen//  = Images.recipientChatBubble
//        senderBubbleView.layer.cornerRadius = 20
//        senderBubbleView.addSubview(senderTextArea)
//        senderTextArea.textColor = .white
//        senderTextArea.lineBreakMode = .byWordWrapping
//        senderTextArea.numberOfLines = 0
//        senderTextArea.layer.borderWidth = 0
//        senderTextArea.backgroundColor = .clear
//        senderTextArea.textAlignment = .center
//
//        senderBubbleWidthAnchor = senderBubbleView.widthAnchor.constraint(equalToConstant: 200)
//        senderBubbleWidthAnchor?.isActive = true
//
//        senderTextArea.layer.borderColor = UIColor.red.cgColor
////        addSubview(senderTextArea)
//
//        profileImage.layer.cornerRadius = 15
//        profileImage.layer.borderWidth = 2
//        addSubview(profileImage)
//        setupConstraints()
//        let padding: CGFloat = 10
//        bubbleRightAligment = senderBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
////        senderRightTextAreaAligment = senderTextArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
//
////        senderRightTextAreaAligment?.isActive = true
//        bubbleRightAligment?.isActive = true
//
//        bubbleLeftAligment = senderBubbleView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 5)
////        senderLeftTextAreaAligment = senderTextArea.trailingAnchor.constraint(equalTo: senderBubbleView.trailingAnchor, constant: -20)
////        senderLeftTextAreaAligment?.isActive = true
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let areaPading: CGFloat = 2
        
        //MARK:- RECIPIENT AREA
        NSLayoutConstraint.activate([
            recipientProfileImage.topAnchor.constraint(equalTo: self.topAnchor),
            recipientProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            recipientProfileImage.widthAnchor.constraint(equalToConstant: 30),
            recipientProfileImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        

        NSLayoutConstraint.activate([
            recipientBubble.topAnchor.constraint(equalTo: self.topAnchor),
            recipientBubble.leadingAnchor.constraint(equalTo: recipientProfileImage.trailingAnchor, constant: padding),
//            recipientBubble.widthAnchor.constraint(equalTo: recipientText.widthAnchor, constant: padding * 2),
            recipientBubble.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recipientText.topAnchor.constraint(equalTo: recipientBubble.topAnchor, constant: areaPading),
            recipientText.leadingAnchor.constraint(equalTo: recipientBubble.leadingAnchor, constant: padding),
            recipientText.trailingAnchor.constraint(equalTo: recipientBubble.trailingAnchor, constant: -areaPading),
            recipientText.heightAnchor.constraint(equalTo: recipientBubble.heightAnchor,constant: areaPading),
        ])
        
        
        //MARK:- SENDER AREA
        NSLayoutConstraint.activate([
            senderBubble.topAnchor.constraint(equalTo: self.topAnchor),
            senderBubble.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            senderBubble.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            senderText.topAnchor.constraint(equalTo:        senderBubble.topAnchor, constant: areaPading),
            senderText.leadingAnchor.constraint(equalTo:    senderBubble.leadingAnchor, constant: padding),
            senderText.trailingAnchor.constraint(equalTo:   senderBubble.trailingAnchor, constant: -areaPading),
            senderText.heightAnchor.constraint(equalTo:     senderBubble.heightAnchor, constant: areaPading),
        ])
    
    }
    
}


/*class ChatViewCell: UICollectionViewCell {
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
 
 //MARK: SENDER AREA
 

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
*/
