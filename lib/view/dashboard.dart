import 'package:flutter/material.dart';
import 'package:gadain/widget/header.dart';
import 'package:gadain/widget/progress.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> users = [];

  @override
  void initState() {
    getUsers();
    updateUser();
    // createUser();
    super.initState();
    // getUsersbyid();
  }

  void createUser() async {
    await usersRef
        .doc("hjsdfhj")
        .set({"username": "muhammad", "isAdmin": false});
  }

  void updateUser(){
    usersRef.doc("hjsdfhj").update({"username": "ahmed", "isAdmin": false});
  }

  getUsersbyid() async {
    final String id = "TiLqIxhG8VJ9jJcIeUtg";
    final DocumentSnapshot doc = await usersRef.doc(id).get();
    print(doc.data());
    print(doc.id);
  }

  getUsers() async {
    final QuerySnapshot snapshot = await usersRef.get();
    users = snapshot.docs;
    // snapshot.docs.forEach((DocumentSnapshot doc) {
    //   print(doc.data());
    //   print(doc.id);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, isApptitle: true, titleText: "Dashboard"),
        body: StreamBuilder<QuerySnapshot>(
          stream: usersRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgress();
            }
            final List<Text> children = snapshot.data!.docs
                .map((doc) => Text(doc['username']))
                .toList();
            return Container(
              child: ListView(
                children: children,
              ),
            );
          },
        ));
  }
}
