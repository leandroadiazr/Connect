//
//  MainFeedViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit
protocol PresentCommentVC: class {
    func presentViewComments()
    func showMenu(_ sender: UIButton)
}

class MainFeedViewCell: UICollectionViewCell, UINavigationControllerDelegate {
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
    var likesCounter            = CustomBodyLabel(textAlignment: .center, backgroundColor: .clear, fontSize: 12)
    let commentsLabel           = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    var commentsCounter         = CustomBodyLabel(textAlignment: .center, backgroundColor: .clear, fontSize: 12)
    let viewsLabel              = CustomBodyLabel(textAlignment: .right, backgroundColor: .clear, fontSize: 10)
    var viewsCounter            = CustomBodyLabel(textAlignment: .center, backgroundColor: .clear, fontSize: 12)
    let buttonStackView         = UIStackView()
    var like = 0
    private var view = 0
    var comment = 0
    weak var commentDelegate: PresentCommentVC?
    
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
        likesCounter.text = "\(data.likes)"
        commentsCounter.text = "\(data.comments)"
        viewsCounter.text = "\(data.views)"
    }
    
    
    
    
    private func configure() {
        
        likesLabel.text = "Likes: "
        commentsLabel.text = "Comments: "
        viewsLabel.text = "Views: "
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        //PROFILE PICTURE
        addSubview(userProfileImage)
        //MENU BUTTON
        addSubview(menuButton)
        bringSubviewToFront(menuButton)
        menuButton.addTarget(self, action: #selector(showMenuOptions), for: .touchUpInside)
        
        //MEDIA VIEW AREA
        mainImageViewArea.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainImageViewArea)
        
        //LABELS
        let labels = [userNameLabel, statusLabel, locationLabel, postedLabel, titleLabel, viewsLabel, viewsCounter, messageDescriptionLabel, likesLabel, likesCounter, commentsLabel, commentsCounter]
        for label in labels {
            addSubview(label)
        }
        viewsCounter.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        commentsCounter.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        likesCounter.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        messageDescriptionLabel.numberOfLines = 2
        messageDescriptionLabel.lineBreakMode = .byTruncatingTail
        
        setupActionButtons()
        setupConstraints()
        contentView.isUserInteractionEnabled = false
    }
    
    fileprivate func setupActionButtons() {
        let actionButtons = [retweetBtn, replyBtn, likeBtn]
        for button in actionButtons {
            button.tintColor = CustomColors.CustomGreen
            buttonStackView.addArrangedSubview(button)
            buttonStackView.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
        }
        likeBtn.addTarget(self, action: #selector(liked), for: .touchUpInside)
        replyBtn.addTarget(self, action: #selector(commented), for: .touchUpInside)
        retweetBtn.addTarget(self, action: #selector(shared), for: .touchUpInside)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
        
        addSubview(buttonStackView)
    }
    
    @objc private func showMenuOptions(_ sender: UIButton) {
        self.commentDelegate?.showMenu(sender)
        
    }
    
    @objc private func shared(){
        if let val = viewsCounter.text {
            view = Int(val) ?? 0
        }
        if retweetBtn.currentTitleColor != UIColor.systemRed {
            view += 1
            retweetBtn.tintColor = .systemRed
            retweetBtn.setImage(Images.retweeted, for: .normal)
        } else {
            view -= 1
            retweetBtn.setImage(Images.retweet, for: .normal)
            retweetBtn.tintColor = CustomColors.CustomGreen
        }
        viewsCounter.text = "\(view)"
    }
   
    @objc private func liked(){
        if let val = likesCounter.text {
            like = Int(val) ?? 0
        }
        if likeBtn.currentTitleColor != UIColor.systemRed {
            like += 1
            likeBtn.tintColor = .systemRed
            likeBtn.setImage(Images.liked, for: .normal)
        } else {
            like -= 1
            likeBtn.setImage(Images.like, for: .normal)
            likeBtn.tintColor = CustomColors.CustomGreen
        }
        likesCounter.text = "\(like)"
    }
    
    @objc private func commented(_ sender: UIButton){
        if let val = commentsCounter.text {
            comment = Int(val) ?? 0
        }
        if replyBtn.currentTitleColor != UIColor.systemRed {
            comment += 1
            replyBtn.tintColor = .systemRed
            self.commentDelegate?.presentViewComments()
            replyBtn.setImage(Images.commented, for: .normal)
        } else {
            self.commentDelegate?.presentViewComments()
            comment += 1
        }
        commentsCounter.text = "\(comment)"
    }
   
 
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let textHeight: CGFloat = 15
        let textWidth: CGFloat = 30
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
        
        //Views Label
        NSLayoutConstraint.activate([
            viewsLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            viewsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textWidth),
        ])
        
        //Views Counter
        NSLayoutConstraint.activate([
            viewsCounter.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            viewsCounter.leadingAnchor.constraint(equalTo: viewsLabel.trailingAnchor, constant: 2),
            viewsCounter.widthAnchor.constraint(equalToConstant: textWidth),
            viewsCounter.heightAnchor.constraint(equalToConstant: textHeight)
        ])
        
        //comments Label
        NSLayoutConstraint.activate([
            commentsLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            commentsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -padding),
        ])
        
        //Comments Counter
        NSLayoutConstraint.activate([
            commentsCounter.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            commentsCounter.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 2),
            commentsCounter.widthAnchor.constraint(equalToConstant: textWidth),
            commentsCounter.heightAnchor.constraint(equalToConstant: textHeight)
        ])

        //likes Label
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            likesLabel.trailingAnchor.constraint(equalTo: likesCounter.leadingAnchor, constant: -2),
        ])
        
        //Likes Counter
        NSLayoutConstraint.activate([
            likesCounter.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            likesCounter.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textWidth),
            likesCounter.widthAnchor.constraint(equalToConstant: textWidth),
            likesCounter.heightAnchor.constraint(equalToConstant: textHeight)
        ])
        
        //ActionButtons
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            buttonStackView.heightAnchor.constraint(equalToConstant: textWidth),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
