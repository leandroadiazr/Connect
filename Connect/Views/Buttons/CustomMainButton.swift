//
//  CustomMainButton.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

class CustomMainButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(backgroundColor: UIColor, title: String, textColor: UIColor, borderWidth: CGFloat, borderColor: CGColor, buttonImage: UIImage?) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.setImage(buttonImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 8
        setTitleColor(.label, for: .normal)
        titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
        
//        setupConstraints()
    }
    
    
    private func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        setTitleColor(CustomColors.CustomRed, for: .normal)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 38)
        ])
    }

}
