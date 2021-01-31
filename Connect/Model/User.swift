//
//  User.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit


protocol UserSerializable {
    init?(dictionary: [String: Any])
}

struct User: Codable, Hashable {
    var userID = UUID()
    let profileImage: String
    var name: String
    let handler: String
    let email: String
//    let password: String
    let bio: String
    let location: String
    var feedID = UUID().uuidString
    var mainImage: String
    var otherImages: [String]
    var status: String
    var postedOn: Date
    var postTitle: String
    var messageDescription: String
    var likes: String  //Int
    var comments: String //Int
    var views: String //Int
    var allImages: [String] { return [mainImage] + otherImages}
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.userID == rhs.userID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
    
    var userDictionary : [String: Any] {
        return [
            
            "profileImage"  : profileImage,
            "name"          : name,
            "handler"       : handler,
            "email"         : email,
            //  "password"      : password,
            "bio"           : bio,
            "location"      : location,
            "feedID"        : feedID,
            "media"         : mainImage,
            "otherImages"   : otherImages,
            "status"        : status,
            "postedOn"      : postedOn,
            "postTitle"     : postTitle,
            "messageDescription": messageDescription,
            "likes"         : likes,
            "comments"      : comments,
            "views"         : views
        ]
    }
}

extension User: UserSerializable {
    init?(dictionary: [String : Any]) {
        guard
              let profileImage          = dictionary["profileImage"] as? String,
              let name                  = dictionary["name"        ] as? String,
              let handler               = dictionary["handler"     ] as? String,
              let email                 = dictionary["email"       ] as? String,
              
              let bio                   = dictionary["bio"         ] as? String,
              let location              = dictionary["location"    ] as? String,
              let feedID                = dictionary["feedID"      ] as? String,
              let mainImage             = dictionary["mainImage"   ] as? String,
              let otherImages           = dictionary["otherImages" ] as? [String],
              let status                = dictionary["status"      ] as? String,
              let postedOn              = dictionary["postedOn"    ] as? Date,
              let postTitle             = dictionary["postTitle"   ] as? String,
              let messageDescription    = dictionary["messageDescription"] as? String,
              let likes                 = dictionary["likes"       ] as? String,
              let comments              = dictionary["comments"    ] as? String,
              let views                 = dictionary[ "views"      ] as? String
        else { return nil}
        
        self.init(profileImage: profileImage, name: name, handler: handler, email: email, bio: bio, location: location, feedID: feedID, mainImage: mainImage, otherImages: otherImages, status: status, postedOn: postedOn, postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
    }
}



//Testing Data
let testingData: [User] = [User(userID: UUID(), profileImage: Images.profilePic, name: "Leandro Diaz", handler: "@leandroadiazr", email: "leandroadiazr@gmai.com", bio: "just a bio so i can test the whole thing.....", location: "Orlando FL", feedID: UUID().uuidString, mainImage: Images.backMedia, otherImages: [Images.backMedia, Images.backMedia], status: "Active", postedOn: Date(), postTitle: "Post Title", messageDescription: "message description,message description message description message description message description message description", likes: "100", comments: "no Comments", views: "300")]


















//
//protocol UserSerializable {
//    init?(dictionary: [String: Any])
//}
//
//struct User: Codable, Hashable {
//    var id = UUID()
//    let profileImage: String
//    var name: String
//    let handler: String
//    let email: String
//    //    let password: String
//    let bio: String
//    let location: String
//    let feed: [Feed]?
//
//    static func == (lhs: User, rhs: User) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    var userDictionary : [String: Any] {
//        return [
//            "profileImage"  : profileImage,
//            "name"          : name,
//            "handler"       : handler,
//            "email"         : email,
//            //  "password"      : password,
//            "bio"           : bio,
//            "location"      : location,
//            "feed"          : [Feed]()
//        ]
//    }
//}
//
//extension User: UserSerializable {
//    init?(dictionary: [String : Any]) {
//        guard let profileImage  = dictionary["profileImage"] as? String,
//              let name          = dictionary["name"        ] as? String,
//              let handler       = dictionary["handler"     ] as? String,
//              let email         = dictionary["email"       ] as? String,
//              //                      let password = dictionary[//  "password"] as? Stringpassword,
//              let bio           = dictionary["bio"         ] as? String,
//              let location      = dictionary["location"    ] as? String,
//              let feed          = dictionary["feed"        ] as? [Feed]
//        else { return nil}
//        self.init(profileImage: profileImage, name: name, handler: handler, email: email, bio: bio, location: location, feed: feed)
//    }
//}
//
//protocol FeedSerializable {
//    init?(dictionary: [String: Any])
//}
//
//struct Feed: Codable, Hashable {
//    var feedid = UUID()
//    static func == (lhs: Feed, rhs: Feed) -> Bool {
//        lhs.feedid == rhs.feedid
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(feedid)
//    }
//
//    var mainImage: String
//    var otherImages: [String]
//    var status: String
//    var postedOn: Date
//    var postTitle: String
//    var messageDescription: String
//    var likes: String  //Int
//    var comments: String //Int
//    var views: String //Int
//    var allImages: [String] { return [mainImage] + otherImages}
//
//    var feedsDectionary: [String: Any] {
//        return [
//            "media"         : mainImage,
//            "otherImages"   : otherImages,
//            "status"        : status,
//            "postedOn"      : postedOn,
//            "postTitle"     : postTitle,
//            "messageDescription": messageDescription,
//            "likes"         : likes,
//            "comments"      : comments,
//            "views"         : views
//        ]
//    }
//}
//
//extension Feed: FeedSerializable {
//    init?(dictionary: [String : Any]) {
//        guard let feedid                = dictionary["feedid"] as? UUID,
//              let mainImage             = dictionary["mainImage"  ] as? String,
//              let otherImages           = dictionary["otherImages"] as? String,
//              let status                = dictionary["status"     ] as? String,
//              let postedOn              = dictionary["postedOn"   ] as? Date,
//              let postTitle             = dictionary["postTitle"  ] as? String,
//              let messageDescription    = dictionary["messageDescription"] as? String,
//              let likes                 = dictionary["likes"] as? String,
//              let comments              = dictionary["comments"] as? String,
//              let views                 = dictionary[ "views"] as? String
//        else { return nil}
//        self.init(feedid: feedid, mainImage: mainImage, otherImages: [otherImages], status: status, postedOn: postedOn, postTitle: postTitle, messageDescription: messageDescription, likes: likes, comments: comments, views: views)
//    }
//}
//
//
////Testing Data
//let testingData: [User] = [User(id: UUID(), profileImage: Images.profilePic, name: "Leandro Diaz", handler: "@leandroadiazr", email: "leandroadiazr@gmai.com", bio: "just a bio so i can test the whole thing.....", location: "Orlando FL", feed: [Feed(feedid: UUID(), mainImage: Images.backMedia, otherImages: [Images.backMedia, Images.backMedia], status: "Active", postedOn: Date(), postTitle: "Post Title", messageDescription: "message description,message description message description message description message description message description", likes: "100", comments: "no Comments", views: "300")])]
//
//
//
