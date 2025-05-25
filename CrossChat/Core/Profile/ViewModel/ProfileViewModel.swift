//
//  ProfileViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 21/02/25.
//

//import Foundation
//import PhotosUI
//import _PhotosUI_SwiftUI
//import SwiftUICore
//
//class ProfileViewModel: ObservableObject {
//    @Published var selectedItem: PhotosPickerItem? {
//        didSet { Task { try await loadImage() }}
//    }
//     
//    @Published var profileImage: Image?
//    
//    func loadImage() async throws {
//        guard let item = selectedItem else { return }
//        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
//        guard let uiImage = UIImage(data: imageData) else { return }
//        self.profileImage = Image(uiImage: uiImage)
//    }
//}

import Foundation
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import SwiftUICore
import _PhotosUI_SwiftUI
import FirebaseAuth

@MainActor
class ProfileViewModel: ObservableObject{
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await uploadProfileImage() // Trigger image upload
            }
        }
    }
    @Published var profileImage: Image?
    @Published var uploadError: String?

    private let userId = Auth.auth().currentUser?.uid // Get the current user's ID

     //Uploads profile image to Firebase Storage and updates Firestore
    func uploadProfileImage() async throws {
        guard let item = selectedItem else {
            uploadError = "No image selected."
            return
        }

        do {
            // Load image data
            guard let imageData = try await item.loadTransferable(type: Data.self) else {
                uploadError = "Failed to load image data."
                return
            }
            
            // Convert image data to UIImage
            guard let uiImage = UIImage(data: imageData) else {
                uploadError = "Failed to convert image data to UIImage."
                return
            }

            // Compress image for storage
            let compressedImageData = uiImage.jpegData(compressionQuality: 0.8)
            
            // Generate path for profile image in Firebase Storage
            let storageRef = Storage.storage().reference().child("profile_images/\(userId ?? "unknown_user").jpg")
            
            // Upload image to Firebase Storage
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(compressedImageData ?? Data(), metadata: metadata)
            
            // Get download URL
            let downloadURL = try await storageRef.downloadURL().absoluteString
            
            // Update Firestore user document with new profile image URL
            try await updateUserProfileImage(url: downloadURL)
            
            // Update UI with new image
            self.profileImage = Image(uiImage: uiImage)
        } catch {
            // Handle upload errors
            uploadError = "Upload failed: \(error.localizedDescription)"
        }
    }
    // Updates the Firestore user's document with the profile image URL
    private func updateUserProfileImage(url: String) async throws {
        guard let userId = userId else {
            uploadError = "User not found."
            throw NSError(domain: "ProfileViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "User ID not found."])
        }

        // Update Firestore document
        do {
            let userRef = Firestore.firestore().collection("users").document(userId)
            try await userRef.updateData(["profileImageUrl": url]) // Update the profileImageUrl field
        } catch {
            uploadError = "Failed to update profile image in Firestore: \(error.localizedDescription)"
            throw error
        }
    }
}
