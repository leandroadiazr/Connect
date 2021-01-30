//
//  Menu.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import Foundation

struct Menu {
    var buttonName: String
}

let menuTesting = [Menu(buttonName: "Featured"),
                   Menu(buttonName: "All Posts"),
                   Menu(buttonName: "Go Live"),
                   Menu(buttonName: "Videos"),
                   Menu(buttonName: "Audio"),
                   Menu(buttonName: "Photos"),]

enum Buttons: String {
    case featured = "Featured"
    
}
