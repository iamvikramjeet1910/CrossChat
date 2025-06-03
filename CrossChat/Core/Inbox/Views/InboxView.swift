

import SwiftUI

struct InboxView: View {
    @State private var showNewMessageView = false
    @StateObject private var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false

    // Language selection
    let languageMap = [
        "English": "en", "Hindi" : "hi", "Maithili" : "mai", "Spanish": "es", "French": "fr", "German": "de",
        "Italian": "it", "Russian": "ru", "Chinese (Simplified)": "zh-CN", "Japanese": "ja",
        "Awadhi" : "awa", "Bhojpuri" : "bho", "Gujarati" : "gu",
        "Kannada" : "kn",
        "Marathi" : "mr",
        "Punjabi" : "pa",
        "Tamil" : "ta",
        "Telugu" : "te"
    ]
    let languages = [
        "English", "Hindi", "Maithili", "Kannada", "Awadhi", "Bhojpuri", "Gujarati", "Marathi", "Punjabi", "Tamil",
        "Telugu", "Spanish", "French", "German", "Italian", "Russian", "Chinese (Simplified)", "Japanese"
    ]
    @State private var selectedLanguage: String = "English"

    // Deduplicate and sort as before
    private var uniqueRecentMessages: [Message] {
        let groupedMessages = Dictionary(grouping: viewModel.recentMessages, by: { $0.chatPartnerId })
        let mostRecentInGroup = groupedMessages.compactMap {
            $1.max(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
        }
        return mostRecentInGroup.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
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
            .onChange(of: selectedUser) { newValue in
                showChat = newValue != nil
            }
            .navigationDestination(for: Message.self) { message in
                if let user = message.user {
                    ChatView(user: user) // language preference will be loaded from Firestore in ChatViewModel!
                }
            }
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
            .navigationDestination(isPresented: $showChat) {
                if let user = selectedUser {
                    ChatView(user: user)
                }
            }
            .fullScreenCover(isPresented: $showNewMessageView) {
                NewMessageView(selectedUser: $selectedUser)
            }
            .toolbar {
                // Profile + title
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationLink(value: viewModel.currentUser) {
                            CircularProfileImageView(user: viewModel.currentUser, size: .small)
                        }
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                // Language Selector
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { lang in
                            Text(lang)
                        }
                    }
                    .onChange(of: selectedLanguage) { _, newLang in
                        if let code = languageMap[newLang],
                           code != viewModel.currentUser?.preferredLanguage {
                            viewModel.updatePreferredLanguage(code)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 110)
                    .accessibilityLabel("Select Preferred Language")
                }
                // New Message Button
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
            .onAppear {
                // On appear, set current user's preferred language based on Firestore data
                if
                    let langCode = viewModel.currentUser?.preferredLanguage,
                    let langName = languageMap.first(where: { $0.value == langCode })?.key
                {
                    selectedLanguage = langName
                }
            }
        }
    }
}
