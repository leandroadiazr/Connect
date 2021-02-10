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
    private let database = Database.database()
    
    func uploadMessages(userID: String, message: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
     
        
    }
    
    func retreivedMessages(message: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>)-> Void) {
        
        
    }
    
    
    
}
