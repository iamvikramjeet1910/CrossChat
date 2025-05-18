//
//  ProfileView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 21/02/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()

    let user: User
    var body: some View {
        VStack {
            // header
            VStack {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let profileImage = viewModel.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        CircularProfileImageView(user: user, size: .xlarge)
                        
                    }
                    
                }
                
                Text(user.fullname)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            // List
            List {
                Section {
                    ForEach(SettingsOptionsViewModel.allCases) { option in
                        HStack {
                            Image(systemName: option.imageName)
                                .resizable()
                                .frame(width:24, height: 24)
                                .foregroundColor(option.imageBackgroundColor)
                            
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                Section {
                    Button("Log Out") {
                        AuthService.shared.signOut()
                    }
                    Button("Delete Account") {
                        
                    }
                }
                .foregroundColor(.red)
            }
            
        }
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER)
}
