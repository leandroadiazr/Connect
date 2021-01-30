//
//  Feed.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//
/*
import UIKit

struct Feed: Codable, Hashable {
    let uuid = UUID()
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
       }
    
    
    var userName: User
    var profile: String
    var media: String
    var otherImages: [String]
    var status: String
    var postedOn: String
    var location: String
    var postTitle: String
    var description: String
    var likes: String
    var comments: String
    var views: String
    
    var allImages: [String] { return [media] + otherImages}
    
    
}

let testingFeed: [Feed] = [Feed(userName: User(
                                    profileImage: "",
                                    name: "leandro",
                                    handler: "leandro",
                                    bio: ""),
                                    profile: Images.profilePic ,
                                    media: Images.backMedia,
                                    otherImages: [],
                                    status: "Just posted",
                                    postedOn: "10/10/2020",
                                    location: "California",
                                    postTitle: "Nice Background",
                                    description: "Just a desc asdfasdfasdfas dfasdfasd fasdfasd fasdfasdfas fasdfasdfas fasdfasdfas fasdfasdfas fasdfasdfas  dfasdfasdfasdfasd  fasdfasdf",
                                    likes: "100",
                                    comments: "no Comments",
                                    views: "100 views"),
                           
                           
                           
                           
                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro", handler: "leandro", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
                           Feed(userName: User(profileImage: Images.profilePic, name: "leandro Diaz", handler: "leandro diaz", bio: ""), profile: Images.profilePic , media: Images.backMedia, otherImages: [], status: "Just posted", postedOn: "10/10/2020", location: "California", postTitle: "Nice Background", description: "Just a desc", likes: "100", comments: "no Comments", views: "100 views"),
]
*/
