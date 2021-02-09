//
//  UsersManager.swift
//  Connect
//
//  Created by Leandro Diaz on 1/31/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import GoogleSignIn



class UserManager {
    private init() {}
    static let shared = UserManager()
    var database = Firestore.firestore()
    private var auth = Auth.auth()
    private lazy var childCollection = "users"
    var updatedTitle = ""
    var currentUserProfile: UserProfile?
    private var refId: DocumentReference? = nil
    private var currentUser: UserProfile?
    
    
    
    //    MARK:- GLOBAL SIGN IN WITH SDK
    
    //    FB
    func globalSignInWith(userID: String, email: String, name: String, imageURL: String) {
        if database.collection("users").document(userID).documentID.contains(userID) {
            print("USER ALREADY EXIST ", userID)
            return
        } else {
            let newUser = UserProfile(id: userID, userID: userID, name: name, handler: "@\(name)", email: email, profileImage: imageURL, userLocation: "fba", userBio: "fb", userStatus: "fb")
            self.saveUser(user: newUser, userID: userID) { (result) in
                print("saved user FROM FACEBOOK LOGIN")
                print("Saved suscessfully into firebase database need an alert")
            }
        }
    }
    
    //    Gg
    func globalGoogleSignInWith(userID: String, email: String, name: String, imageURL: String) {
        if database.collection("users").document(userID).documentID.contains(userID) {
            print("USER ALREADY EXIST ", userID)
            return
        } else {
            let newUser = UserProfile(id: userID, userID: userID, name: name, handler: "@\(name)", email: email, profileImage: imageURL, userLocation: "fba", userBio: "fb", userStatus: "fb")
            self.saveUser(user: newUser, userID: userID) { (result) in
                print("saved user FROM FACEBOOK LOGIN")
                print("Saved suscessfully into firebase database need an alert")
            }
        }
    }
    
    
    //MARK:- LOGOUT FROM FACEBOOK SDK
    func logoutFromFacebook() {
        FBSDKLoginKit.LoginManager().logOut()
    }
    
    func logoutFromGoogle() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    
    
    
    // 1.- USER MANAGER RELATED
    //MARK:- GET CURRENT USER IN THE DATABASE FROM USERPROFILE***
    //THIS IS WILL GET THE CURRENT USER ARRAY ON USERS PROFILE AND IS NEEDED
    func getCurrentUser(userID: String, completion: @escaping (UserProfile?) -> Void) {
        database.collection("users").document(userID).getDocument  { (querySnapshot, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let document = querySnapshot else {
                    print(error!.localizedDescription)
                    return
                }
                guard let dictionary = document.data()else { return }
                guard
                    let userID              = dictionary["userID"]           as? String,
                    let name                = dictionary["name"]             as? String,
                    let handler             = dictionary["handler"]          as? String,
                    let email               = dictionary["email"]            as? String,
                    let profileImage        = dictionary["profileImage"] as? String,
                    let userLocation        = dictionary["location"] as? String,
                    let userBio             = dictionary["bio"] as? String,
                    let userStatus              = dictionary["userStatus"] as? String
                else {
                    return //continue //in case should be a continue and the for each changed to a for loop
                }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let loadedUser = UserProfile(userID: uid, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, userStatus: userStatus)
                self.currentUser = loadedUser
            }
            completion(self.currentUser)
        }
    }
    
    //MARK:- GET SINGLE USER ON LOGIN SCENE DELEGATE NEEDED BUT CAN BE REFACTORED LATER***
    
    func observeUserProfile(_ userID: String, completion: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        guard let uid = auth.currentUser?.uid else { return }
        print(uid)
        let userRef = database.collection("users")
        userRef.getDocuments { (snapshot, error) in
            var userProfile: UserProfile?
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let documents = snapshot?.documents else {
                    print(error!.localizedDescription)
                    return
                }
                
                for document in documents {
                    if document.documentID == uid {
                        print("do they mathc:?", document.documentID, uid)
                        let dictionary = document.data()
                        guard let userID         = dictionary["userID"]           as? String,
                              let name                = dictionary["name"]             as? String,
                              let handler             = dictionary["handler"]          as? String,
                              let email               = dictionary["email"]            as? String,
                              let profileImage        = dictionary["profileImage"] as? String,
                              let userLocation        = dictionary["userLocation"] as? String,
                              let userBio             = dictionary["userBio"] as? String,
                              let userStatus              = dictionary["userStatus"] as? String else { continue }
                        
                        userProfile = UserProfile( userID: userID, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, userStatus: userStatus)
                    }
                }
            }
            completion(.success(userProfile))
        }
    }
    
    //MARK:- SAVE USER ON SIGNUP VIEW CONTROLLER ***
    func saveUser(user: UserProfile, userID: String, completion: @escaping (Result<Bool, NSError>) -> Void) {
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
    
    //MARK:- SET CURRENT USER PROFILE
    func setCurrentProfile() {
        Auth.auth().addStateDidChangeListener( { auth, user in
            if user != nil {
                self.observeUserProfile(user!.uid) { result in
                    print("current logged ", user?.uid as Any)
                    switch result {
                    case .success(let user):
                        
                        self.currentUserProfile = user
                        guard let uuid = user?.userID else { return }
                        print("User ID Found in SceneDelegate :********", uuid)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("User Not Found in Set CURRENT PROFILE :********, Login")
            }
        })
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
