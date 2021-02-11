//
//  MessagesManager.swift
//  Connect
//
//  Created by Leandro Diaz on 2/9/21.
//

import Foundation
import FirebaseDatabase

class MessagesManager {
    static let shared =  MessagesManager()
    private let database = Database.database().reference()
    
    func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
    
    func getChatUsers(completion: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            var userProfile: UserProfile?
            
            guard let data = snapshot.value as? [String: Any] else { return }
            print(data)
            
            //            for user in data {
            let dictionary = data
            if  let userID = dictionary["userID"] as? String,
                let name = dictionary["name"] as? String,
                let email = dictionary["email"] as? String,
                let profileImage = dictionary["profileImage"] as? String {
                userProfile = UserProfile(id: "", userID: userID, name: name, handler: "@\(name)", email: email, profileImage: profileImage, userLocation: "", userBio: "", userStatus: "")
            }
            completion(.success(userProfile))
        }
        //        }
    }
    
    func createMessage(with message: Message, user: UserProfile?, completion: @escaping (Bool)-> Void) {
        guard let userProfile = user else { return }
        
        let ref = database.child("messages").child(userProfile.userID).childByAutoId()
        ref.observeSingleEvent(of: .value) { snapshot in
            
            guard let userNode = snapshot.value else {
                completion(false)
                print("user not found")
                return
            }
            print(userNode)
            
            var contentMessage = ""
            
            switch message.kind {
            case .text(let messageText):
                contentMessage = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            case .linkPreview(_):
                break
            }
            
            let newConversation: [String: Any] = [
                "userID": userProfile.userID,
                "name": userProfile.name,
                "email": userProfile.email,
                "id": message.messageId,
                "recepient": userProfile.userID,
                "date": message.sentDate.convertToMonthYearFormat(),
                "latest_message": [
                    "date": message.sentDate.convertToMonthYearFormat(),
                    "message": contentMessage,
                    "is_read": false
                ]
            ]
            if message.messageId.isEmpty {
                ref.updateChildValues(newConversation) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
            }else {
                ref.setValue(newConversation) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
        
    }
    
    func appendMessages(userEmail: String, message: Message, completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
        
    }
    
    func usersMessages(userID: String, message: Message, completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
//        let ref = database.child("messages")
//        ref.observeSingleEvent(of: .childAdded) { snapshot in
//            if let dictionary = snapshot.value as? [String: Any],
//                
//             let userID         = dictionary["userID"] as? String,
//             let name           = dictionary["name"] as? String,
//             let email          = dictionary["email"] as? String,
//             let messageId      = dictionary["id"] as? String,
//             let recepient      = dictionary["recepient"] as? String,
//             let date           = dictionary["date"] as? String,
//             let latestMessage  = dictionary["latest_message"] as? [String: Any],
//             let dateReceived   = latestMessage["date"] as? String,
//             let message        = latestMessage["message"] as? String,
//             let isRead         = latestMessage["is_read"] as? String {
//             
//                let chatUser = ChatUser(userID: userID, name: name, email: email, messageId: messageId, recepient: recepient, date: date, latestMessage: latestMessage, dateReceived: dateReceived, message: message, isRead: isRead)
//            }
//        }
        
    }
    
    func retreivedAllUsersMessages(messageID: String, message: Message, completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
        
        
    }



}
