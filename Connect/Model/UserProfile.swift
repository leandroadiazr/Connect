//
//  UserProfile.swift
//  Content
//
//  Created by Leandro Diaz on 1/29/21.
//

import Foundation


struct UserProfile: Codable, Hashable {
    var userID: UUID
    var name: String
    var handler: String
    var email: String
    var password: String
    var profileImage: String
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.userID == rhs.userID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
}
