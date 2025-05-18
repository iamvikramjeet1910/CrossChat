//
//  RegistrationViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 18/05/25.
//

import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
    }
    
}
