//
//  StoryViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit

class StoryViewCell: UICollectionViewCell {
    
    static let reuseID      = "StoryViewCell"
    
    var userProfileImage    = CustomAvatarImage(frame: .zero)
    var userNameLabel       = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(with story: User) {
        if story.profileImage == "" {
            userProfileImage.image = UIImage(named: Images.Avatar)
        }
        userProfileImage.image = UIImage(named: story.profileImage)
        userNameLabel.text = story.name
    }
    
    
    private func configure() {
        userProfileImage.layer.cornerRadius = 25
        userProfileImage.layer.borderWidth  = 1
        userProfileImage.layer.borderColor  = CustomColors.CustomGreen.cgColor
        addSubview(userProfileImage)
        addSubview(userNameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        //ImageView
        NSLayoutConstraint.activate([
            userProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -padding ),
            userProfileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userProfileImage.widthAnchor.constraint(equalToConstant: 50),
            userProfileImage.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        //UserStoryLabel
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: padding ),
            userNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}
