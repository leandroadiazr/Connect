//
//  AlertContainerView.swift
//  Content
//
//  Created by Leandro Diaz on 1/20/21.

import UIKit

class AlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor           = .systemBackground
        layer.cornerRadius        = 16
        layer.borderColor         = UIColor.tertiaryLabel.cgColor
        layer.borderWidth         = 0.5
        layer.opacity             = 0.90
        translatesAutoresizingMaskIntoConstraints = false
    }
}
