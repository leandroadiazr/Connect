//
//  Tweet.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import Foundation


struct Tweet {
    let user: User
    let message: String
}


let tweetsData: [Tweet] = [Tweet(user: User(userID: UUID(), profileImage: Images.profilePic, name: "Leandro", handler: "@myhandler", email: "", bio: "just a bio", location: "My location", feedID: UUID().uuidString, mainImage: Images.backMedia, otherImages: [Images.backMedia, Images.backMedia], status: "active", postedOn: Date(), postTitle: " A Title" , messageDescription: "Message ", likes: "100", comments: "no comments", views: "300"), message: "This is a message sdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf a]sfa sdafa sdfas")
    
    
//    Tweet(user: User(id: UUID(), profileImage: Images.profilePic, name: "Leandro", handler: "@myhandler", email: "", bio: "just a bio", location: "My location", feed: nil), message: "This is a message sdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf asfa sdafa sdfas asdfasd fas dfasdfa sdfas fasfas dfasdf a]sfa sdafa sdfas"),
//

                          ]


