//
//  MessagesManager.swift
//  Connect
//
//  Created by Leandro Diaz on 2/9/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class MessagesManager {
    static let shared =  MessagesManager()
    private let database = Database.database().reference()
    
    func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
    func getAllUsers(completiong: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        database.child("users").observe( .childAdded) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completiong(.failure(.unableToFindUser))
                return
            }
            print(snapshot)
        }
    }
    
    func observeRecipientUserProfile(userID: String, completion: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        database.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            var userProfile: UserProfile?
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.unableToFindUser))
                return
            }
            print(value)
            let dictionary = value
            guard let email = dictionary["email"] as? String,
                  let name = dictionary["name"] as? String,
                  let profileImage = dictionary["profileImage"] as? String,
                  let userID = dictionary["userID"] as? String else { return }
            userProfile = UserProfile(id: "", userID: userID, name: name, handler: "@\(name)", email: email, profileImage: profileImage, userLocation: "", userBio: "", userStatus: "")
            
            completion(.success(userProfile))
        }
    }
    
    
    
    
    func getChatUsers(completion: @escaping (Result<[UserProfile]?, ErrorMessages>) -> Void) {
        var userProfile = [UserProfile]()
        
        database.child("users").observe( .childAdded) { snapshot in
            
            print(snapshot)
            guard let data = snapshot.value as? [String: Any] else { return }
            print(data)
            let dictionary = data
            if let email = dictionary["email"] as? String,
               let name = dictionary["name"] as? String,
               let profileImage = dictionary["profileImage"] as? String,
               let userID = dictionary["userID"] as? String {
                let singleUser = UserProfile(id: "", userID: userID, name: name, handler: "@\(name)", email: email, profileImage: profileImage, userLocation: "", userBio: "", userStatus: "")
                userProfile.append(singleUser)
            }
            completion(.success(userProfile))
        }
    }
    
    func createMessage(from currentUser: UserProfile?, with message: Message, for recipientUser: UserProfile?, completion: @escaping (Bool)-> Void) {
        guard let userProfile = currentUser else { return }
        guard let recipientUser = recipientUser else { return }
        
        //save for sender
        let sender = database.child("messages").child(userProfile.userID)
        sender.observeSingleEvent(of: .value) { snapshot in
            
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
                "userProfileImage": userProfile.profileImage,
                "name": userProfile.name,
                "email": userProfile.email,
                "messageID": message.messageId,
                "recipientID": recipientUser.userID,
                "recipientName": recipientUser.name,
                "recipientProfileImage": recipientUser.profileImage,
                "date": message.sentDate.convertToMonthYearFormat(),
                "latestMessage": [
                    "dateReceived": message.sentDate.convertToMonthYearFormat(),
                    "message": contentMessage,
                    "isRead": false
                ]
            ]
            
            if message.messageId.isEmpty {
                sender.updateChildValues(newConversation) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
            }else {
                sender.setValue(newConversation) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
        completion(true)
      
        /**************/
//        
//        //save for sender
//        let ref = database.child("messages").child(recipientUser.userID).childByAutoId()
//        ref.observeSingleEvent(of: .value) { snapshot in
//            
//            guard let userNode = snapshot.value else {
//                completion(false)
//                print("user not found")
//                return
//            }
//            print(userNode)
//            
//            var contentMessage = ""
//            
//            switch message.kind {
//            case .text(let messageText):
//                contentMessage = messageText
//            case .attributedText(_):
//                break
//            case .photo(_):
//                break
//            case .video(_):
//                break
//            case .location(_):
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .custom(_):
//                break
//            case .linkPreview(_):
//                break
//            }
//            
//            
//            let recipientConversation: [String: Any] = [
//                "userID": recipientUser.userID,
//                "userProfileImage": recipientUser.profileImage,
//                "name": recipientUser.name,
//                "email": recipientUser.email,
//                "messageID": message.messageId,
//                "recipientID": userProfile.userID,
//                "recipientName": userProfile.name,
//                "recipientProfileImage": userProfile.profileImage,
//                "date": message.sentDate.convertToMonthYearFormat(),
//                "latestMessage": [
//                    "dateReceived": message.sentDate.convertToMonthYearFormat(),
//                    "message": contentMessage,
//                    "isRead": false
//                ]
//            ]
//            if message.messageId.isEmpty {
//                ref.updateChildValues(recipientConversation) { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//                
//            }else {
//                ref.setValue(recipientConversation) { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//            }
//        }
    }
    
    func appendMessages(userEmail: String, message: Message, completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
        
    }
    
    func usersMessages(userID: String, messageID: String, completion: @escaping (Result<[Message], ErrorMessages>)-> Void) {
        database.child("messages").child(userID).observe(.childAdded) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.failedToFechFromDatabase))
                return}
            
