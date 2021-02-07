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
    private let childCollection = "userPost"
    private var postObject = [Feed]()
    private var userPost   = [Feed]()
    private var userManager = UserManager.shared
    
    
    //MARK:- GET FEED POSTS EVERYONE POST
    //    1.-
    //observePost the one using now
 func observePost(completion: @escaping (Result<[Feed], ErrorMessages>)-> Void) {
//    guard let userID = Auth.auth().currentUser?.uid else { return }
    let postRef = database.collection("userPost")
        var post = [Feed]()

        postRef.getDocuments { (query, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
                completion(.failure(.uknown))
            }
            
//            print(query?.documents)
            guard let data = query?.documents else {
                print(error!.localizedDescription)
                return
            }
            for documents in data {
                let dictionary = documents.data()
                print(dictionary)
                guard  let documentId          = dictionary["customDocumentId"] as? String,
                       let author             = dictionary["author"] as? [String: Any],
                            let userID              = author["userID"] as? String,
                            let name                = author["name"] as? String,
                            let handler             = author["handler"] as? String,
                            let email               = author["email"] as? String,
                            let profileImage        = author["profileImage"] as? String,
                            let userLocation        = author["userLocation"] as? String,
                            let userBio             = author["userBio"] as? String,
                            let userStatus          = author["userStatus"] as? String,
                             let mainImage       = dictionary["mainImage"] as? String,
                             let otherImages     = dictionary["otherImages"] as? [String],
                             let feedStatus      = dictionary["status"] as? String,
                             let postedOn        = dictionary["postedOn"] as? String,
                             let location        = dictionary["location"] as? String,
                             let postTitle       = dictionary["postTitle"] as? String,
                             let postDescription = dictionary["postDescription"] as? String,
                             let likes           = dictionary["likes"] as? Int,
                             let comments        = dictionary["comments"] as? Int,
                             let views           = dictionary["views"] as? Int else { continue }
                let uid             = documents.documentID
                           let userProfile = UserProfile(userID: userID, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, userStatus: userStatus)
                
                let retreivedPost = Feed(id: uid, documentId: documentId, author: userProfile, mainImage: mainImage, otherImages: otherImages, status: feedStatus, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
                post.append(retreivedPost)
//                print("retreivedPost :", retreivedPost)
            }
            self.postObject.append(contentsOf: post)
//            print("self.postObject :", self.postObject)
            completion(.success(self.postObject))
//            print("sent back self.postObject :", self.postObject)
        }
    }
    
    func realtimeUpdates(completion: @escaping (Result<[Feed], ErrorMessages>)-> Void) {
            guard let userID = Auth.auth().currentUser?.uid else { return }
        let postRef = database.collection("userPost")
                var post = [Feed]()

                postRef.addSnapshotListener { (query, error) in
                    if let unwrappedError = error {
                        print(unwrappedError.localizedDescription)
                        completion(.failure(.uknown))
                    }
                    
        
                    guard let data = query?.documentChanges else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    for document in data {
                        if document.type == .added {

//                    for documents in data {
                            let dictionary = document.document.data()
//                        print(dictionary)
                        guard  let documentId          = dictionary["customDocumentId"] as? String,
                               let author             = dictionary["author"] as? [String: Any],
                                    let userID              = author["userID"] as? String,
                                    let name                = author["name"] as? String,
                                    let handler             = author["handler"] as? String,
                                    let email               = author["email"] as? String,
                                    let profileImage        = author["profileImage"] as? String,
                                    let userLocation        = author["userLocation"] as? String,
                                    let userBio             = author["userBio"] as? String,
                                    let userStatus          = author["userStatus"] as? String,
                                     let mainImage       = dictionary["mainImage"] as? String,
                                     let otherImages     = dictionary["otherImages"] as? [String],
                                     let feedStatus      = dictionary["status"] as? String,
                                     let postedOn        = dictionary["postedOn"] as? String,
                                     let location        = dictionary["location"] as? String,
                                     let postTitle       = dictionary["postTitle"] as? String,
                                     let postDescription = dictionary["postDescription"] as? String,
                                     let likes           = dictionary["likes"] as? Int,
                                     let comments        = dictionary["comments"] as? Int,
                                     let views           = dictionary["views"] as? Int else { continue }
                    let uid             = documentId
                                   let userProfile = UserProfile(userID: userID, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, userStatus: userStatus)
                        
                        let retreivedPost = Feed(id: uid, documentId: documentId, author: userProfile, mainImage: mainImage, otherImages: otherImages, status: feedStatus, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
                        post.append(retreivedPost)
//                        print("retreivedPost :", retreivedPost)
                    }
                    }
                    self.postObject.append(contentsOf: post)
//                    print("self.postObject :", self.postObject)
        completion(.success(self.postObject))
//                    print("sent back self.postObject :", self.postObject)
                }
        
    }

    func getFeeds(for detail: String, completion: @escaping ([Feed]?) -> Void) {
        let postRef = database.collection("userPost").whereField("customDocumentId", isEqualTo: detail)
            var feedsObject = [Feed]()
        postRef.getDocuments { (snapShot, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
//                completion(.failure(.uknown))
            }
            
//            print(snapShot?.documents)
            guard let data = snapShot?.documents else {
                print(error!.localizedDescription)
                return
            }
            
            
            for documents in data {
                let dictionary = documents.data()
//            guard let dictionary = documents.data() else { return }
                    guard
                        let documentId          = dictionary["customDocumentId"] as? String,
                        let author             = dictionary["author"] as? [String: Any],
                             let userID              = author["userID"] as? String,
                             let name                = author["name"] as? String,
                             let handler             = author["handler"] as? String,
                             let email               = author["email"] as? String,
                             let profileImage        = author["profileImage"] as? String,
                             let userLocation        = author["userLocation"] as? String,
                             let userBio             = author["userBio"] as? String,
                             let userStatus          = author["userStatus"] as? String,
                              let mainImage       = dictionary["mainImage"] as? String,
                              let otherImages     = dictionary["otherImages"] as? [String],
                              let feedStatus      = dictionary["status"] as? String,
                              let postedOn        = dictionary["postedOn"] as? String,
                              let location        = dictionary["location"] as? String,
                              let postTitle       = dictionary["postTitle"] as? String,
                              let postDescription = dictionary["postDescription"] as? String,
                              let likes           = dictionary["likes"] as? Int,
                              let comments        = dictionary["comments"] as? Int,
                              let views           = dictionary["views"] as? Int else { continue }
                let uid             = documents.documentID
                    let userProfile = UserProfile(id: uid, userID: userID, name: name, handler: handler, email: email, profileImage: profileImage, userLocation: userLocation, userBio: userBio, userStatus: userStatus)
                
            let retreivedPost = Feed(id: uid, documentId: documentId, author: userProfile, mainImage: mainImage, otherImages: otherImages, status: feedStatus, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
//                    feedsObject
                    feedsObject.append(retreivedPost)
//                    print("feedsObjedt :", feedsObject)
                    
                }
                completion(feedsObject)
            }
        }
    
 
    //observePost the one using now GET EVERYONE POSTS
//    func observePost(completion: @escaping (Result<[Feed], ErrorMessages>)-> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else { return}
//
//        print(userID)
//        let postRef = database.collection("userPost")
////        let postRef = database.collection("users").document().collection("userPost") // ex÷perimental
//        var post = [Feed]()
//
//        postRef.addSnapshotListener { (query, error) in
//            if let unwrappedError = error {
//                print(unwrappedError.localizedDescription)
//                completion(.failure(.uknown))
//            }
//            guard let documentChanges = query?.documentChanges else {
//                print(error?.localizedDescription)
//                return
//            }
//
//            var dictionary: [String: Any] = [:]
//            for data in documentChanges {
//                switch data.type {
//                case .added:
//                    dictionary = data.document.data()
//                    print(dictionary)
//                case .modified:
//                    dictionary = data.document.data()
//                case .removed:
//                    dictionary = data.document.data()
//
//                }
////                let dictionary = documents.data()
//                guard  let author             = dictionary["author"] as? [String: Any],
////                       let userID                = author["userID"] as? String,
//                       let name                  = author["name"        ] as? String,
//                       let profileImage          = author["profileImage"] as? String,
//                       let mainImage       = dictionary["mainImage      "] as? String,
//                       let otherImages     = dictionary["otherImages    "] as? [String],
//                       let status          = dictionary["status         "] as? String,
//                       let postedOn        = dictionary["postedOn       "] as? String,
//                       let location        = dictionary["location       "] as? String,
//                       let postTitle       = dictionary["postTitle      "] as? String,
//                       let postDescription = dictionary["postDescription"] as? String,
//                       let likes           = dictionary["likes          "] as? Int,
//                       let comments        = dictionary["comments       "] as? Int,
//                       let views           = dictionary["views          "] as? Int
//                      else { continue }
//                let uid             = data.document.documentID
//                let userProfile = UserProfile(id: uid, userID: userID, name: name, handler: name, email: name, profileImage: profileImage, userLocation: location, userBio: "", status: status)
//                let retreivedPost = Feed(id: uid, author: userProfile, mainImage: mainImage, otherImages: otherImages, status: status, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
//                post.append(retreivedPost)
//                print("retreivedPost :", retreivedPost)
//            }
//            self.postObject.append(contentsOf: post)
//            print("self.postObject :", self.postObject)
//            completion(.success(self.postObject))
//            print("sent back self.postObject :", self.postObject)
//        }
//    }

    //MARK:- GET CURRENT USER POSTS ONLY
    //    2.-
    //observePost the one using now GET SINGLE USER POSTS
//    func currentUserPost(completion: @escaping (Result<[Feed], ErrorMessages>)-> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let postRef = database.collection("userPost").document(userID).collection("userPost")
//            var post = [Feed]()
//
//            postRef.addSnapshotListener { (query, error) in
//                if let unwrappedError = error {
//                    print(unwrappedError.localizedDescription)
//                    completion(.failure(.uknown))
//                }
//                guard let data = query?.documents else {
//                    print(error!.localizedDescription)
//                    return
//                }
////                for documents in data {
//                let document = data.map { snapshot in
//                    let dictionary = snapshot.data()
//
////                    let dictionary = query!.data()!
//                           guard let author             = dictionary["author"] as? [String: Any],
//                           let userID                = author["userID"] as? String,
//                           let name                  = author["name"        ] as? String,
//                           let profileImage          = author["profileImage"] as? String,
//                           let mainImage       = dictionary["mainImage      "] as? String,
//                           let otherImages     = dictionary["otherImages    "] as? [String],
//                           let status          = dictionary["status         "] as? String,
//                           let postedOn        = dictionary["postedOn       "] as? String,
//                           let location        = dictionary["location       "] as? String,
//                           let postTitle       = dictionary["postTitle      "] as? String,
//                           let postDescription = dictionary["postDescription"] as? String,
//                           let likes           = dictionary["likes          "] as? Int,
//                           let comments        = dictionary["comments       "] as? Int,
//                           let views           = dictionary["views          "] as? Int else { return }
//
//                    let userProfile = UserProfile(userID: userID, name: name, handler: name, email: name, profileImage: profileImage, userLocation: location, userBio: "", status: status)
//                    let retreivedPost = Feed(author: userProfile, mainImage: mainImage, otherImages: otherImages, status: status, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
//                    post.append(retreivedPost)
//                    print("retreivedPost :", retreivedPost)
//                }
//                self.userPost.append(contentsOf: post)
//                print("self.postObject :", self.userPost)
//                completion(.success(self.userPost))
//                print("sent back self.postObject :", self.userPost)
//            }
//        }
    
    
    //MARKED FOR DELETION NOT USED ANYWHERE --
        func saveFeeds(userID: String, feeds: Feed, completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
            let newFeed = self.database.collection("userPost").document().collection(userID)
            newFeed.addDocument(data: feeds.postDictionary) { (error) in
                //        refId = self.database.collection("usersFeeds").addDocument(data: feeds.userDictionary)
                //        { (error) in
                if let unwrappedError = error  {
                    completion(.failure(.uknown))
                    print("Error saving the document :", unwrappedError.localizedDescription)
                } else {
                    print("Saved with Id :", self.refId?.documentID ?? "SAVED")
                }
                
                completion(.success(true))
            }
        }
    
    
    
    //    MARK:- SAVING CURRENT USER POST FIRESTORE MANAGER RELATED
    // 3.-
//    func savePost(userID: String, post: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
//        self.refId = self.database.collection(childCollection).addDocument(data: post, completion: { (error) in
//            if let unwrappedError = error {
//                completion(.failure(.unableToCreate))
//                print(unwrappedError.localizedDescription)
//            } else {
//                print("Saved Suscessfully")
//                completion(.success(true))
//            }
//        })
//    }
    //***
    func savePost(post: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
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
 
 
 
 
 
 
 
 
 
 */
