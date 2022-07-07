import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/utils.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // login with email and password
  loginWithEmailAndPassword(String email, String password) async {
    bool res = false;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = _auth.currentUser;
      if (user != null) res = true;
    } on FirebaseAuthException catch (e) {
      showMessage(e.message!);
    } catch (e) {
      showMessage(e.toString());
    }
    return res;
  }

  // create user with email and password
  register(String name, String email, String password) async {
    bool res = false;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((val) async {
        User? user = val.user;
        await _firestore.collection('users').doc(user!.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'photo': null,
          'createdAt': DateTime.now().microsecondsSinceEpoch,
          'updatedAt': DateTime.now().microsecondsSinceEpoch
        });
        await user.updateDisplayName(name);
        // await updateProfile(name, email, password, file);
        res = true;
      });
    } on FirebaseAuthException catch (e) {
      showMessage(e.message!);
    } catch (e) {
      showMessage(e.toString());
    }
    return res;
  }

  // upload image
  uploadImage(String path, File file) async {
    String? res;
    try {
      final uploadTask = _storage.ref(path).putFile(file);
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print('Upload is $progress% complete.');
            break;
          case TaskState.paused:
            showMessage("Upload is paused.");
            break;
          case TaskState.canceled:
            showMessage("Upload was canceled");
            break;
          case TaskState.error:
            showMessage("Something went wrong!");
            break;
          case TaskState.success:
            var url = await taskSnapshot.ref.getDownloadURL();
            res = url;
            break;
        }
      });
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
      User user = _auth.currentUser!;
      if (file != null) {
        var x = await uploadImage('users/${user.uid}', file);
        print('File $x');
        await _firestore.collection('users').doc(user.uid).update({'photo': x});
        await user.updatePhotoURL(x);
      }
      if (user.displayName != name) {
        await user.updateDisplayName(name);
      }
      if (user.email != email) {
        await user.updateEmail(email);
      }
      if (password.isNotEmpty && password.length >= 6) {
        await user.updatePassword(password);
      }
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'email': email,
        'updatedAt': DateTime.now().microsecondsSinceEpoch
      });
      await user.reload();
      res = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showMessage('Please login again before updating profile!');
        await logout();
      } else {
        showMessage(e.message!);
      }
    } catch (e) {
      showMessage(e.toString());
    }
    return res;
  }

  // logout
  logout() async {
    try {
      await _auth
          .signOut()
          .then((val) => showMessage('Logged out successfully!'));
    } on FirebaseAuthException catch (e) {
      showMessage(e.message!);
    } catch (e) {
      showMessage(e.toString());
    }
  }
}
