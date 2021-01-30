//
//  FireStoreManager.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import Foundation
import Firebase


class FireStoreManager {
    
    
    private init() {}
    static let shared = FireStoreManager()
    private var database = Firestore.firestore()
//    private lazy var feedsReference = database.collection("mainFeed")
    private var refId: DocumentReference? = nil
    
    private var userObject = [User]()
    func configure() {

    }
    
    func saveFeeds(_ feeds: User, completion: @escaping (Result<Bool, NSError>) -> Void) {
//        refId = self.database.collection("feeds").addDocument(data: feeds.feedsDectionary)
        refId = self.database.collection("user").addDocument(data: feeds.userDictionary)
        { (error) in
            if let unwrappedError = error  {
                completion(.failure(unwrappedError as NSError))
                print("Error saving the document :", unwrappedError.localizedDescription)
            } else {
                print("Saved with Id :", self.refId?.documentID ?? "SAVED")
                completion(.success(true))
            }
        }
    }
    
    
    
    
    
    
//    func saveFeeds(_ feeds: Feed, completion: @escaping (Result<Bool, NSError>) -> Void) {
//
//        var feedsPathDic = [String: String]()
//        feeds.otherImages.forEach{ feedsPathDic[UUID().uuidString] = $0}
//        print(feeds)
//        feedsReference.addDocument(data: [
//            "feedid"        : feeds.feedid,
//            "mainImage"     : feeds.mainImage,
//            "otherImages"   : feedsPathDic,
//            "status"        : feeds.status,
//            "postedOn"      : feeds.postedOn,
//            "postTitle"     : feeds.postTitle,
//            "messageDescription" : feeds.messageDescription,
//            "likes"         : feeds.likes,
//            "comments"      : feeds.comments,
//            "views"         : feeds.views
//
//        ]) { (error) in
//            if let unwrappedError = error  {
//                completion(.failure(unwrappedError as NSError))
//                print(unwrappedError.localizedDescription)
//            } else {
//                print(self.feedsReference)
//                completion(.success(true))
//            }
//        }
//    }
    
    
    func getFeeds(completion: @escaping ([User]?) -> Void) {
        database.collection("user").getDocuments { (querySnapshot, error) in
//            guard let self = self else { return }
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                guard let data = querySnapshot?.documents else {
                    print(error?.localizedDescription)
                    return
                }
//                print(querySnapshot?.count)
                for documents in data {
           //                let receivedData = $0.data()
                           let dictionary = documents.data()
                           guard
                            let profileImage          = dictionary["profileImage"] as? String,
                            let name                  = dictionary["name"        ] as? String,
                            let handler               = dictionary["handler"     ] as? String,
                            let email                 = dictionary["email"       ] as? String,
                            //                              let password = dictionary[//  "password"] as? Stringpassword,
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
                
                    let object = User(profileImage: profileImage, name: name, handler: handler, email: email, bio: bio, location: location, mainImage: profileImage, otherImages: [profileImage], status: status, postedOn: Date(), postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
            
                    print(object)
                    self.userObject.append(object)
                
//                data.forEach {
//                    print("Data received in the forEach: ", $0.data())
//
//
//                    let receivedObject =  $0.data()
//                    print("ReceivedObject in Get Feeds :", receivedObject)
//
//                    for user in receivedObject {
//                        print(user)
////                        self.userObject.append(user)
//                    }
//                    print("userObject :", self.userObject)
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
