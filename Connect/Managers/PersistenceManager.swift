//
//  PersistenceManager.swift
//  Connect
//
//  Created by Leandro Diaz on 2/9/21.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    func saveUserToDeviceCache(user: UserProfile?, completion: @escaping (Result<String, ErrorMessages>) -> Void) {
        if let userProfile = user {
            UserDefaults.standard.setValuesForKeys(userProfile.userDictionary)
            print("this is th user saved ",userProfile)
            completion(.success("Saved"))
        } else {
            completion(.failure(.unableToSave))
        }  
    }
    
    func retreiveUserFormCache(userID: String, completion: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        var currentUser: UserProfile?
        if userID == UserDefaults.standard.value(forKey: "userID") as? String {
            let dictionary = UserDefaults.standard.dictionaryRepresentation()
            print(dictionary)
           guard let userID         = dictionary["userID"]           as? String,
            let name                = dictionary["name"]             as? String,
            let handler             = dictionary["handler"]          as? String,
            let email               = dictionary["email"]            as? String,
            let profileImage        = dictionary["profileImage"] as? String,
            let userLocation        = dictionary["userLocation"] as? String,
            let userBio             = dictionary["userBio"] as? String,
            let userStatus              = dictionary["userStatus"] as? String else {return }
            
            currentUser = UserProfile(dictionary: dictionary)
        }
        completion(.success(currentUser))
    }
}
