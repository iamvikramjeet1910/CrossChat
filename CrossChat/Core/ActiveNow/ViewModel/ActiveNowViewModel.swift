//
//  ActiveNowViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 25/05/25.
//

import Foundation
class ActiveNowViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    @MainActor
    private func fetchUsers() async throws {
        self.users = try await UserService.fetchAllUsers(limit: 10)
    }
}
