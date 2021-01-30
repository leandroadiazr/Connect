//
//  CustomSubtitleLabel.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

class CustomSubtitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        self.backgroundColor = backgroundColor
    }
    
    private func configure(){
        textColor                    = .secondaryLabel
        adjustsFontSizeToFitWidth    = true
        minimumScaleFactor           = 0.90
        lineBreakMode                = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
