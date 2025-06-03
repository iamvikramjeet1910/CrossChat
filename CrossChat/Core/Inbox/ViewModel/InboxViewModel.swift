//
//  InboxViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 18/05/25.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth

class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    
    private var cancellables = Set<AnyCancellable>()
    private let service = InboxService()
    
    init() {
        print("Initializing InboxViewModel...") // Debug log
        setupSubscribers()
        service.observeRecentMessages() // Ensure this happens after the user is authenticated
    }
    
    private func setupSubscribers() {
        // Observe current user
        UserService.shared.$currentUser
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
        
        // Observe recent messages document changes
        service.$documentChanges
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink { [weak self] changes in
                self?.loadInitialMessages(fromChanges: changes)
            }
            .store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        print("Processing \(changes.count) document changes...") // Debug log
        
        var messages = changes.compactMap { try? $0.document.data(as: Message.self) }
        
        // Iterate through messages and fetch user info for each message
        for i in 0 ..< messages.count {
            let message = messages[i]
            
            UserService.fetchUser(withUid: message.chatPartnerId) { user in
                DispatchQueue.main.async { // Ensure UI updates occur on the main thread
                    messages[i].user = user
                    
                    // Avoid duplicates in recentMessages
                    if !self.recentMessages.contains(where: { $0.messageId == messages[i].messageId }) {
                        self.recentMessages.append(messages[i])
                    }
                }
            }
        }
    }
    
    func updatePreferredLanguage(_ language: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData(["preferredLanguage": language]) { error in
                if let error = error {
                    print("Error updating preferred language: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.currentUser?.preferredLanguage = language
                    print("Preferred language updated to \(language)")
                }
            }
    }
}
