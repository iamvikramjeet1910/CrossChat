//
//  PeopleView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 14/06/25.
//

import SwiftUI

struct PeopleView: View {
    let user: User
    var addAction: () -> Void
    
    var body: some View {
        VStack {
//            Image("vikram_img")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 70, height: 70)
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.blue, lineWidth: 2)) // optional border
//                .shadow(radius: 3)
            ZStack {
                CircularProfileImageView(user: user, size: .medium)
                Button(action: addAction) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 24, height: 24)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .offset(x: 30, y: -30) // Position button slightly outside the image edge
            }
            Text(user.fullname)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding(5)
    }
}

//#Preview {
//    PeopleView()
//}
