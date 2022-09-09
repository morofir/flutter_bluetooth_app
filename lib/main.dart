import 'package:ble_project/screens/signInScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

const _themeColor = Colors.blueGrey;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      title: 'Bluetooth application',
      color: _themeColor,
      theme: ThemeData(primarySwatch: _themeColor),
      home: const SignInScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}
