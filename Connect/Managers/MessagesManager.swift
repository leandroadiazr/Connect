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
    
    func getChatUsers(completion: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            var userProfile: UserProfile?
            
            guard let data = snapshot.value as? [[String: Any]] else { return }
            for user in data {
               let dictionary = user
                 if let name = dictionary["name"] as? String,
                   let email = dictionary["email"] as? String,
                   let profileImage = dictionary["profileImage"] as? String {
                    userProfile = UserProfile(id: "", userID: "", name: name, handler: "@\(name)", email: email, profileImage: profileImage, userLocation: "", userBio: "", userStatus: "")
                }
                completion(.success(userProfile))
            }
        }
    }
    
    func uploadMessages(userID: String, message: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
        
        
    }
    
    func retreivedMessages(message: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
        
        
    }
    
    
    
    
    
}
