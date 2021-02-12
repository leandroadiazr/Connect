//
//  DiscussionsViewCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/11/21.
//

import UIKit


class DiscussionsViewCell: UITableViewCell {
    
    static let reuseID = "DiscussionsViewCell"
    let profileImage   = CustomAvatarImage(frame: .zero)
    let userNameLabel  = CustomSecondaryTitleLabel(title: "username", fontSize: 11, textColor: .label)
    let messagesLabel  = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    let receivedLabel  = CustomBodyLabel(textAlignment: .right, backgroundColor: .clear, fontSize: 8)
    
    var userManager = UserManager.shared
    var userProfile: UserProfile?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with: Conversations) {
        if !with.userProfileImage.isEmpty {
            profileImage.cacheImage(from: with.recipientProfileImage)     //downloadImage(from: with.userProfileImage)
        } else {
            profileImage.image = UIImage(named: Images.Avatar)
        }
        
        userNameLabel.text = with.recipientName
        receivedLabel.text = with.date
        messagesLabel.text = with.latestMessage.message

    }
    
    private func configure() {
        addSubview(profileImage)
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        addSubview(userNameLabel)
        addSubview(messagesLabel)
        addSubview(receivedLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
    
            profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            profileImage.widthAnchor.constraint(equalToConstant: 40),
            profileImage.heightAnchor.constraint(equalToConstant: 40),
            
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            receivedLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: 5),
            receivedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            messagesLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),
            messagesLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: padding),
            messagesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
           
        ])
        
    }
    
}
