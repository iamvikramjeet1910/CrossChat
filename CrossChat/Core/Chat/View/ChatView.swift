

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    let user: User
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }

    var body: some View {
        VStack {
            ScrollView {
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
                ForEach(viewModel.messages) { message in
                    ChatMessageCell(message: message, OtherUser: viewModel.chatPartner)
                }
            }

            Spacer()
            ZStack(alignment: .trailing) {
                HStack(spacing: 8) {
                    // No language picker here
                    TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                        .padding(12)
                        .padding(.trailing, 48)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                        .font(.subheadline)
                }
                Button {
                    viewModel.sendMessage()
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
