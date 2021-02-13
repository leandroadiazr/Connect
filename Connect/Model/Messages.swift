//
//  Messages.swift
//  Connect
//
//  Created by Leandro Diaz on 2/13/21.
//

import Foundation

struct Messages {
    var senderID: String
    var senderName: String
    var senderProfileImage: String
    
    var recipientID: String
    var recipientName: String
    var recipientProfileImage: String
    
    var textMessage: String
    var timeStamp: NSNumber
    var isRead: Bool
    
}

//let newMessage = Messages(senderID: sender.userID, senderName: sender.name, senderProfileImage: sender.profileImage, recipientID: recipient.userID, recipientName: recipient.name, recipientProfileImage: recipient.profileImage, textMessage: textMessage, timeStamp: timeStamp, isRead: isRead)
