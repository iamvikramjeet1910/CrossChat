//
//  InboxService.swift
//  CrossChat
//
//  Created by Vikram Kumar on 22/05/25.
//

import Foundation
import Firebase
import FirebaseAuth

class InboxService {
    @Published var documentChanges = [DocumentChange]()
    
    func observeRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: User is not authenticated.") // Debug log
            return
        }
        
        let query = FirestoreConstants
            .MessageCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error observing snapshots: \(error.localizedDescription)")
                return
            }
            
            guard let changes = snapshot?.documentChanges.filter({
                $0.type == .added || $0.type == .modified
            }) else {
                print("Snapshot listener: No document changes.")
                return
            }
            
            print("Document changes observed: \(changes.count)") // Debug log
            DispatchQueue.main.async { // Ensure changes are published on the main thread
                self.documentChanges = changes
            }
        }
    }
}
