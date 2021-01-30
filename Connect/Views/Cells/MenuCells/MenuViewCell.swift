//
//  MenuCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    
    static let reuseID = "MenuViewCell"
    
    var menuButton      = CustomMainButton(backgroundColor: .clear, title: "", textColor: CustomColors.CustomGreen, borderWidth: 1, borderColor: UIColor.clear.cgColor, buttonImage: nil)
    var userStoryLabel  = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .black)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(with menu: Menu) {
        
        if menu.buttonName == "Go Live" {
            menuButton.layer.borderColor = UIColor.systemRed.cgColor.copy(alpha: 0.7)
            menuButton.setTitleColor(.systemRed, for: .normal)
        }
        menuButton.setTitle(menu.buttonName, for: .normal)
    }
    
    
    private func configure() {
        addSubview(menuButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
//        let padding: CGFloat = 10
        
        //ImageView
        NSLayoutConstraint.activate([
            menuButton.centerYAnchor.constraint(equalTo: self.centerYAnchor ),
            menuButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
}
