//
//  InboxView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 17/02/25.
//

import SwiftUI

struct InboxView: View {
    @State private var showNewMessageView = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false

    private var user: User? {
        return viewModel.currentUser
    }

    // Deduplicate and sort recent messages
    private var uniqueRecentMessages: [Message] {
        let groupedMessages = Dictionary(grouping: viewModel.recentMessages, by: { $0.chatPartnerId }) // Group messages by chat partner ID
        let mostRecentInGroup = groupedMessages.compactMap { $1.max(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() }) } // Get the most recent message
        return mostRecentInGroup.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) // Sort by timestamp (most recent first)
    }

    var body: some View {
        NavigationStack {
            
                

                List {
                    ActiveNowView()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical)
                        .padding(.horizontal, 4)
                    
                    ForEach(uniqueRecentMessages) { message in
                        ZStack {
                            NavigationLink(value: message) {
                                EmptyView()
                            }.opacity(0.0)
                            InboxRowView(message: message)
                        }
                    }
                }
            .listStyle(PlainListStyle())
            .onChange(of: selectedUser, perform: { newValue in
                showChat = newValue != nil
            })
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    ChatView(user: user)
                }
            })
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationDestination(isPresented: $showChat, destination: {
                if let user = selectedUser {
                    ChatView(user: user)
                }
            })
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewMessageView(selectedUser: $selectedUser)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationLink(value: user) {
                            CircularProfileImageView(user: user, size: .small)
                        }

                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewMessageView.toggle()
                        selectedUser = nil
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray5))
                    }
                }
            }
        }
    }
}

#Preview {
    InboxView()
}
