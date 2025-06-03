import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messageText = ""
    @Published var messages = [Message]()

    // Chat partner and Chat service
    let service: ChatService
    let chatPartner: User
    let translationService = TranslationService()

    // Preferred languages
    @Published var senderPreferredLang: String = "en" // Default to English
    @Published var partnerPreferredLang: String = "en" // Default to English
    @Published var translatedText : String = "Sending the default value becoz there is some error i translation"
    
    private var partnerListener: ListenerRegistration?
    
    init(user: User) {
        self.chatPartner = user
        self.service = ChatService(chatPartner: user)

        // Fetch languages and observe messages
        fetchCurrentUserLanguage()
//        fetchPartnerLanguage()
        observePartnerLanguage()
        observeMessages()
    }

    // Fetch the current user's preferred language
    private func fetchCurrentUserLanguage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: Current user is not authenticated!")
            return
        }
        
        // Firestore call to get user's preferred language
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching current user's preferred language: \(error.localizedDescription)")
                    return
                }
                
                if let data = snapshot?.data(),
                   let lang = data["preferredLanguage"] as? String {
                    DispatchQueue.main.async {
                        self.senderPreferredLang = lang
                        print("Fetched sender preferred language: \(lang)")
                    }
                } else {
                    print("Preferred language not found for current user.")
                }
            }
    }

    // Fetch the chat partner's preferred language
//    private func fetchPartnerLanguage() {
//        let partnerId = chatPartner.id
//        
//        // Firestore call to get partner's preferred language
//        Firestore.firestore()
//            .collection("users")
//            .document(partnerId)
//            .getDocument { snapshot, error in
//                if let error = error {
//                    print("Error fetching partner's preferred language: \(error.localizedDescription)")
//                    return
//                }
//                
//                if let data = snapshot?.data(),
//                   let lang = data["preferredLanguage"] as? String {
//                    DispatchQueue.main.async {
//                        self.partnerPreferredLang = lang
//                        print("Fetched partner preferred language: \(lang)")
//                    }
//                } else {
//                    print("Preferred language not found for chat partner.")
//                }
//            }
//    }
    // New observer for partner's language
        func observePartnerLanguage() {
            let partnerId = chatPartner.id
            partnerListener = Firestore.firestore()
                .collection("users")
                .document(partnerId)
                .addSnapshotListener { [weak self] snapshot, error in
                    guard let self = self else { return }
                    if let data = snapshot?.data(),
                        let lang = data["preferredLanguage"] as? String {
                        DispatchQueue.main.async {
                            self.partnerPreferredLang = lang
                        }
                    }
                }
        }

        deinit {
            partnerListener?.remove()
        }
    // Observe messages using ChatService
    func observeMessages() {
        service.observerMessages { messages in
            DispatchQueue.main.async {
                self.messages.append(contentsOf: messages)
                print("Observed \(messages.count) new messages.")
            }
        }
    }
    
    // Send a message to the chat partner
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Message text is empty. Cannot send.")
            return
        }
        guard !senderPreferredLang.isEmpty, !partnerPreferredLang.isEmpty else {
            print("Sender preferred language or partner preferred language is not set")
            return
        }

        // Perform translation before sending the message
        print("Message text to translate: \(messageText)")
        print("Sender language: \(senderPreferredLang)")
        print("Partner language: \(partnerPreferredLang)")
        translationService.translate(
            text: messageText,
            fromLanguage: senderPreferredLang,
            toLanguage: partnerPreferredLang
        ) { [weak self] translatedText in
            print("Raw response from API: \(String(describing: translatedText))")
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let translatedText = translatedText {
                    // Include translated text with the original message
                    self.service.sendMessage(
                        self.messageText,
                        fromLanguage: self.senderPreferredLang,
                        toLanguage: self.partnerPreferredLang,
                        translatedText: translatedText // Pass translated text
                    )
                    print("Message sent with translation: \(translatedText)")
                } else {
                    print("Translation failed. Sending original text.")
                    self.service.sendMessage(
                        self.messageText,
                        fromLanguage: self.senderPreferredLang,
                        toLanguage: self.partnerPreferredLang,
                        translatedText: self.messageText
                    )
                }

                // Clear text input after sending
                self.messageText = ""
            }
        }
    }

    // Update the current user's preferred language
    func updatePreferredLanguage(_ language: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: Current user is not authenticated!")
            return
        }

        // Update language in Firestore
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData(["preferredLanguage": language]) { [weak self] error in
                if let error = error {
                    print("Error updating preferred language: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.senderPreferredLang = language
                    print("Preferred language updated to \(language).")
                }
            }
    }
}
