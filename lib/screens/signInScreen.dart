import 'package:ble_project/genericWidgets/genAlert.dart';
import 'package:ble_project/genericWidgets/genTextField.dart';
import 'package:ble_project/screens/forgotPassScreen.dart';
import 'package:ble_project/screens/scanScreen.dart';
import 'package:ble_project/screens/signUpScreen.dart';
import 'package:ble_project/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../genericWidgets/genBtn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("#2980B9"),
          hexStringToColor("#6DD5FA"),
          hexStringToColor("#FFFFFF")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, screenHeight * 0.05, 20, 0),
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
                  _emailTextController, null, true),
              const SizedBox(
                height: 10,
              ),
              genericTextField("Enter password", Icons.lock_outline, true,
                  _passTextController, () {
                FirebaseLogin(context);
              }),
              const SizedBox(
                height: 50,
              ),
              forgetPassword(context),
              genericButton(context, "Login", () {
                FirebaseLogin(context);
              }),
              signUpOptions(context)
            ],
          ),
        )),
      ),
    );
  }

  void FirebaseLogin(BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passTextController.text)
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ScanScreen()));
    }).onError((error, stackTrace) {
      genericAlertDialog(context, "Error", error.toString());
      print("Error ${error.toString()}");
    });
  }
}

Row signUpOptions(context) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Text("Don't have account?", style: TextStyle(color: Colors.black54)),
    GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()));
      },
      child: const Text(
        " Sign Up",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  ]);
}

Widget forgetPassword(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 35,
    alignment: Alignment.bottomRight,
    child: TextButton(
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.black38),
        textAlign: TextAlign.right,
      ),
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ForgotPassScreen())),
    ),
  );
}
