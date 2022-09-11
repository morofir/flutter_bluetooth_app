import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference usersInfo =
        FirebaseFirestore.instance.collection('usersInfo');

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              title: const Text('Users Contact Page'),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    Navigator.pop(context);
                  })),
          body: Center(
              child: StreamBuilder(
            stream: usersInfo.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                    children: snapshot.data!.docs.map((user) {
                  return Center(
                      child: ExpansionTile(
                    tilePadding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                    leading: const Icon(Icons.phone_bluetooth_speaker_outlined),
                    title: Text(
                      "User: ${user["full_name"]}",
                      style: const TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    children: [
                      Text(
                        "Phone Num: ${user["phone"]}",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Email: ${user["email"]}",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ));
                }).toList());
              } else {
                return const Text('Loading...');
              }
            },
          )),
        ));
  }
}
