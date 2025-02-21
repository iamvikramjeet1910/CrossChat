//
//  ActiveNowView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 17/02/25.
//

import SwiftUI

struct ActiveNowView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 32){
                ForEach(0...10, id: \.self) { user in
                    VStack{
                        ZStack(alignment: .bottomTrailing){
                            CircularProfileImageView(user: User.MOCK_USER, size: .medium)
                            ZStack{
                                Circle()
                                    .fill(.white)
                                    .frame(width: 18, height: 18)
                                Circle()
                                    .fill(Color(.systemGreen))
                                    .frame(width: 12, height: 12)
                            }
                        }
                        Text("Vikram")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .frame(height: 106)
        
    }
}

#Preview {
    ActiveNowView()
}
