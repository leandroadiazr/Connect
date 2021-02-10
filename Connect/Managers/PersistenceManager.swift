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
}
