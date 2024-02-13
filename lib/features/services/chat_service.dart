import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googly_sign_in/model/message_model.dart';

class ChatSevice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMesage(String receiverId, String message) async {
    final String senderEmail = _auth.currentUser!.email.toString();
    final String senderId = _auth.currentUser!.uid;
    final Timestamp time = Timestamp.now();

    Message newMessage = Message(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        senderEmail: senderEmail,
        timestamp: time);

    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatId = ids.join('_');
    _firestore
        .collection('user_chats')
        .doc(chatId)
        .collection('chat_messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String receiverId) {
    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatId = ids.join('_');

    return _firestore
        .collection('user_chats')
        .doc(chatId)
        .collection('chat_messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
