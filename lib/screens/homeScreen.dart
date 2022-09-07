import 'package:ble_project/screens/bleStatusScreen.dart';
import 'package:ble_project/screens/deviceList.dart';
import 'package:ble_project/screens/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(children: [
      Container(
        height: screenHeight * 0.88,
        width: screenWidth,
        child: Consumer<BleStatus?>(
          builder: (_, status, __) {
            if (status == BleStatus.ready) {
              return const DeviceListScreen();
            } else {
              return BleStatusScreen(status: status ?? BleStatus.unknown);
            }
          },
        ),
      ),
      Container(
          height: screenHeight * 0.1,
          child: Center(
              child: ElevatedButton(
            child: const Text("Logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then(((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ));
                print("Signing out");
              }));
            },
          )))
    ]));
  }
}
