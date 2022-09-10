import 'package:ble_project/screens/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../genericWidgets/genAlert.dart';
import '../genericWidgets/genBtn.dart';
import '../genericWidgets/genTextField.dart';
import '../utils/colors.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("#2980B9"),
          hexStringToColor("#6DD5FA"),
          hexStringToColor("#FFFFFF")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage('assets/images/blueimage.png'),
                width: 250,
                height: 250,
              ),
              const SizedBox(
                height: 15,
              ),
              genericTextField("Enter Email", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 50,
              ),
              genericButton(context, "Reset Password", () {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _emailTextController.text)
                    .then((value) {
                  genericAlertDialog(context, "Email sent!",
                      "Check your email to reset the password!");
                }).catchError((error, stackTrace) {
                  genericAlertDialog(context, "Error", error.toString());
                  print("Error ${error.toString()}");
                });
              }),
            ],
          ),
        )),
      ),
    );
  }
}
