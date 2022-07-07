import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfriend/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        FocusScopeNode node = FocusScope.of(context);
        if (!node.hasPrimaryFocus && node.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'My Friend',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Wrapper(),
      ),
    );
  }
}