//
//  CustomTextView.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit

class CustomTextView: UITextView {

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .thin)
    }
    
    private func configure(){
        textColor                   = .label
        isSelectable                = true
        translatesAutoresizingMaskIntoConstraints = false
    }

}
