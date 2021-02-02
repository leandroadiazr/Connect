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


struct Feed: Codable, Hashable {
    var id = UUID()
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
    
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
        
    //ENCODING
    var postDictionary: [String: Any] {
        return [
            "author         " : author,
            "mainImage      " : mainImage,
            "otherImages    " : otherImages,
            "status         " : status,
            "postedOn       " : postedOn,
            "location       " : location,
            "postTitle      " : postTitle,
            "postDescription" : postDescription,
            "likes          " : likes,
            "comments       " : comments,
            "views          " : views
        ]
    }
}


//DECODING
extension Feed: PostSerializable {
    init?(dictionary: [String : Any]) {
          guard let author          = dictionary["author"]      as? UserProfile,
                let mainImage       = dictionary["mainImage      "] as? String,
                let otherImages     = dictionary["otherImages    "] as? [String],
                let status          = dictionary["status         "] as? String,
                let postedOn        = dictionary["postedOn       "] as? String,
                let location        = dictionary["location       "] as? String,
                let postTitle       = dictionary["postTitle      "] as? String,
                let postDescription = dictionary["postDescription"] as? String,
                let likes           = dictionary["likes          "] as? Int,
                let comments        = dictionary["comments       "] as? Int,
                let views           = dictionary["views          "] as? Int else { return nil}
        
        self.init( author: author, mainImage: mainImage, otherImages: otherImages, status: status, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
    }
}



//let testingFeed: [Feed] = [Feed(userName: User(
//                                    profileImage: "",
//                                    name: "leandro",
//                                    handler: "leandro",
//                                    bio: ""),
//                                    profile: Images.profilePic ,
//                                    media: Images.backMedia,
//                                    otherImages: [],
//                                    status: "Just posted",
//                                    postedOn: "10/10/2020",
//                                    location: "California",
//                                    postTitle: "Nice Background",
//                                    description: "Just a desc asdfasdfasdfas dfasdfasd fasdfasd fasdfasdfas fasdfasdfas fasdfasdfas fasdfasdfas fasdfasdfas  dfasdfasdfasdfasd  fasdfasdf",
//                                    likes: "100",
//                                    comments: "no Comments",
//                                    views: "100 views"),
//
                           
                           
                           
//                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
//                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
//                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
//                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
//                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
//                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro Diaz", handler: "leandro diaz", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
//]

