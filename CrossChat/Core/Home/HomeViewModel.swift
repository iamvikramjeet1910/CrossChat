//
//  HomeViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 15/06/25.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("Initializing HomeViewModel...") // Debug log
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        // Observe current user
        UserService.shared.$currentUser
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    
    }
}
