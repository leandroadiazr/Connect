//
//  CreateFeedPostCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import UIKit

class PostsFeedCell: UICollectionViewCell {
    static let reuseID          = "PostFeedCell"
   
    let mainImageViewArea       = GenericImageView(frame: .zero)
    let imageViewAreaTwo        = GenericImageView(frame: .zero)
    let imageViewAreaThree      = GenericImageView(frame: .zero)
    let titleLabel              = CustomSecondaryTitleLabel(title: "", fontSize: 15, textColor: .label)
    let locationLabel           = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .systemGray)
    let messageDescriptionLabel = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 11)
    let likesLabel              = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    let commentsLabel           = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    let viewsLabel              = CustomBodyLabel(textAlignment: .right, backgroundColor: .clear, fontSize: 10)
    let labelsStackView         = UIStackView()
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
        locationLabel.text = data.location
        
        //FEEDS
//        for feed in data.feed! {
            mainImageViewArea.cacheImage(from: data.mainImage) //= UIImage(named: with.media)
            titleLabel.text = data.postTitle
            messageDescriptionLabel.text = data.messageDescription
            likesLabel.text =       "\(data.likes)"
            commentsLabel.text =    "\(data.comments)"
            viewsLabel.text =       "\(data.views)"
//        }
    }
    
    private func configure() {
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        
        //MEDIA VIEW AREA
        let mediaViews = [mainImageViewArea, imageViewAreaTwo, imageViewAreaThree]
        for imageView in mediaViews {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .lightGray
            imageView.applyCustomShadow()
            imageView.clipsToBounds = true
            addSubview(imageView)
        }
        
        //LABELS
        let labels = [titleLabel, locationLabel, viewsLabel, messageDescriptionLabel, likesLabel, commentsLabel]
        for label in labels {
            addSubview(label)
        }
        messageDescriptionLabel.numberOfLines = 5
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
        let bottomPadding: CGFloat = 20
        let mediaHeight: CGFloat = contentView.frame.height / 3
        let mediaWidth: CGFloat = contentView.frame.width / 2.05
        
        //ProfileImage
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
        
        //MediaViewArea
        NSLayoutConstraint.activate([
            mainImageViewArea.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            mainImageViewArea.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mainImageViewArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            mainImageViewArea.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        //MediaViewArea 2
        NSLayoutConstraint.activate([
            imageViewAreaTwo.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageViewAreaTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageViewAreaTwo.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageViewAreaTwo.heightAnchor.constraint(equalToConstant: mediaHeight * 0.8)
        ])
        //MediaViewArea 3
        
        NSLayoutConstraint.activate([
            imageViewAreaThree.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageViewAreaThree.leadingAnchor.constraint(equalTo: imageViewAreaTwo.trailingAnchor, constant: padding),
            imageViewAreaThree.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageViewAreaThree.heightAnchor.constraint(equalToConstant: mediaHeight * 0.8)
        ])
        
        //Title Label
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
        ])
        
        //User name Label
        NSLayoutConstraint.activate([
            locationLabel.bottomAnchor.constraint(equalTo: messageDescriptionLabel.topAnchor, constant: -padding),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            messageDescriptionLabel.bottomAnchor.constraint(equalTo: likesLabel.topAnchor, constant: -padding),
            messageDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
        
        //likes Label
        NSLayoutConstraint.activate([
            likesLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -bottomPadding),
            likesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        ])
        
        //comments Label
        NSLayoutConstraint.activate([
            commentsLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -bottomPadding),
            commentsLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: padding),
        ])
        
        //Views Label
        NSLayoutConstraint.activate([
            viewsLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -bottomPadding),
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
