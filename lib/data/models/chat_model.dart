import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String? chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool seen;

  ChatMessageModel({
    this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.seen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "timestamp": timestamp.millisecondsSinceEpoch,
      "seen": seen,
    };
  }

  factory ChatMessageModel.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      chatId: doc.id,
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      seen: map['seen'] ?? false,
    );
  }
}
