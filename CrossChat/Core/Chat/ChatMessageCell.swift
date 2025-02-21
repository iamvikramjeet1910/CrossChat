//
//  ChatMessageCell.swift
//  CrossChat
//
//  Created by Vikram Kumar on 21/02/25.
//

import SwiftUI

struct ChatMessageCell: View {
    let isFromCurrentUser: Bool
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                Text("This is a test message for now. This is Longer message and lets see whats happened")
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    CircularProfileImageView(user: User.MOCK_USER, size: .xxSmall)
                    
                    Text("This is a test message for now & This is longer Message uhgflafuig ")
                        .font(.subheadline)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.black)
                        .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.75, alignment: .leading)
                    Spacer()
                    
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    ChatMessageCell(isFromCurrentUser: false)
}
