//
//  ProfileViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/29/21.
//

import UIKit

class UserProfileViewCell: UICollectionViewCell {
    static let reuseID          = "UserProfileViewCell"
    
    let userProfileImage        = CustomAvatarImage(frame: .zero)
    let userProfileImgTwo       = GenericImageView(frame: .zero)
    let userProfileImgThree     = GenericImageView(frame: .zero)
    let userProfileImgFour      = GenericImageView(frame: .zero)
    let menuButton              = CustomMenuButton()
    let userNameLabel           = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let bio                     = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let statusLabel             = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
    let postedLabel             = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 12)
    let titleLabel              = CustomSecondaryTitleLabel(title: "", fontSize: 15, textColor: .label)
    let locationLabel           = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .systemGray)
    let messageDescriptionLabel = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 11)
    let labelsStackView         = UIStackView()
    let buttonStackView         = UIStackView()
    
    let editProfileBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.editUser, for: .normal)
        return btn
    }()
    
    let shareUser        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.shareUser, for: .normal)
        return btn
    }()
    
    let saveUser        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.saveUserChanges, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(with userProfile: UserProfile?){
        guard let user = userProfile else { return }
        userProfileImage.cacheImage(from: user.profileImage)
        userNameLabel.text = user.name
        statusLabel.text = user.userStatus
        postedLabel.text = user.userStatus
        titleLabel.text = user.userBio
        locationLabel.text = user.userLocation
    }
    
    
    private func configure() {
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        //PROFILE PICTURE
        userProfileImage.applyCustomShadow()
        userProfileImage.layer.cornerRadius = 40
        addSubview(userProfileImage)
        
        //MENU BUTTON
        addSubview(menuButton)
        
        //MEDIA VIEW AREA
        let profileImages = [userProfileImgTwo, userProfileImgThree, userProfileImgFour]
        for imageView in profileImages {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .lightGray
            imageView.applyCustomShadow()
            imageView.clipsToBounds = true
            addSubview(imageView)
        }
        
        //LABELS
        let labels = [userNameLabel, statusLabel, postedLabel, titleLabel, locationLabel, messageDescriptionLabel]
        for label in labels {
            addSubview(label)
        }
        messageDescriptionLabel.numberOfLines = 5
        messageDescriptionLabel.lineBreakMode = .byTruncatingTail
        
        setupActionButtons()
        setupConstraints()
    }
    
    fileprivate func setupActionButtons() {
        let actionButtons = [editProfileBtn, shareUser, saveUser]
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
        
        //ProfileImage
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            userProfileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            userProfileImage.widthAnchor.constraint(equalToConstant: 80),
            userProfileImage.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        //User name Label
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: bottomPadding),
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
            userProfileImgTwo.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: bottomPadding),
            userProfileImgTwo.trailingAnchor.constraint(equalTo: userProfileImgThree.leadingAnchor, constant: -padding),
            userProfileImgTwo.widthAnchor.constraint(equalToConstant: 100),
            userProfileImgTwo.heightAnchor.constraint(equalToConstant: 100)
        ])
        //MediaViewArea 2
        NSLayoutConstraint.activate([
            userProfileImgThree.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: bottomPadding),
            userProfileImgThree.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userProfileImgThree.widthAnchor.constraint(equalToConstant: 100),
            userProfileImgThree.heightAnchor.constraint(equalToConstant: 100)
        ])
        //MediaViewArea 3
        
        NSLayoutConstraint.activate([
                userProfileImgFour.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: bottomPadding),
                userProfileImgFour.leadingAnchor.constraint(equalTo: userProfileImgThree.trailingAnchor, constant: padding),
                userProfileImgFour.widthAnchor.constraint(equalToConstant: 100),
                userProfileImgFour.heightAnchor.constraint(equalToConstant: 100)
        
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
            messageDescriptionLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -bottomPadding),
            messageDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
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
