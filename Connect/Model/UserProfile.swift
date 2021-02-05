//
//  UserProfile.swift
//  Content
//
//  Created by Leandro Diaz on 1/29/21.
//

import Foundation

protocol UserProfileSerializable {
    init?(dictionary: [String: Any])
    
}

struct UserProfile: Codable, Hashable {
    var id = UUID()
    var userID: String
    var name: String
    var handler: String
    var email: String
    var profileImage: String
    var userLocation: String
    var userBio: String
    var status: String
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var userDictionary : [String: Any] {
        return [
            "userID"        : userID,
            "profileImage"  : profileImage,
            "name"          : name,
            "handler"       : handler,
            "email"         : email,
            "bio"           : userBio,
            "location"      : userLocation,
            "status"        : status
        ]
    }
    
}

extension UserProfile: UserProfileSerializable {
    init?(dictionary: [String : Any]) {
      
guard   let userID              = dictionary["userID"]           as? String,
        let name                = dictionary["name"]             as? String,
        let handler             = dictionary["handler"]          as? String,
        let email               = dictionary["email"]            as? String,
        let profileImage        = dictionary["profileImage    "] as? String,
        let userLocation        = dictionary["location        "] as? String,
        let userBio             = dictionary["userBio         "] as? String,
        let status              = dictionary["status          "] as? String else {return nil}
        
        self.init(userID: userID, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, status: status)
    }
}


