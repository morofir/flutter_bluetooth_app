import 'package:ble_project/genericWidgets/genAlert.dart';
import 'package:ble_project/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../genericWidgets/genBtn.dart';
import '../genericWidgets/genTextField.dart';
import '../utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passTextController = TextEditingController();
  TextEditingController _fullNameTextController = TextEditingController();
  TextEditingController _PhoneTextController = TextEditingController();
  // By defaut, the checkbox is unchecked and "agree" is "false"
  bool agree = false;

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
          hexStringToColor("2980B9"),
          hexStringToColor("6DD5FA"),
          hexStringToColor("FFFFFF")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, screenHeight * 0.05, 20, 0),
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage('assets/images/blueimage.png'),
                width: 250,
                height: 200,
              ),
              genericTextField("Enter Email", Icons.person_outline, false,
                  _emailTextController, null, true),
              const SizedBox(
                height: 30,
              ),
              genericTextField("Enter password", Icons.lock_outline, true,
                  _passTextController, null, true),
              const SizedBox(
                height: 15,
              ),
              genericTextField("Enter Full Name", Icons.person, false,
                  _fullNameTextController, null, true),
              const SizedBox(
                height: 15,
              ),
              genericTextField("Enter Phone Number", Icons.phone, false,
                  _PhoneTextController, null, true),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'I have read and accept ',
                          style: new TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'terms and conditions ',
                          style: new TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://github.com/morofir');
                            },
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Checkbox(
                      checkColor: Colors.black, // color of tick Mark
                      activeColor: Colors.white,
                      shape: const CircleBorder(),
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = value ?? false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              genericButton(context, "Login", () {
                agree
                    ? FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passTextController.text)
                        .then((value) {
                        print("create new account: ${value}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }).onError((error, stackTrace) {
                        genericAlertDialog(context, "Error", error.toString());
                        print("Error ${error.toString()}");
                      })
                    : genericAlertDialog(context, "Terms & Conditions",
                        "Must agree Terms and conditions.");
              }),
            ],
          ),
        )),
      ),
    );
  }
}
