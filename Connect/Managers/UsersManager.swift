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
    private var auth = Auth.auth()
    private lazy var childCollection = "users"
    var updatedTitle = ""
    var currentUserProfile: UserProfile?
    //    var SingleUser = [User]()
    
    
    private var currentUser = [UserProfile]()
    private var refId: DocumentReference? = nil
    
    
    // 1.- USER MANAGER RELATED
    //MARK:- GET CURRENT USER IN THE DATABASE FROM USERPROFILE***
    //THIS IS WILL GET THE CURRENT USER ARRAY ON USERS PROFILE AND IS NEEDED
    func getCurrentUser(userID: String, completion: @escaping ([UserProfile]?) -> Void) {
        database.collection("users").document(userID).getDocument  { (querySnapshot, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let document = querySnapshot else {
                    print(error!.localizedDescription)
                    return
                }
                guard let dictionary = document.data() else { return }
                guard
                    let profileImage          = dictionary["profileImage"] as? String,
                    let profImgURL = URL(string: profileImage),
                    let name                  = dictionary["name"        ] as? String,
                    let handler               = dictionary["handler"     ] as? String,
                    let email                 = dictionary["email"       ] as? String,
                    let bio                   = dictionary["bio"         ] as? String,
                    let location              = dictionary["location"    ] as? String,
                    let status                = dictionary["status"      ] as? String
                else {
                    return //continue //in case should be a continue and the for each changed to a for loop
                }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let currentUser = UserProfile(userID: uid, name: name, handler: handler, email: email, profileImage: profImgURL, userLocation: location, userBio: bio, status: status)
                self.currentUser.append(currentUser)
                print(self.currentUser)
            }
            completion(self.currentUser)
        }
    }
    
    //MARK:- GET SINGLE USER ON LOGIN SCENE DELEGATE NEEDED BUT CAN BE REFACTORED LATER***
    func observeUserProfile(_ userID: String, completion: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        let userRef = database.collection("users").document(userID)
        userRef.getDocument { (snapshot, error) in
            var userProfile: UserProfile?
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let document = snapshot else {
                    print(error!.localizedDescription)
                    return
                }
                guard let dictionary = document.data() else { return }
                guard let username = dictionary["name"] as? String,
                      let profileImage = dictionary["profileImage"] as? String,
                      let profImgURL = URL(string: profileImage),
                      let uuid = snapshot?.documentID
                else { return }
                userProfile = UserProfile(userID: uuid, name: username, handler: "", email: "", profileImage: profImgURL, userLocation: "", userBio: "", status: "")
            }
            completion(.success(userProfile))
        }
    }
    
    //MARK:- SAVE USER ON SIGNUP VIEW CONTROLLER ***
    func saveUser(user: User, userID: String, completion: @escaping (Result<Bool, NSError>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return  }
        let newUser = self.database.collection("users").document(userID)
        newUser.setData(user.userDictionary) { (error) in
            if let unwrappedError = error  {
                completion(.failure(unwrappedError as NSError))
                print("Error saving the document :", unwrappedError.localizedDescription)
            } else {
                print("Saved with Id :", self.refId?.documentID ?? "SAVED")
                completion(.success(true))
            }
        }
    }
    
    //MARK:- LOGOUT USER FROM THE SYSTEM
    func handleLogout() {
        do {
            try auth.signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
    }
}




//
//    func saveUser(user: User, completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
//        auth.createUser(withEmail: user.email, password: user.password!) { (authResult, error) in
//            if let _ = error {
//                completion(.failure(.unableToSave))
//                print(error!.localizedDescription)
//                return
//            }
//
//            guard let uuid = authResult?.user.uid else {
//                return
//            }
//            print("Saved suscessfully into firebase database need an alert")
//
//            //ON SUSCESS SAVE TO DATABASE
//            let userReference = self.database.collection(self.childCollection).document(uuid)
////            let userReference = self.database.child(self.childCollection).child(uuid)
//            let values = ["name": user.name, "email": user.email, "handler": user.handler, "profileImage": user.profileImage]
//            userReference.updateData(values) { (error) in
////            userReference.updateChildValues(values) { (error, reference) in
//                if let _ = error {
//                    completion(.failure(.unableToCreate))
//                    print(error!.localizedDescription)
//                }
//            }
//        }
//    }
//
//    func fetchUser(completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
////        let reference = database.child(childCollection)
//        database.collection(self.childCollection).getDocuments { (data, error) in
//
////            let uid = self.auth.currentUser?.uid
//            guard let singleUser = data?.documents else { return }
//        //get SingleUser
////        reference.child(uid!).observeSingleEvent(of: .childAdded) { (singleUser) in
//            for user in singleUser {
//                let dictionary = user.data()
//                guard let userDictionary = User(dictionary: dictionary) else {
//                    continue
//                }
//                print("userDictionary.name :", userDictionary.name)
//
//            }
//        }
//        completion(.success(true))
//    }
//
