//
//  FireStoreManager.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import Foundation
import Firebase
import FirebaseAuth


class FireStoreManager {
    
    
    private init() {}
    static let shared = FireStoreManager()
    private var database = Firestore.firestore()
    //    private lazy var feedsReference = database.collection("mainFeed")
    private var refId: DocumentReference? = nil
    
    private var userObject = [User]()
    private var singleUser = [User]()
    private var feedObject = [User]()
    func configure() {
        
    }
    
    func saveFeeds(userID: String, feeds: User, completion: @escaping (Result<Bool, NSError>) -> Void) {
        
        let newFeed = self.database.collection("userFeeds").document(userID)
        newFeed.setData(feeds.userDictionary) { (error) in
//        refId = self.database.collection("usersFeeds").addDocument(data: feeds.userDictionary)
//        { (error) in
            if let unwrappedError = error  {
                completion(.failure(unwrappedError as NSError))
                print("Error saving the document :", unwrappedError.localizedDescription)
            } else {
                print("Saved with Id :", self.refId?.documentID ?? "SAVED")
                completion(.success(true))
            }
        }
    }
    
    func getFeeds(completion: @escaping ([User]?) -> Void) {
        database.collection("usersFeeds").getDocuments { (querySnapshot, error) in
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
                        let likes                 = dictionary["likes"       ] as? String,
                        let comments              = dictionary["comments"    ] as? String,
                        let views                 = dictionary[ "views"      ] as? String
                    //                            let otherImagesDic  = dictionary["otherImages"] as? [String: String]
                    else {
                        continue //in case should be a continue and the for each changed to a for loop
                    }
                    //                               let receivedOtherImages = otherImagesDic.map{ $0.value}
                    
                    let object = User(profileImage: profileImage, name: name, handler: handler, email: email, password: nil, bio: bio, location: location, mainImage: profileImage, otherImages: [profileImage], status: status, postedOn: Date(), postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
                    
                    print(object)
                    self.feedObject.append(object)
                    
                }
                completion(self.feedObject)
            }
        }
    }
    
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
    

    func getCurrentUser(userID: String, completion: @escaping ([User]?) -> Void) {
        database.collection("users").document(userID).getDocument  { (querySnapshot, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let document = querySnapshot else {
                    print(error!.localizedDescription)
                    return
                }
//                for documents in data {
                guard let dictionary = document.data() else { return }
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
                        let likes                 = dictionary["likes"       ] as? String,
                        let comments              = dictionary["comments"    ] as? String,
                        let views                 = dictionary[ "views"      ] as? String
                    //                            let otherImagesDic  = dictionary["otherImages"] as? [String: String]
                    else {
                        return //continue //in case should be a continue and the for each changed to a for loop
                    }
                    //                               let receivedOtherImages = otherImagesDic.map{ $0.value}
                    let object = User(profileImage: profileImage, name: name, handler: handler, email: email, password: nil, bio: bio, location: location, mainImage: profileImage, otherImages: [profileImage], status: status, postedOn: Date(), postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
                    
                    print(object)
                
                    self.singleUser.append(object)
                print(self.singleUser)
                }
                completion(self.singleUser)
//            }
        }
    
    }
    
    
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
                        let likes                 = dictionary["likes"       ] as? String,
                        let comments              = dictionary["comments"    ] as? String,
                        let views                 = dictionary[ "views"      ] as? String
                    //                            let otherImagesDic  = dictionary["otherImages"] as? [String: String]
                    else {
                        continue //in case should be a continue and the for each changed to a for loop
                    }
                    //                               let receivedOtherImages = otherImagesDic.map{ $0.value}
                    let object = User(profileImage: profileImage, name: name, handler: handler, email: email, password: nil, bio: bio, location: location, mainImage: profileImage, otherImages: [profileImage], status: status, postedOn: Date(), postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
                    
                    print(object)
                    self.userObject.append(object)
                }
                completion(self.userObject)
            }
        }
        
        
        
        //    func getFeeds(completion: @escaping ([Feed]?) -> Void) {
        //        feedsReference.addSnapshotListener { [weak self] (snapShot, error) in
        //            guard let self = self else { return }
        //            guard let snapShotData = snapShot else { return }
        //            let data = snapShotData.documents
        //            print(data)
        //            data.forEach {
        //                print("Data received in the forEach: ", $0)
        //        }
        //
        //            var feedsObject = [Feed]()
        //            for documents in data {
        ////                let receivedData = $0.data()
        //                let receivedData = documents.data()
        //                guard
        //                        let userName        = receivedData["userName"] as? String,
        //                        let profile         = receivedData["profile"] as? String,
        //                        let media           = receivedData["media"] as? String,
        //                        let status          = receivedData["status"] as? String,
        //                        let postedOn        = receivedData["postedOn"] as? String,
        //                        let location        = receivedData["location"] as? String,
        //                        let postTitle       = receivedData["postTitle"] as? String,
        //                        let description     = receivedData["description"] as? String,
        //                        let likes           = receivedData["likes"] as? String,
        //                        let comments        = receivedData["comments"] as? String,
        //                        let views        = receivedData["views"] as? String,
        //                        let otherImagesDic  = receivedData["otherImages"] as? [String: String]
        //                else {
        //                    continue //in case should be a continue and the for each changed to a for loop
        //                }
        //                    let otherImages = otherImagesDic.map{ $0.value}
        //                    let object = Feed(userName: User(profileImage: profile, name: userName, handler: userName, bio: ""), profile: profile, media: media, otherImages: otherImages, status: status, postedOn: postedOn, location: location, postTitle: postTitle, description: description, likes: likes , comments: comments, views: views)
        //                feedsObject.append( object)
        //                print("feedsObjedt :", feedsObject)
        //            }
        //            completion(feedsObject)
        //        }
        //    }
        //}
    }
}
