//
//  UsersManager.swift
//  Connect
//
//  Created by Leandro Diaz on 1/31/21.
//

import UIKit
import FirebaseAuth
import Firebase

enum ErrorMessages: String, Error {
    case unableToSave = "Unable to save this user, please verify"
    case unableToCreate = "Unable to create this user in the database"
    case unableToFindUser = "Unable to find this user, please check your credentials"
    case uknown = "There is an error"
}

class UserManager {
    private init() {}
    static let shared = UserManager()
    private var database = DatabaseReference().database.reference(withPath: "https://connect-f747d-default-rtdb.firebaseio.com/")
    private var auth = Auth.auth()
    private lazy var childCollection = "users"
    var updatedTitle = ""
    
    
    
    func saveUser(user: UserProfile, completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
        auth.createUser(withEmail: user.email, password: user.password) { (authResult, error) in
            if let _ = error {
                completion(.failure(.unableToSave))
                print(error?.localizedDescription)
                return
            }
            
            guard let uuid = authResult?.user.uid else {
                return
            }
            print("Saved suscessfully into firebase database need an alert")
            
            //ON SUSCESS SAVE TO DATABASE
            let userReference = self.database.child(self.childCollection).child(uuid)
            let values = ["name": user.name, "email": user.email, "handler": user.handler, "profileImage": user.profileImage]
            userReference.updateChildValues(values) { (error, reference) in
                if let _ = error {
                    completion(.failure(.unableToCreate))
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    func fetchUser(completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
        let reference = database.child(childCollection)
        let uid = auth.currentUser?.uid
        
            reference.child(uid!).observeSingleEvent(of: .value) { (snapShot) in
               print(snapShot)
                if let values = snapShot.value as? [String: Any] {
                    self.updatedTitle = values["name"] as! String
                    
                    print("user retreived : ", self.updatedTitle)
                }
            } withCancel: { (error) in}
        completion(.success(true))
    }
    
    func handleLogout() {
        do {
            try auth.signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        
    }
}
