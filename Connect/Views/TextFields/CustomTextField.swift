//
//  CustomTextField.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, placeholder: String) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .black)
        self.placeholder = placeholder
    }
    
    private func configure(){
        layer.cornerRadius                        = 5
        layer.borderWidth                         = 1
        layer.borderColor                         = UIColor.tertiaryLabel.cgColor
        
        textAlignment                             = .center
        textColor                                 = .label
        tintColor                                 = .label
        font                                      = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth                 = true
        minimumFontSize                           = 10
        
        placeholder                               = "Search for position"
        
        backgroundColor                           = .tertiarySystemBackground
        autocorrectionType                        = .no
        
        keyboardType                              = .default
        returnKeyType                             = .search
        clearButtonMode                           = .whileEditing
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
