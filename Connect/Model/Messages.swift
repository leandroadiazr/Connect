//
//  Messages.swift
//  Connect
//
//  Created by Leandro Diaz on 2/13/21.
//

import Foundation
protocol MessagesSerializable {
    init?(dictionary: [String: Any])
}
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


extension Messages: MessagesSerializable {
    init?(dictionary: [String : Any]) {
        
        guard let senderID              = dictionary["senderID"] as? String,
              let senderName            = dictionary["senderName"] as? String,
              let senderProfileImage    = dictionary["senderProfileImage"] as? String,
              let recipientID           = dictionary["recipientID"] as? String,
              let recipientName         = dictionary["recipientName"] as? String,
              let recipientProfileImage = dictionary["recipientProfileImage"] as? String,
              let textMessage           = dictionary["textMessage"] as? String,
              let timeStamp             = dictionary["timeStamp"] as? NSNumber,
              let isRead                = dictionary["isRead"] as? String else { return nil }
              let readed: Bool = isRead == "false" ? false : true
        self.init(senderID: senderID, senderName: senderName, senderProfileImage: senderProfileImage, recipientID: recipientID, recipientName: recipientName, recipientProfileImage: recipientProfileImage, textMessage: textMessage, timeStamp: timeStamp, isRead: readed)
    }
    
    
}

//let newMessage = Messages(senderID: sender.userID, senderName: sender.name, senderProfileImage: sender.profileImage, recipientID: recipient.userID, recipientName: recipient.name, recipientProfileImage: recipient.profileImage, textMessage: textMessage, timeStamp: timeStamp, isRead: isRead)
