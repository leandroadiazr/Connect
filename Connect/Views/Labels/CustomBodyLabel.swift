//
//  CustomBodyLabel.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

class CustomBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, backgroundColor: UIColor, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    
    private func configure(){
        textColor                    = .label
        adjustsFontSizeToFitWidth    = true
        minimumScaleFactor           = 0.75
        lineBreakMode                = .byWordWrapping
        numberOfLines                = 0
        font = UIFont.preferredFont(forTextStyle: .body)
        translatesAutoresizingMaskIntoConstraints = false
    }

}
