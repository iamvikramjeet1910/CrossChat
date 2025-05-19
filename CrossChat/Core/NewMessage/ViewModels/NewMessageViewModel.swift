//
//  NewMessageViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 19/05/25.
//

import Foundation
import FirebaseAuth


@MainActor
class NewMessageViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter { $0.uid != currentUid }
    }
}
