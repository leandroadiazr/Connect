//
//  EmptyState.swift
//  Content
//
//  Created by Leandro Diaz on 1/27/21.
//

import UIKit

class EmptyState: UIView {

    let messageLabel = CustomTitleLabel(title: "Uff... Nothing to show here yet", textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String){
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(logoImageView)
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        messageLabel.textColor = CustomColors.CustomGreen
        
        logoImageView.image = Images.Empty
        logoImageView.tintColor = CustomColors.CustomGreenGradient
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 22),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -78)
            
        ])
    }

}
