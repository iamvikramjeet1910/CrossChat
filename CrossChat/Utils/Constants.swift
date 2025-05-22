//
//  Constants.swift
//  CrossChat
//
//  Created by Vikram Kumar on 22/05/25.
//

import Foundation
import Firebase

struct FirestoreConstants {
    
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessageCollection = Firestore.firestore().collection("messages")
    
}
