//
//  ChatMessageCell.swift
//  CrossChat
//
//  Created by Vikram Kumar on 21/02/25.
//

import SwiftUI

struct ChatMessageCell: View {
    let message: Message

    
    private var isFromCurrentUser: Bool {
        return message.isFromCurrentUser
    }
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                Text(message.messageText)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    CircularProfileImageView(user: message.user, size: .xxSmall)
                    
                    Text(message.translatedText ?? "Not able to translate")
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

//#Preview {
//    ChatMessageCell(isFromCurrentUser: false)
//}
