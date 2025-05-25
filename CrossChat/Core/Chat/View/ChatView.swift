//
//  ChatView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 21/02/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    let user: User
    
    @State private var selectedLanguage: String = "English"
    let languages = ["English", "Spanish", "French", "German", "Hindi"]
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                // header
                VStack {
                    CircularProfileImageView(user: user, size: .xlarge)
                    
                    VStack(spacing: 4) {
                        Text(user.fullname)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("CrossChat")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                }
                
                //messages
                
                ForEach(viewModel.messages) { message in
                    ChatMessageCell(message: message)
                }
                
                
                
            }
            // message input vie
            
            Spacer()
            ZStack(alignment: .trailing) {
                HStack(spacing: 8) { // HStack to arrange language picker, text field, and send button
                // Language selection picker
                    Picker("Language", selection: $selectedLanguage)
                        {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(.menu) // Use menu style for a dropdown effect
                    .frame(width: 100) // Adjust width as needed
                    .padding(.leading, 8) // Add some padding to the left
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                    .font(.subheadline)
                    .foregroundColor(.primary) // Ensure text color is visible

                    // Message input TextField
                    TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48) // Make space for the send button
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Capsule())
                    .font(.subheadline)
                }
                
                Button {
                    viewModel.sendMessage()
                    viewModel.messageText = ""
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
