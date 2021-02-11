//
//  profileAreaPostViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/28/21.
//

import UIKit

class ProfileAreaPostViewCell: UICollectionViewCell {
    static let reuseID          = "profileAreaPostViewCell"
    let userProfileImage        = CustomAvatarImage(frame: .zero)
 
    let menuButton              = CustomMenuButton()
    let userNameLabel           = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let statusLabel             = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
    let postedLabel             = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 12)
    
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
        userProfileImage.cacheImage(from: data.profileImage)
        userNameLabel.text = data.name
        
        //FEEDS
            statusLabel.text = data.status
            postedLabel.text = String(data.postedOn.timeIntervalSinceNow)
        
    }
    
    private func configure() {
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        //PROFILE PICTURE
        addSubview(userProfileImage)
        //        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        //MENU BUTTON
        //        menuButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuButton)

        
        //LABELS
        let labels = [userNameLabel, statusLabel, postedLabel]
        for label in labels {
            addSubview(label)
        }
        
        setupActionButtons()
        setupConstraints()
    }
    
    fileprivate func setupActionButtons() {

    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
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
        
   
    }
}
