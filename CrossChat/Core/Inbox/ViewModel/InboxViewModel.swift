//
//  InboxViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 18/05/25.
//

import Foundation
import Firebase
import Combine



class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers(){
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
    

}
