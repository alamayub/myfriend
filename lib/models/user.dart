import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photo;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.photo});

  factory UserModel.fromJson(DocumentSnapshot data) {
    Map<String, dynamic> x = data.data() as Map<String, dynamic>;
    return UserModel(
        uid: data.id,
        name: x['idFrom'],
        email: x['timestamp'],
        photo: x['photo']);
  }
}
