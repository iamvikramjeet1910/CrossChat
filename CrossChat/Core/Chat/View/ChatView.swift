//import SwiftUI
//
//struct ChatView: View {
//    @StateObject var viewModel: ChatViewModel
//    let user: User
//
//    // Map display strings to language codes
//    // Map display strings to language codes
//    let languageMap = [
//        "English": "en",
//        "Spanish": "es",
//        "French": "fr",
//        "German": "de",
//        "Italian": "it",
//        "Portuguese": "pt",
//        "Russian": "ru",
//        "Chinese (Simplified)": "zh-CN",
//        "Japanese": "ja"
//    ]
//
//    let languages = [
//        "English",
//        "Spanish",
//        "French",
//        "German",
//        "Italian",
//        "Portuguese",
//        "Russian",
//        "Chinese (Simplified)",
//        "Japanese"
//    ]
//
//    @State private var selectedLanguage: String = "en" // Default
//
//    init(user: User) {
//        self.user = user
//        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
//    }
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                // header
//                VStack {
//                    CircularProfileImageView(user: user, size: .xlarge)
//                    VStack(spacing: 4) {
//                        Text(user.fullname)
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                        Text("CrossChat")
//                            .font(.footnote)
//                            .foregroundColor(.gray)
//                    }
//                }
//                // messages
//                ForEach(viewModel.messages) { message in
//                    ChatMessageCell(message: message)
//                }
//            }
//            
//            Spacer()
//            ZStack(alignment: .trailing) {
//                HStack(spacing: 8) {
//                    // Language selection picker
//                    Picker("Language", selection: $selectedLanguage) {
//                        ForEach(languages, id: \.self) { language in
//                            Text(language)
//                        }
//                    }
//                    .onChange(of: selectedLanguage) { oldLang, newLang in
//                        if let code = languageMap[newLang],
//                           code != viewModel.senderPreferredLang {
//                            viewModel.updatePreferredLanguage(code)
//                        }
//                    }
//                    .pickerStyle(.menu)
//                    .frame(width: 100)
//                    .padding(.leading, 8)
//                    .background(Color(.systemGroupedBackground))
//                    .clipShape(Capsule())
//                    .font(.subheadline)
//                    .foregroundColor(.primary)
//
//                    // Message input
//                    TextField("Message...", text: $viewModel.messageText, axis: .vertical)
//                        .padding(12)
//                        .padding(.trailing, 48)
//                        .background(Color(.systemGroupedBackground))
//                        .clipShape(Capsule())
//                        .font(.subheadline)
//                }
//
//                Button {
//                    print("Sender language is : \(viewModel.senderPreferredLang) ")
//                    print("Partner language is : \(viewModel.partnerPreferredLang) ")
//                    viewModel.sendMessage()
//                } label: {
//                    Text("Send")
//                        .fontWeight(.semibold)
//                }
//                .padding(.horizontal)
//            }
//            .padding()
//        }
//        .onAppear {
//            // Set Picker to user’s preferred language, if possible, without triggering state update warning
//            DispatchQueue.main.async {
//                if !viewModel.senderPreferredLang.isEmpty,
//                   let langName = languageMap.first(where: { $0.value == viewModel.senderPreferredLang })?.key {
//                    selectedLanguage = langName
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ChatView(user: User.MOCK_USER)
//}

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
                    ChatMessageCell(message: message)
                }
            }

            Spacer()
            ZStack(alignment: .trailing) {
                HStack(spacing: 8) {
                    // No language picker here
                    TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                        .padding(12)
                        .padding(.trailing, 48)
                        .background(Color(.systemGroupedBackground))
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
