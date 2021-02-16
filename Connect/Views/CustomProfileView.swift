//
//  CustomProfileView.swift
//  Connect
//
//  Created by Leandro Diaz on 2/16/21.
//

import UIKit

class CustomProfileView: UIView {
    
    let profilePic      = CustomAvatarImage(frame: .zero)
    let userNameLabel   = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 18)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, profilePic: String, userName: String) {
        self.init(frame: frame)
        self.profilePic.cacheImage(from: profilePic)
        self.userNameLabel.text = userName
    }
    
    
    private func configure() {
        backgroundColor = .yellow
        addSubview(profilePic)
        profilePic.layer.cornerRadius = 20
        addSubview(userNameLabel)
        
        layer.borderWidth = 1
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        profilePic.widthAnchor.constraint(equalToConstant: 40),
        profilePic.heightAnchor.constraint(equalToConstant: 40),
        
        userNameLabel.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 10),
        userNameLabel.centerYAnchor.constraint(equalTo: profilePic.centerYAnchor),
        userNameLabel.widthAnchor.constraint(equalToConstant: 55),
        userNameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])

    }

}
