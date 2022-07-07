import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfriend/models/chat.dart';
import 'package:myfriend/models/chat_list_user.dart';
import 'package:myfriend/services/auth.dart';

import '../utils/utils.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // store user info
  register(String name, String email, String password, File? file) async {
    bool res = false;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? url;
        if (file != null) url = await AuthService().uploadImage(file);
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'photoURL': url,
          'createdAt': DateTime.now().microsecondsSinceEpoch,
          'updatedAt': DateTime.now().microsecondsSinceEpoch
        });
        await user.updateDisplayName(name);
        await user.updateEmail(email);
        await user.updatePassword(password);
        await user.reload();
        res = true;
      } else {
        showMessage('Please login');
      }
    } on FirebaseAuthException catch (e) {
      showMessage(e.message!);
    } catch (e) {
      showMessage(e.toString());
    }
    return res;
  }

  // update profile
  updateProfile(String name, String email, String password, File? file) async {
    bool res = false;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? url;
        if (file != null) {
          url = await AuthService().uploadImage(file);
        }
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'email': email,
          'photoURL': url,
          'updatedAt': DateTime.now().microsecondsSinceEpoch
        });
        if (user.displayName != name) await user.updateDisplayName(name);
        if (user.email != email) await user.updateEmail(email);
        if (password.isNotEmpty && password.length >= 6) {
          await user.updatePassword(password);
        }
        await user.reload();
        res = true;
      } else {
        showMessage('Please login');
      }
    } on FirebaseAuthException catch (e) {
      showMessage(e.message!);
    } catch (e) {
      showMessage(e.toString());
    }
    return res;
  }

  // get chat users list
  Stream<List<ChatUserListModel>> charUsersList(int limit, String uid) {
    return _firestore
        .collection('messages')
        .where('people', arrayContains: uid)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot doc) => ChatUserListModel.fromJson(doc))
            .toList());
  }

  // get chat list
  Stream<List<ChatModel>> chatMessageList(int limit, String chatId) {
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot doc) => ChatModel.fromJson(doc))
            .toList());
  }
}
