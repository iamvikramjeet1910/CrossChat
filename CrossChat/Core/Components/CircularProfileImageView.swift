//
//  CircularProfileImageView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 21/02/25.
//

import SwiftUI

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xlarge
    
    var dimension: CGFloat {
        switch self {
            
        case .xxSmall:
            return 28
        case .xSmall:
            return 32
        case .small:
            return 40
        case .medium:
            return 56
        case .large:
            return 64
        case .xlarge:
            return 80
        }
    }
}

struct CircularProfileImageView: View {
    var user: User?
    let size: ProfileImageSize
        
    var body: some View {
        if let profileImageUrl = user?.profileImageUrl, let url = URL(string: profileImageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: size.dimension, height: size.dimension)
                        .clipShape(Circle())
                case .failure(_):
                    CircularProfileImageView(user: user, size: .xlarge) // Fallback UI
                case .empty:
                    ProgressView() // Loading indicator
                @unknown default:
                    // Safe fallback for unexpected states
                    Text("Unexpected image loading state.")
                        .foregroundColor(.red)
                        .frame(width: 80, height: 80)
                }
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .foregroundColor(.red)
        }
    }
}

#Preview {
    CircularProfileImageView(user: User.MOCK_USER, size: .medium)
}
