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
    func observePosts(completion: @escaping (Result<[Feed], ErrorMessages>)-> Void) {
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
            }
            self.postObject.append(contentsOf: post)
            completion(.success(self.postObject))
        }
    }
    
    func realtimeUsersUpdates(completion: @escaping (Result<[Feed], ErrorMessages>)-> Void) {
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
                    let dictionary = document.document.data()
                    
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
                }
            }
            self.postObject.append(contentsOf: post)
            completion(.success(self.postObject))
        }
    }
    
    func getFeeds(for detail: String, completion: @escaping ([Feed]?) -> Void) {
        let postRef = database.collection("userPost").whereField("customDocumentId", isEqualTo: detail)
        var feedsObject = [Feed]()
        postRef.getDocuments { (snapShot, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            }
            
            guard let data = snapShot?.documents else {
                print(error!.localizedDescription)
                return
            }
            
            for documents in data {
                let dictionary = documents.data()
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
                feedsObject.append(retreivedPost)
            }
            completion(feedsObject)
        }
    }
    
    //    MARK:- SAVING CURRENT USER POST TO FIRESTORE MANAGER RELATED
    func savePost(post: [String: Any], completion: @escaping (Result<Bool, ErrorMessages>) -> Void) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        
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