//            print(snapshot)
            var messages = [Message]()
            let dictionary = value
            guard let userID         = dictionary["userID"] as? String,
                  let userProfileImage = dictionary["userProfileImage"] as? String,
                  let name           = dictionary["name"] as? String,
                  let email          = dictionary["email"] as? String,
                  let messageID      = dictionary["messageID"] as? String,
                  let recipientID      = dictionary["recipientID"] as? String,
                  let recipientName  = dictionary["recipientName"] as? String,
                  let recipientProfileImage = dictionary["recipientProfileImage"] as? String,
                  let date           = dictionary["date"] as? String,
                  let latestMessage  = dictionary["latestMessage"] as? [String: Any],
                  let dateReceived   = latestMessage["dateReceived"] as? String,
                  let message        = latestMessage["message"] as? String,
                  let isRead         = latestMessage["isRead"] as? Bool else { return }
            
            print(recipientID)
            let sender = Sender(senderId: userID, displayName: name, photoURL: userProfileImage)
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd yyyy"
            
            guard let currentDate = dateFormatterPrint.date(from: date) else { return }
            
            print(currentDate)
            
            let singleMessage = Message(sender: sender, messageId: messageID, sentDate: currentDate, kind: .text(message))
            messages.append(singleMessage)
            print(messages)
            completion(.success(messages))
        }
    }
    
    func getOldMessages(for userID: String, with messageID: String, completiong: @escaping (Result<[Message], ErrorMessages>) -> Void) {
        print(userID)
        database.child("messages").observe( .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completiong(.failure(.unableToFindUser))
                return
            }
            print(value)
        }
//        completiong()
    }
    
    func retreivedAllUsersMessages(userID: String, completion: @escaping (Result<[Conversations], ErrorMessages>)-> Void) {
        database.child("messages").child(userID).observe(.childAdded) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.failedToFechFromDatabase))
                return}
            
            var conversations = [Conversations]()
            let dictionary = value
            guard let userID         = dictionary["userID"] as? String,
                  let userProfileImage = dictionary["userProfileImage"] as? String,
                  let name           = dictionary["name"] as? String,
                  let email          = dictionary["email"] as? String,
                  let messageID      = dictionary["messageID"] as? String,
                  let recipientID      = dictionary["recipientID"] as? String,
                  let recipientName  = dictionary["recipientName"] as? String,
                  let recipientProfileImage = dictionary["recipientProfileImage"] as? String,
                  let date           = dictionary["date"] as? String,
                  let latestMessage  = dictionary["latestMessage"] as? [String: Any],
                  let dateReceived   = latestMessage["dateReceived"] as? String,
                  let message        = latestMessage["message"] as? String,
                  let isRead         = latestMessage["isRead"] as? Bool else { return }
            
            let latestMessageOBJ        = LatestMessage(dateReceived: dateReceived, message: message, isRead: isRead)
            let singleConversation      = Conversations(userID: userID, userProfileImage: userProfileImage, messageId: messageID, name: name, email: email, recipientID: recipientID, recipientName: recipientName, recipientProfileImage: recipientProfileImage, date: date, latestMessage: latestMessageOBJ)
            conversations.append(singleConversation)
            
            print(conversations)
            completion(.success(conversations))
        }
    }
    
    
    
}
