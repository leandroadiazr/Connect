//
//  CustomMenuButton.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit

class CustomMenuButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String, textColor: UIColor, borderWidth: CGFloat, borderColor: CGColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        
    }
    
    private func configure() {
        layer.cornerRadius = 8
        setTitleColor(.systemGray, for: .normal)
        titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        self.setImage(Images.menu, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        
        
        setupConstraints()
    }
    
    
    private func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        setTitleColor(.clear, for: .normal)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 38)
        ])
    }

}
