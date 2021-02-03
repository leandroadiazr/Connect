//
//  Extension.swift
//  Content
//
//  Created by Leandro Diaz on 1/15/21.
//

import UIKit


extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat, alpha: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat, alpha: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat, alpha: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height + width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat, alpha: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    //    func activateBorders(color: UIColor, width: CGFloat, alpha: CGFloat) {
    //        let border = CALayer()
    //        border.frame = CGRect(x: 0, y: 0, width: width, height: width)
    //        border.backgroundColor = color.cgColor.copy(alpha: alpha)
    //        self.layer.addSublayer(border)
    //    }
}


//MARK:- EXTENSION TABLEVIEW
extension UITableViewCell {
    //generate random Color
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 0.6)
    }
}

//MARK:- TAB BAR APPEARANCE & TRANSPARENCY
extension UITabBar {
    static func setTransparency() {
        let transparent = UIImage()
        UITabBar.appearance().backgroundImage = transparent
        UITabBar.appearance().backgroundColor = UIColor.systemBackground.withAlphaComponent(1)//UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
    }
}

//MARK:- TAB BAR APPEARANCE & TRANSPARENCY
extension UIImageView {
    static func setTransparency() {
        let transparent = UIImage()
        UITabBar.appearance().backgroundImage = transparent
        UITabBar.appearance().backgroundColor = UIColor.systemBackground.withAlphaComponent(1)//UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
    }
}

//MARK:- GRADIENT VIEW CONTROLLERS EXTENSION
extension UIViewController {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 1.5)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 0.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK:- CUSTOM SHADOW EXTENSION WITH BORDER&ROUNDCORNERS
extension UIView {
    func applyCustomShadow() {
        self.backgroundColor = UIColor.clear // Use anycolor that give you a 2d look.
        //To apply corner radius
        self.layer.cornerRadius = 5
        
        //To apply border
        self.layer.borderWidth = 0.15
        self.layer.borderColor = UIColor.label.cgColor
        
        //To apply Shadow
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: -7, height: 5) // Use any CGSize
        self.layer.shadowColor = UIColor.systemGray.cgColor
        
        self.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
    }
}

extension UIView {
    func applyCustomRoundShadow() {
        self.backgroundColor = UIColor.systemBackground // Use anycolor that give you a 2d look.
        //To apply corner radius
        
        self.layer.cornerRadius = 5
        
        
        //To apply border
        self.layer.borderWidth = 0.15
        self.layer.borderColor = UIColor.label.cgColor
        
        //To apply Shadow
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: -7, height: 5) // Use any CGSize
        self.layer.shadowColor = UIColor.systemGray.cgColor
        
        self.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
    }
}

//MARK:- CUSTOM TEXTFIELD BOTTOM LINE WITH COLOR
extension UITextField {
    func styleTextField(color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2)
        bottomLine.backgroundColor = color.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
}
