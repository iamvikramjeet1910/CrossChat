//
//  User.swift
//  CrossChat
//
//  Created by Vikram Kumar on 21/02/25.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    var id = NSUUID().uuidString
    let fullname: String
    let email: String
    var profileImageUrl: String?
}

extension User {
    static let MOCK_USER = User(fullname: "Vikram Kumar", email: "vikram123@gmail.com", profileImageUrl: "vikram_img")
}
