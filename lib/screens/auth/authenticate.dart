import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showSignIn = true;

  void _toggleView() {
    setState(() => _showSignIn = !_showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignIn) {
      return LoginScreen(toggleView: _toggleView);
    } else {
      return RegisterScreen(toggleView: _toggleView);
    }
  }
}
