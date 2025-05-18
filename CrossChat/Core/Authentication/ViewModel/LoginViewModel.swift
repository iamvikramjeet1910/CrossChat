//
//  LoginViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 18/05/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}

