import 'package:flutter/material.dart';
import 'package:gadain/widget/header.dart';
import 'package:gadain/widget/progress.dart';
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
    super.initState();
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
