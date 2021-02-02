//
//  UsersManager.swift
//  Connect
//
//  Created by Leandro Diaz on 1/31/21.
//

import UIKit
import FirebaseAuth
import Firebase



class UserManager {
    private init() {}
    static let shared = UserManager()
   var database = Firestore.firestore()
//    private var database = DatabaseReference().database.reference(withPath: "https://connect-f747d-default-rtdb.firebaseio.com/")
    private var auth = Auth.auth()
    private lazy var childCollection = "users"
    var updatedTitle = ""
    var SingleUser = [User]()
    
    
    
    func saveUser(user: User, completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
        auth.createUser(withEmail: user.email, password: user.password!) { (authResult, error) in
            if let _ = error {
                completion(.failure(.unableToSave))
                print(error!.localizedDescription)
                return
            }
            
            guard let uuid = authResult?.user.uid else {
                return
            }
            print("Saved suscessfully into firebase database need an alert")
            
            //ON SUSCESS SAVE TO DATABASE
            let userReference = self.database.collection(self.childCollection).document(uuid)
//            let userReference = self.database.child(self.childCollection).child(uuid)
            let values = ["name": user.name, "email": user.email, "handler": user.handler, "profileImage": user.profileImage]
            userReference.updateData(values) { (error) in
//            userReference.updateChildValues(values) { (error, reference) in
                if let _ = error {
                    completion(.failure(.unableToCreate))
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    func fetchUser(completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
//        let reference = database.child(childCollection)
        database.collection(self.childCollection).getDocuments { (data, error) in
  
//            let uid = self.auth.currentUser?.uid
            guard let singleUser = data?.documents else { return }
        //get SingleUser
//        reference.child(uid!).observeSingleEvent(of: .childAdded) { (singleUser) in
            for user in singleUser {
                let dictionary = user.data()
                guard let userDictionary = User(dictionary: dictionary) else {
                    continue
                }
                print("userDictionary.name :", userDictionary.name)
                
            }
        }
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
