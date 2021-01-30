//
//  HomeCollectionViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let reuseID  = "CollectionViewCell"
    let viewImage       = UIImageView()
    let userNameLabel   = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 20)
    let handlerLabel    = CustomSubtitleLabel(fontSize: 16, backgroundColor: .clear)
    let bioLabel        = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 14)
    let iconButton      = CustomMainButton(backgroundColor: .clear, title: "Follow", textColor: CustomColors.CustomRed, borderWidth: 1, borderColor: UIColor.systemRed.cgColor, buttonImage: Images.followPlus)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with user: User) {
        userNameLabel.text = user.name
        handlerLabel.text  = user.handler
        bioLabel.text      = user.bio
        viewImage.image = UIImage(named: Images.profilePic)
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 0.3, alpha: 0.7)
        
        addSubview(userNameLabel)
        addSubview(handlerLabel)
        addSubview(bioLabel)
        addSubview(iconButton)
        iconButton.tintColor = CustomColors.CustomGreen
        
        
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        viewImage.clipsToBounds = true
        viewImage.layer.cornerRadius = 8
        viewImage.tintColor = CustomColors.CustomGreen
        addSubview(viewImage)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            viewImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            viewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            viewImage.widthAnchor.constraint(equalToConstant: 60),
            viewImage.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            userNameLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            userNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            userNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            handlerLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 0),
            handlerLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            handlerLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            handlerLabel.heightAnchor.constraint(equalToConstant: 18),
            
            iconButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding + 5),
            iconButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            iconButton.widthAnchor.constraint(equalToConstant: 115),
            iconButton.heightAnchor.constraint(equalToConstant: 38),
            
            bioLabel.topAnchor.constraint(equalTo: iconButton.bottomAnchor, constant: 0),
            bioLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            bioLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

}
