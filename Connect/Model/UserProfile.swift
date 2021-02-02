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
    var userID: String
    var name: String
    var handler: String
    var email: String
    var password: String
    var profileImage: URL
    var backUpImageOne: URL
    var backUpImageTwo: URL
    var backUpImageThree: URL
    var location: String
    var userBio: String
    var status: String
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.userID == rhs.userID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
}


extension UserProfile: UserProfileSerializable {
    init?(dictionary: [String : Any]) {
      
guard   let userID              = dictionary["userID"]           as? String,
        let name                = dictionary["name"]             as? String,
        let handler             = dictionary["handler"]          as? String,
        let email               = dictionary["email"]            as? String,
        let password            = dictionary["password"]         as? String,
        let profileImage        = dictionary["profileImage    "] as? URL,
        let backUpImageOne      = dictionary["backUpImageOne  "] as? URL,
        let backUpImageTwo      = dictionary["backUpImageTwo  "] as? URL,
        let backUpImageThree    = dictionary["backUpImageThree"] as? URL,
        let location            = dictionary["location        "] as? String,
        let userBio             = dictionary["userBio         "] as? String,
        let status              = dictionary["status          "] as? String else {return nil}
        
        self.init(userID: userID, name: name, handler: handler, email: email, password: password, profileImage: profileImage, backUpImageOne: backUpImageOne, backUpImageTwo: backUpImageTwo, backUpImageThree: backUpImageThree, location: location, userBio: userBio, status: status)
    }
}
