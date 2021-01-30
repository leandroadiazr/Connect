//
//  CustomLine.swift
//  Content
//
//  Created by Leandro Diaz on 1/15/21.
//

import UIKit

class CustomLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.red.cgColor
        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }

}
