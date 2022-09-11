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
        home: Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: Center(
          //email
// first login
// full name
// phone num""
          child: StreamBuilder(
        stream: usersInfo.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
              children: snapshot.data!.docs.map((user) {
            return Center(
                child: ListTile(
              title: Text(
                user["email"],
              ),
              subtitle: Text(user["full_name"]),
            ));
          }).toList());
        },
      )),
    ));
  }
}
