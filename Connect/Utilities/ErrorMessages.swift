//
//  ErrorMessages.swift
//  Connect
//
//  Created by Leandro Diaz on 1/31/21.
//

import Foundation

enum ErrorMessages: String, Error {
    case unableToSave           = "Unable to save this user, please verify"
    case unableToCreate         = "Unable to create this user in the database"
    case unableToFindUser       = "Unable to find this user, please check your credentials"
    case uknown                 = "There is an error"
    case unableToSaveProfile    = "Unable To Save Profile Try Again"
}
