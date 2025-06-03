//
//  InboxRowView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 17/02/25.
//

import SwiftUI

struct InboxRowView: View {
    let message: Message
    
    private var isFromCurrentUser: Bool {
        return message.isFromCurrentUser
    }
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImageView(user: message.user, size: .medium)
            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.fullname ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if isFromCurrentUser {
                    Text(message.messageText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
                } else {
                    HStack(alignment: .bottom, spacing: 8) {
                        Text(message.translatedText ?? "Not able to translate")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
                
                        }
                }
                
            }
            HStack {
                Text(message.timestampString)
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        //.padding(.horizontal)
        .frame(height: 72)
         
    }
}
//
//#Preview {
//    InboxRowView()
//}
