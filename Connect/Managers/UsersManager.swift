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
    var databaseRef = Database.database().reference()
    private var auth = Auth.auth()
    private lazy var childCollection = "users"
    var updatedTitle = ""
    var currentUserProfile: UserProfile?
    private var refId: DocumentReference? = nil
    private var persistenceManager = PersistenceManager.shared
    
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
    //MARK:- GET USERS IN DATABASE***
    func getCurrentUsers(userID: String, completion: @escaping ([UserProfile]?) -> Void) {
        database.collection("users").getDocuments  { (querySnapshot, error) in
            var users = [UserProfile]()
            
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print(error!.localizedDescription)
                    return
                }
                
                for document in documents {
                    let dictionary = document.data()
                    guard let userID              = dictionary["userID"] as? String,
                          let name                = dictionary["name"] as? String,
                          let handler             = dictionary["handler"] as? String,
                          let email               = dictionary["email"] as? String,
                          let profileImage        = dictionary["profileImage"] as? String,
                          let userLocation        = dictionary["location"] as? String,
                          let userBio             = dictionary["bio"] as? String,
                          let userStatus          = dictionary["userStatus"] as? String
                    else {
                        continue
                    }
                    let loadedUser = UserProfile(userID: userID, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, userStatus: userStatus)
                    users.append(loadedUser)
                }
            }
            completion(users)
        }
    }
    
    //MARK:- GET SINGLE USER ON LOGIN SCENE DELEGATE NEEDED BUT CAN BE REFACTORED LATER***
    func observeSingleUserProfile(_ userID: String, completion: @escaping (Result<UserProfile?, ErrorMessages>) -> Void) {
        guard let uid = auth.currentUser?.uid else { return }
        print(uid)
        let userRef = database.collection("users").document(uid)
        userRef.getDocument { (snapshot, error) in
            var userProfile: UserProfile?
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let documents = snapshot else {
                    print(error!.localizedDescription)
                    return
                }
                
                guard let dictionary = documents.data() else { return }
                guard let userID              = dictionary["userID"] as? String,
                      let name                = dictionary["name"] as? String,
                      let handler             = dictionary["handler"] as? String,
                      let email               = dictionary["email"] as? String,
                      let profileImage        = dictionary["profileImage"] as? String,
                      let userLocation        = dictionary["location"] as? String,
                      let userBio             = dictionary["bio"] as? String,
                      let userStatus          = dictionary["userStatus"] as? String else { return }
                print("do they match :?", uid, userID)
                userProfile = UserProfile( userID: userID, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, userStatus: userStatus)
            }
            self.currentUserProfile = userProfile
            self.persistenceManager.saveUserToDeviceCache(user: userProfile) { result in
                print(result)
            }
            completion(.success(userProfile))
        }
    }
    
    //MARK:- SAVE USER ON SIGNUP VIEW CONTROLLER ***
    func saveUser(user: UserProfile, userID: String, completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return  }
        let newUser = self.database.collection("users").document(userID)
        
        //MARK:- FIRESTORE
        newUser.setData(user.userDictionary) { (error) in
            if let unwrappedError = error  {
                completion(.failure(.unableToSaveProfile))
                print("Error saving the document :", unwrappedError.localizedDescription)
            } else {
                print("Saved with Id :", self.refId?.documentID ?? "SAVED")
                
                
                
                //MARK:- REALTIME DATABASE
                //Save users to message users collection for the chat functionality
                self.databaseRef.child("users").observeSingleEvent(of: .value) { snapshot in
                    //if already exist
                    if var usersCollection = snapshot.value as? [String: Any]{
                        let newCollection = ["userID": user.userID,
                                             "name": user.name,
                                             "email": user.email,
                                             "location": user.userLocation,
                                             "profileImage": user.profileImage]
                        usersCollection = newCollection
                        
                        self.databaseRef.child("users").child(userID).updateChildValues(usersCollection) { (error, _) in
                            if let unwrappedError = error  {
                                completion(.failure(.unableToSaveProfile))
                                print("Error saving the document :", unwrappedError.localizedDescription)
                            }
                            completion(.success(true))
                        }
                    }
                    else {
                        //else Create new
                        let newCollection: [String: Any] = ["userID": user.userID,
                                                            "name": user.name,
                                                            "email": user.email,
                                                            "location": user.userLocation,
                                                            "profileImage": user.profileImage]
                        
                        self.databaseRef.child("users").child(userID).setValue(newCollection) { (error, _) in
                            if let unwrappedError = error  {
                                completion(.failure(.unableToSaveProfile))
                                print("Error saving the document :", unwrappedError.localizedDescription)
                            }
                            completion(.success(true))
                        }
                    }
                }
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

