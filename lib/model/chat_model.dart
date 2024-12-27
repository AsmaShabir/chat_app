import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final DateTime timestamp;

  Chat({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.timestamp,
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
      chatId: doc.id,
      participants: List<String>.from(doc['participants']),
      lastMessage: doc['lastMessage'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}
