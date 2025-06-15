//
//  PeoplesViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 14/06/25.
//

import Foundation

@MainActor
class PeoplesViewModel: ObservableObject {
    @Published var users: [User] = []           // Stores the list of all users
    @Published var isLoading: Bool = false     // Tracks the loading state
    @Published var errorMessage: String?       // Holds any error message, if needed

    init() {
        fetchUsers() // Automatically fetch users when the ViewModel is initialized
    }

    /// Fetch all users from the database using UserService
    func fetchUsers() {
        isLoading = true // Start loading
        Task {
            do {
                // Fetch all users via UserService
                let allUsers = try await UserService.fetchAllUsers()
                
                // Update the UI with the fetched users
                self.users = allUsers
                print("Fetched users: \(allUsers)")
                self.errorMessage = nil // No errors
                
            } catch {
                // Handle any errors that occur during the fetch
                self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                print("Error fetching users: \(error.localizedDescription)")
            }
            isLoading = false // End loading
        }
    }
}
