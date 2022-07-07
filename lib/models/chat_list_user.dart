import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserListModel {
  final String id;
  final String lastMessage;
  final String lastMessageBy;
  final String lastmessageType;
  final String timestamp;

  ChatUserListModel({
    required this.id,
    required this.lastMessage,
    required this.lastMessageBy,
    required this.lastmessageType,
    required this.timestamp,
  });

  factory ChatUserListModel.fromJson(DocumentSnapshot data) {
    Map<String, dynamic> x = data.data() as Map<String, dynamic>;
    return ChatUserListModel(
        id: data.id,
        lastMessage: x['last_message'],
        lastMessageBy: x['last_message_by'],
        lastmessageType: x['message_type'],
        timestamp: x['timestamp']);
  }
}
