import 'package:ble_project/genericWidgets/genAlert.dart';
import 'package:ble_project/genericWidgets/genTextField.dart';
import 'package:ble_project/screens/forgotPassScreen.dart';
import 'package:ble_project/screens/signUpScreen.dart';
import 'package:ble_project/utils/AuthService.dart';
import 'package:ble_project/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final authService = Provider.of<AuthService>(context);
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
                FirebaseLogin(authService, _emailTextController,
                    _passTextController, context); //on done callback
              }),
              const SizedBox(
                height: 70,
              ),
              forgetPassword(context),
              const SizedBox(
                height: 15,
              ),
              genericButton(context, "Login", () {
                FirebaseLogin(authService, _emailTextController,
                    _passTextController, context);
              }),
              signUpOptions(context)
            ],
          ),
        )),
      ),
    );
  }

  void FirebaseLogin(
      AuthService authService,
      TextEditingController _emailTextController,
      TextEditingController _passTextController,
      BuildContext context) async {
    await authService
        .signIn(_emailTextController.text, _passTextController.text)
        .catchError((error, stackTrace) {
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
    alignment: Alignment.bottomLeft,
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
