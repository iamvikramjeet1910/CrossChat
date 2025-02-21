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
    let user: User
    let size: ProfileImageSize
        
    var body: some View {
        if let imageUrl = user.profileImageUrl {
            Image(imageUrl)
                .resizable()
                .frame(width:  size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image("person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        }
    }
}

#Preview {
    CircularProfileImageView(user: User.MOCK_USER, size: .medium)
}
