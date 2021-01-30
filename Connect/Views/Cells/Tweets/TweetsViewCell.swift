//
//  TweetsViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/15/21.
//

import UIKit

class TweetsViewCell: UICollectionViewCell {
        static let reuseID = "TweetsCollectionCell"
    let viewImage       = CustomAvatarImage(frame: .zero)
    let userNameLabel   = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let handlerLabel    = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
    let messageTextView = CustomTextView(textAlignment: .left, fontSize: 12)
    let buttonStackView = UIStackView()
    
    let replyBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.comment, for: .normal)
        return btn
    }()
    
    let retweetBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.retweet, for: .normal)
        return btn
    }()
    
    let likeBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.like, for: .normal)
        return btn
    }()
    
    let newTweetBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.newTweet, for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with tweet: Tweet) {
        if tweet.user.profileImage == "" {
            viewImage.image = UIImage(named: Images.Avatar)
        }
        userNameLabel.text = tweet.user.name
        handlerLabel.text  = tweet.user.handler
        viewImage.image = UIImage(named: tweet.user.profileImage)
        messageTextView.text = tweet.message
    }
    
    private func configure() {
        backgroundColor = .systemBackground
      
        
        addSubview(userNameLabel)
        addSubview(handlerLabel)
        
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        viewImage.clipsToBounds = true
        viewImage.layer.cornerRadius = 8
        viewImage.tintColor = CustomColors.CustomGreen
        addSubview(viewImage)
        
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageTextView)
        setupActionButtons()
        setupConstraints()
    }
    
    fileprivate func setupActionButtons() {
        let actionButtons = [replyBtn, retweetBtn, likeBtn, newTweetBtn]
        for button in actionButtons {
            button.tintColor = CustomColors.CustomGreen
            buttonStackView.addArrangedSubview(button)
        }
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        
        addSubview(buttonStackView)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            viewImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            viewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            viewImage.widthAnchor.constraint(equalToConstant: 40),
            viewImage.heightAnchor.constraint(equalToConstant: 40),
            
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            userNameLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            handlerLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            handlerLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: padding),
            handlerLabel.heightAnchor.constraint(equalToConstant: 16),
            
            messageTextView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 0),
            messageTextView.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            messageTextView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -padding),
            
            buttonStackView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: padding),
            buttonStackView.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
            
            
        ])
    }
}
