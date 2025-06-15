//import SwiftUI
//import PhotosUI
//
//struct ProfileView: View {
//    @StateObject var viewModel = ProfileViewModel()
//    let user: User
//    
//    var body: some View {
//        VStack {
//            // Header Section
//            VStack {
//                PhotosPicker(selection: $viewModel.selectedItem) {
//                    // If profile image is cached or uploaded recently
//                    if let profileImage = viewModel.profileImage {
//                        profileImage
//                            .resizable()
//                            .frame(width: 80, height: 80)
//                            .clipShape(Circle())
//                    } else {
//                        CircularProfileImageView(user: user, size: .xlarge)
//                    }
//                }
//                
//                // Display user's full name
//                Text(user.fullname)
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .padding(.top, 8) // Spacing below profile image
//            }
//            .padding(.bottom, 16) // Spacing between header and list
//            
//            // Settings List Section
//            List {
//                Section {
//                    ForEach(SettingsOptionsViewModel.allCases) { option in
//                        HStack {
//                            Image(systemName: option.imageName)
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(option.imageBackgroundColor)
//                            
//                            Text(option.title)
//                                .font(.subheadline)
//                        }
//                    }
//                }
//                Section {
//                    Button("Log Out") {
//                        AuthService.shared.signOut()
//                    }
//                    Button("Delete Account") {
//                        // Handle account deletion
//                        // Add confirmation or deletion logic here
//                    }
//                }
//                .foregroundColor(.red) // Log out and Delete buttons in red
//            }
//        }
//        .padding() // Add padding around the main content
//        .alert("Error", isPresented: Binding<Bool>(
//            get: { viewModel.uploadError != nil }, // Check if there is an upload error
//            set: { _ in viewModel.uploadError = nil } // Clear error on alert dismissal
//        )) {
//            Text(viewModel.uploadError ?? "Unknown error") // Show error message
//        }
//    }
//}
//
//#Preview {
//    ProfileView(user: User.MOCK_USER)
//}

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    let user: User
    
    var body: some View {
        VStack {
            VStack {
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let profileImage = viewModel.profileImage {
                        profileImage
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else if let urlString = viewModel.profileImageUrl, let url = URL(string: urlString) {
                        // Show updated image fetched from Firestore
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image): image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            case .failure(_), .empty:
                                CircularProfileImageView(user: user, size: .xlarge)
                            @unknown default:
                                CircularProfileImageView(user: user, size: .xlarge)
                            }
                        }
                    } else {
                        CircularProfileImageView(user: user, size: .xlarge)
                    }
                }
                
                Text(user.fullname)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
            }
            .padding(.bottom, 16)
            // ... rest of your List/UI as before ...
            // Settings List Section
            List {
                Section {
                    ForEach(SettingsOptionsViewModel.allCases) { option in
                        HStack {
                            Image(systemName: option.imageName)
                                .resizable()
                                .frame(width: 24, height: 24)
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
                        // Handle account deletion
                        // Add confirmation or deletion logic here
                    }
                }
                .foregroundColor(.red) // Log out and Delete buttons in red
            }
        }
        .padding()
        .onAppear {
            viewModel.observeUserProfile()
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: { viewModel.uploadError != nil },
            set: { _ in viewModel.uploadError = nil }
        )) {
            Text(viewModel.uploadError ?? "Unknown error")
        }
    }
}
