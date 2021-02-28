//
//  Constants.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

//MARK:- CUSTOM IMAGES
enum Images {
    static let Logo                 = UIImage(systemName: "person")
    static let Avatar               = "emptyAvatar"//UIImage(systemName: "person.circle")
    static let profilePic           = "headShot"//UIImage(named: "headShot")
    static let followPlus           = UIImage(systemName: "person.crop.circle.fill.badge.plus")?.withTintColor(CustomColors.CustomRed)
    
    //MARK:- CUSTOMIZED BUTTONS
    static let comment              = UIImage(systemName: "bubble.left")
    static let commented            = UIImage(systemName: "bubble.left.and.bubble.right.fill")
    static let retweet              = UIImage(systemName: "arrow.2.squarepath")
    static let retweeted            = UIImage(systemName: "hands.sparkles.fill")
    static let like                 = UIImage(systemName: "heart")
    static let liked                = UIImage(systemName: "hand.thumbsup.fill")
    static let share                = UIImage(systemName: "square.and.arrow.up")
    static let search               = UIImage(systemName: "magnifyingglass")
    static let newTweet             = UIImage(systemName: "note.text")
    static let menu                 = UIImage(systemName: "square.stack.3d.up")
    static let editUser             = UIImage(systemName: "highlighter")
    static let shareUser            = UIImage(systemName: "paperplane")
    static let saveUserChanges      = UIImage(systemName: "square.and.arrow.down.on.square")
    static let camera      = UIImage(systemName: "camera")
    
    
    //MARK:- BACKGROUND IMAGES
    static let topBackground        = UIImage(named: "Ovals")
    static let botBackground        = UIImage(named: "BottomOvals")
    static let bubbleImage          = UIImage(systemName: "bubble.left.and.bubble.right.fill")
    static let startsYellow         = UIImage(named: "Glitters")
    static let backMedia            = "background"//UIImage(named: "background")
    static let Empty                = UIImage(systemName: "link.icloud.fill")
    static let senderChatBubble     = UIImage(systemName: "bubble.right.fill")
    static let recipientChatBubble  = UIImage(systemName: "bubble.left.fill")
    
    //MARK:- TAB BAR ICONS
    static let home                 = UIImage(systemName: "house")
    static let homeFill             = UIImage(systemName: "house.fill")
    static let feeds                = UIImage(systemName: "newspaper")
    static let feedsFill            = UIImage(systemName: "newspaper.fill")
    static let post                 = UIImage(systemName: "plus.circle.fill")
    static let postFill             = UIImage(systemName: "plus.circle.fill")
    static let discussion           = UIImage(systemName: "rectangle.3.offgrid.bubble.left")
    static let discusFill           = UIImage(systemName: "rectangle.3.offgrid.bubble.left.fill")
    static let userArea             = UIImage(systemName: "person.icloud")
    static let userAreaFill         = UIImage(systemName: "person.icloud.fill")
    static let hiBtnImage           = UIImage(systemName: "rectangle.3.offgrid.bubble.left.fill")
    
    //MARK:- IMPORTED IMAGES
    static let greenPlus            = UIImage(named: "GreenPlus")
    static let buttonActive         = UIImage(named: "ButtonActive")
    static let buttonDisable        = UIImage(named: "ButtonDisabled")
    static let loginWithFB          = UIImage(named: "loginFB")
    static let loginWGoogle         = UIImage(named: "loginGoogle")
    
    //MARK:- CHAT IMAGES
    static let bubbleRight          = UIImage(named: "bubbleRight")
    static let bubbleLeft           = UIImage(named: "bubbleLeft")
    
}

enum Status {
    static let Active               = "Active"
    static let Away                 = "Away"
    static let Offline              = "Offline"
}


//MARK:- CUSTOM COLORS
enum CustomColors {
    static let CustomBlue           = #colorLiteral(red: 0.01568627451, green: 0.4196078431, blue: 0.6, alpha: 1)
    static let CustomGreenLightBright = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
    static let CustomRed            = #colorLiteral(red: 0.8856633306, green: 0.3753367662, blue: 0.2555282116, alpha: 1)   //UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.2)
    static let CustomGreen          = #colorLiteral(red: 0.3098039216, green: 0.4392156863, blue: 0.1607843137, alpha: 1)
    static let CustomGreenGradient  = #colorLiteral(red: 0.2666666667, green: 0.3882352941, blue: 0.03921568627, alpha: 1)
    static let CustomGreenBright    = #colorLiteral(red: 0.4901960784, green: 0.8745098039, blue: 0.04705882353, alpha: 1)
    static let SeparatorColor       = #colorLiteral(red: 0.5098039216, green: 0.05098039216, blue: 0.007843137255, alpha: 0.8966716609)
    static let CellBackgroundColor  = UIColor.systemBackground
    static let CustomBackgroundColor = #colorLiteral(red: 1, green: 0.9254901961, blue: 0.9254901961, alpha: 1)  //UIColor(red: 232/255, green: 236/255, blue: 241/255, alpha: 1) FFDEC5 / FFECEC
    static let Transparent          = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    static let White                = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

//MARK:- CUSTOM VIEWCONTROLLER CONSTANTS
enum CustomViewControllers {
    static let loginViewController  = "loginViewController"
    static let signUpViewController = "SignUpViewController"
    static let homeViewController   = "HomeViewController"
}

public let separatorLine: UIView = {
    let lineView                    = UIView()
    lineView.backgroundColor        = CustomColors.CustomGreen
    lineView.isHidden               = true
    return lineView
}()

//MARK:- SCREEN SIZES

enum ScreenSize {
    static let width                = UIScreen.main.bounds.size.width
    static let height               = UIScreen.main.bounds.size.height
    static let maxLength            = max(ScreenSize.width, ScreenSize.height)
    static let minLength            = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                = UIDevice.current.userInterfaceIdiom
    static let nativeScale          = UIScreen.main.nativeScale
    static let scale                = UIScreen.main.scale
    
    static let isiPhoneSE           = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard    = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed      = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed  = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX            = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr   = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad               = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}


public func convertFromShortDate() -> DateFormatter? {
    let dateformatter = DateFormatter()
    dateformatter.dateStyle = .medium
    dateformatter.timeStyle = .long
    dateformatter.locale = .current
    return dateformatter
}
