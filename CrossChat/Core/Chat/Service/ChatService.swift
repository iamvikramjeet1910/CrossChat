import Foundation
import Firebase
import FirebaseAuth

struct ChatService {
    let chatPartner: User

    func sendMessage(_ messageText: String, fromLanguage: String, toLanguage: String, translatedText:String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id

        let currentUserRef = FirestoreConstants.MessageCollection.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = FirestoreConstants.MessageCollection.document(chatPartnerId).collection(currentUid)

        let recentCurrentUserRef = FirestoreConstants.MessageCollection.document(currentUid).collection("recent-messages").document(chatPartnerId)
        let recentPartnerRef = FirestoreConstants.MessageCollection.document(chatPartnerId).collection("recent-messages").document(currentUid)

        let messageId = currentUserRef.documentID

        let message = Message(
            messageId: messageId,
            fromId: currentUid,
            toId: chatPartnerId,
            messageText: messageText,
            timestamp: Timestamp(),
            originalLanguage: fromLanguage,
            translatedText: translatedText,
            targetLanguage: toLanguage,
            user: chatPartner
        )

        guard let messageData = try? Firestore.Encoder().encode(message) else { return }

        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)

        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)
    }

    func observerMessages(completion: @escaping([Message]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id

        let query = FirestoreConstants.MessageCollection
            .document(currentUid)
            .collection(chatPartnerId)
            .order(by: "timestamp", descending: false)

        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            var messages = changes.compactMap({try? $0.document.data(as: Message.self) })

            for (index, message) in messages.enumerated() where message.isFromCurrentUser {
                messages[index].user = chatPartner
            }

            completion(messages)
        }
    }
}
