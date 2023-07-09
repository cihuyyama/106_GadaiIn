import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadain/view/UpdateBalancePage.dart';
import 'package:gadain/widget/header.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream() {
    return usersRef.doc(currentUser!.id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    void _navigateToUpdateBalancePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateBalancePage(),
      ),
    );
  }

    return Scaffold(
      appBar: header(context, titleText: "Profile", logout: true),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getUserStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final userDoc = snapshot.data!.data();
            final balance = userDoc?['balance'] ?? 0.0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(currentUser!.photoUrl),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Nama : ' + currentUser!.displayName,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Email : ' + currentUser!.email,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Balance : ' + balance.toString(),
                ),
                ElevatedButton(
                  onPressed: _navigateToUpdateBalancePage,
                  child: Text("Update Balance"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
