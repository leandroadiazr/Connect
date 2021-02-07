//
//  Feed.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit
protocol PostSerializable {
    init?(dictionary: [String: Any])
}


struct Feed: Codable, Hashable, Identifiable {
    var id = UUID().uuidString
    
    var documentId: String
    var author: UserProfile
    var mainImage: String
    var otherImages: [String]
    var status: String
    var postedOn: String
    var location: String
    var postTitle: String
    var postDescription: String
    var likes: Int
    var comments: Int
    var views: Int
    
    private enum CodingKeys : String, CodingKey { case documentId, author, mainImage, otherImages, status, postedOn, location, postTitle, postDescription, likes, comments, views }
    
//    static func == (lhs: Feed, rhs: Feed) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
        
    //ENCODING
    var postDictionary: [String: Any] {
        return [
            "id" : documentId,
            "author" : author,
            "mainImage" : mainImage,
            "otherImages" : otherImages,
            "status" : status,
            "postedOn" : postedOn,
            "location" : location,
            "postTitle" : postTitle,
            "postDescription" : postDescription,
            "likes" : likes,
            "comments" : comments,
            "views" : views
        ]
    }
}


//DECODING
extension Feed: PostSerializable {
    init?(dictionary: [String : Any]) {
          guard let documentId            = dictionary["customDocumentId"]           as? String,
            let author          = dictionary["author"]      as? UserProfile,
                let mainImage       = dictionary["mainImage"] as? String,
                let otherImages     = dictionary["otherImages"] as? [String],
                let status          = dictionary["status"] as? String,
                let postedOn        = dictionary["postedOn"] as? String,
                let location        = dictionary["location"] as? String,
                let postTitle       = dictionary["postTitle"] as? String,
                let postDescription = dictionary["postDescription"] as? String,
                let likes           = dictionary["likes"] as? Int,
                let comments        = dictionary["comments"] as? Int,
                let views           = dictionary["views"] as? Int else { return nil}
        
        self.init(documentId: documentId, author: author, mainImage: mainImage, otherImages: otherImages, status: status, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
    }
}

