import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfriend/screens/auth/authenticate.dart';
import 'home/my_friend.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var data = snapshot.data;
            if (data != null) {
              return const MyFriend();
            } else {
              return const Authenticate();
            }
          }
          return const Scaffold(body: Center(child: Text('loading')));
        });
  }
}
