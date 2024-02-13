import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final String senderEmail;
  final String message;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.senderEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
