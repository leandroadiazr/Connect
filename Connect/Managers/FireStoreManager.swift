//
//  FireStoreManager.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import Foundation
import Firebase
import FirebaseAuth
/*
 RULES FOR DEBUGING
 IF *** IS THE ONE USING
 IF  --- MARK FOR DELETE
 **/

class FireStoreManager {
    
    private init() {}
    static let shared = FireStoreManager()
    private var database = Firestore.firestore()
    private var refId: DocumentReference? = nil
    private var postObject = [Feed]()
    
    
    //MARK:- GET CURRENT USER POSTS RELATED TO FIRESTORE MANAGER
    //MARK:- GET CURRENT USER POSTS RELATED TO FIRESTORE MANAGER
    //MARK:- GET CURRENT USER POSTS RELATED TO FIRESTORE MANAGER
    //MARK:- GET CURRENT USER POSTS RELATED TO FIRESTORE MANAGER
    //MARK:- GET CURRENT USER POSTS RELATED TO FIRESTORE MANAGER
    
    //MARK:- GET CURRENT USER POSTS RELATED TO FIRESTORE MANAGER
    //    1.-
    //observePost the one using now
    func observePost(completion: @escaping (Result<[Feed], ErrorMessages>)-> Void) {
        let postRef = database.collection("userPost")
        var post = [Feed]()
        
        postRef.getDocuments { (query, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
                completion(.failure(.uknown))
            }
            guard let data = query?.documents else {
                print(error!.localizedDescription)
                return
            }
            for documents in data {
                let dictionary = documents.data()
                guard  let author             = dictionary["author"] as? [String: Any],
                       let userID                = author["userID"] as? String,
                       let name                  = author["name"        ] as? String,
                       let profileImage          = author["profileImage"] as? String,
                       let imgProURL             = URL(string: profileImage),
                       let mainImage       = dictionary["mainImage      "] as? String,
                       let otherImages     = dictionary["otherImages    "] as? [String],
                       let status          = dictionary["status         "] as? String,
                       let postedOn        = dictionary["postedOn       "] as? String,
                       let location        = dictionary["location       "] as? String,
                       let postTitle       = dictionary["postTitle      "] as? String,
                       let postDescription = dictionary["postDescription"] as? String,
                       let likes           = dictionary["likes          "] as? Int,
                       let comments        = dictionary["comments       "] as? Int,
                       let views           = dictionary["views          "] as? Int else { continue }
                
                let userProfile = UserProfile(userID: userID, name: name, handler: name, email: name, profileImage: imgProURL, userLocation: location, userBio: "", status: status)
                let retreivedPost = Feed(author: userProfile, mainImage: mainImage, otherImages: otherImages, status: status, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
                post.append(retreivedPost)
                print("retreivedPost :", retreivedPost)
            }
            self.postObject.append(contentsOf: post)
            print("self.postObject :", self.postObject)
            completion(.success(self.postObject))
            print("sent back self.postObject :", self.postObject)
        }
    }
    
    //    MARK:- SAVING CURRENT USER POST FIRESTORE MANAGER RELATED
    // 2.-
    func savePost(post: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
        self.refId = self.database.collection("userPost").addDocument(data: post, completion: { (error) in
            if let unwrappedError = error {
                completion(.failure(.unableToCreate))
                print(unwrappedError.localizedDescription)
            } else {
                print("Saved Suscessfully")
                completion(.success(true))
            }
        })
    }
    
    //MARKED FOR DELETION NOT USED ANYWHERE --
    //    func saveFeeds(userID: String, feeds: User, completion: @escaping (Result<Bool, NSError>) -> Void) {
    //        let newFeed = self.database.collection("userFeeds").document(userID)
    //        newFeed.setData(feeds.userDictionary) { (error) in
    //            //        refId = self.database.collection("usersFeeds").addDocument(data: feeds.userDictionary)
    //            //        { (error) in
    //            if let unwrappedError = error  {
    //                completion(.failure(unwrappedError as NSError))
    //                print("Error saving the document :", unwrappedError.localizedDescription)
    //            } else {
    //                print("Saved with Id :", self.refId?.documentID ?? "SAVED")
    //                completion(.success(true))
    //            }
    //        }
    //    }
    
    
    
    //    func getFeeds(completion: @escaping ([User]?) -> Void) {
    //        database.collection("mainFeeds").getDocuments { (querySnapshot, error) in
    //            if let unwrappedError = error {
    //                print(unwrappedError.localizedDescription)
    //            } else {
    //                guard let data = querySnapshot?.documents else {
    //                    print(error!.localizedDescription)
    //                    return
    //                }
    //                for documents in data {
    //                    let dictionary = documents.data()
    //                    guard
    //                        let profileImage          = dictionary["profileImage"] as? String,
    //                        let name                  = dictionary["name"        ] as? String,
    //                        let handler               = dictionary["handler"     ] as? String,
    //                        let email                 = dictionary["email"       ] as? String,
    //                        //                            let password              = dictionary["password"    ] as? String,
    //                        let bio                   = dictionary["bio"         ] as? String,
    //                        let location              = dictionary["location"    ] as? String,
    //                        //                            let feedID                = dictionary["feedID"      ] as? String,
    //                        //                            let mainImage             = dictionary["mainImage"   ] as? String,
    //                        //                            let otherImages           = dictionary["otherImages" ] as? [String],
    //                        let status                = dictionary["status"      ] as? String,
    //                        //                            let postedOn              = dictionary["postedOn"    ] as? Date,
    //                        let postTitle             = dictionary["postTitle"   ] as? String,
    //                        let messageDescription    = dictionary["messageDescription"] as? String,
    //                        let likes                 = dictionary["likes"       ] as? Int,
    //                        let comments              = dictionary["comments"    ] as? Int,
    //                        let views                 = dictionary[ "views"      ] as? Int
    //                    //                            let otherImagesDic  = dictionary["otherImages"] as? [String: String]
    //                    else {
    //                        continue //in case should be a continue and the for each changed to a for loop
    //                    }
    //                    let object = User(profileImage: profileImage, name: name, handler: handler, email: email, password: nil, bio: bio, location: location, mainImage: profileImage, otherImages: [profileImage], status: status, postedOn: Date(), postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
    //                    print(object)
    //                    self.feedObject.append(object)
    //                }
    //                completion(self.feedObject)
    //            }
    //        }
    //    }
    
    //MARK:- USER STUFF
    
    
    
    
    
    
    
    
    
}


/*
 //MARKED FOR DELETION ---
 func getUser(userID: String, completion: @escaping ([User]?) -> Void) {
 database.collection("users").getDocuments { (querySnapshot, error) in
 if let unwrappedError = error {
 print(unwrappedError.localizedDescription)
 } else {
 guard let data = querySnapshot?.documents else {
 print(error!.localizedDescription)
 return
 }
 for documents in data {
 let dictionary = documents.data()
 guard
 let profileImage          = dictionary["profileImage"] as? String,
 let name                  = dictionary["name"        ] as? String,
 let handler               = dictionary["handler"     ] as? String,
 let email                 = dictionary["email"       ] as? String,
 //                            let password              = dictionary["password"    ] as? String,
 let bio                   = dictionary["bio"         ] as? String,
 let location              = dictionary["location"    ] as? String,
 //                            let feedID                = dictionary["feedID"      ] as? String,
 //                            let mainImage             = dictionary["mainImage"   ] as? String,
 //                            let otherImages           = dictionary["otherImages" ] as? [String],
 let status                = dictionary["status"      ] as? String,
 //                            let postedOn              = dictionary["postedOn"    ] as? Date,
 let postTitle             = dictionary["postTitle"   ] as? String,
 let messageDescription    = dictionary["messageDescription"] as? String,
 let likes                 = dictionary["likes"       ] as? Int,
 let comments              = dictionary["comments"    ] as? Int,
 let views                 = dictionary[ "views"      ] as? Int
 else {
 continue //in case should be a continue and the for each changed to a for loop
 }
 let object = User(profileImage: profileImage, name: name, handler: handler, email: email, password: nil, bio: bio, location: location, mainImage: profileImage, otherImages: [profileImage], status: status, postedOn: Date(), postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
 print(object)
 self.userObject.append(object)
 }
 completion(self.userObject)
 }
 }
 }
 */
