import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final String type;

  ChatModel(
      {required this.id,
      required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.content,
      required this.type});

  factory ChatModel.fromJson(DocumentSnapshot data) {
    Map<String, dynamic> x = data.data() as Map<String, dynamic>;
    return ChatModel(
        id: data.id,
        idFrom: x['idFrom'],
        idTo: x['idTo'],
        timestamp: x['timestamp'],
        content: x['content'],
        type: x['type']);
  }
}
