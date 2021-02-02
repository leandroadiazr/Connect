//
//  MainFeedViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit

class MainFeedViewCell: UICollectionViewCell {
    static let reuseID            = "MainFeedViewCell"
    let userProfileImage        = CustomAvatarImage(frame: .zero)
    let userNameLabel           = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let mainImageViewArea       = UIImageView()
    let menuButton              = CustomMenuButton()
    let statusLabel             = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
    let postedLabel             = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 12)
    let titleLabel              = CustomSecondaryTitleLabel(title: "", fontSize: 15, textColor: .label)
    let locationLabel           = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .systemGray)
    let messageDescriptionLabel = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 11)
    let likesLabel              = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    let commentsLabel           = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    let viewsLabel              = CustomBodyLabel(textAlignment: .right, backgroundColor: .clear, fontSize: 10)
    let buttonStackView         = UIStackView()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(with data: User) {
        if data.profileImage.isEmpty {
            userProfileImage.image = UIImage(named: Images.Avatar)
        }
        
        userProfileImage.image = UIImage(named: data.profileImage)
        userNameLabel.text = data.name
        locationLabel.text = data.location
        
        //FEEDS
        //        for feed in data.feed! {
        mainImageViewArea.image = UIImage(named: data.mainImage)
        statusLabel.text = data.status
        postedLabel.text = String(data.postedOn.timeIntervalSinceNow)
        titleLabel.text = data.postTitle
        messageDescriptionLabel.text = data.messageDescription
        likesLabel.text = data.likes
        commentsLabel.text = data.comments
        viewsLabel.text = data.views
        //        }
        
    }
    
    private func configure() {
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        //PROFILE PICTURE
        addSubview(userProfileImage)
        //MENU BUTTON
        addSubview(menuButton)
        
        //MEDIA VIEW AREA
        mainImageViewArea.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainImageViewArea)
        
        //LABELS
        let labels = [userNameLabel, statusLabel, locationLabel, postedLabel, titleLabel, viewsLabel, messageDescriptionLabel, likesLabel, commentsLabel]
        for label in labels {
            addSubview(label)
        }
        messageDescriptionLabel.numberOfLines = 2
        messageDescriptionLabel.lineBreakMode = .byTruncatingTail
        
        setupActionButtons()
        setupConstraints()
    }
    
    fileprivate func setupActionButtons() {
        let actionButtons = [replyBtn, retweetBtn, likeBtn]
        for button in actionButtons {
            button.tintColor = CustomColors.CustomGreen
            buttonStackView.addArrangedSubview(button)
            button.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
        }
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
        
        addSubview(buttonStackView)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let mediaHeight: CGFloat = contentView.frame.height / 2
        
        //ProfileImage
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            userProfileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            userProfileImage.widthAnchor.constraint(equalToConstant: 40),
            userProfileImage.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        //User name Label
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: padding),
        ])
        
        //status Label
        NSLayoutConstraint.activate([
            postedLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            postedLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: padding),
        ])
        
        //status Label
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: padding),
        ])
        
        //Menu Button
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            menuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
        
        //MediaViewArea
        NSLayoutConstraint.activate([
            mainImageViewArea.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: padding),
            mainImageViewArea.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mainImageViewArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            mainImageViewArea.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        
        //Title Label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
        ])
        
        //User name Label
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            messageDescriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
            messageDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
        
        //likes Label
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            likesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        ])
        
        //comments Label
        NSLayoutConstraint.activate([
            commentsLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            commentsLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: padding),
        ])
        
        //Views Label
        NSLayoutConstraint.activate([
            viewsLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            viewsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
        
        //ActionButtons
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            buttonStackView.heightAnchor.constraint(equalToConstant: 30),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
