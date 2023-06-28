import 'package:flutter/material.dart';
import 'package:gadain/view/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final DateTime timestamp = DateTime.now();

class UserGenerator extends StatefulWidget {
  const UserGenerator({super.key});

  @override
  State<UserGenerator> createState() => _UserGeneratorState();
}

class _UserGeneratorState extends State<UserGenerator> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    createUser();
    super.initState();
  }

  createUser() async {
    await usersRef.doc("hnvfdhjkfdshj").set({
      "username": "coba",
      "displayName": "Ahmed mubarok",
      "email": "miqbalalhabib@gmail.com",
      "bio": "",
      "id": "ndfjfdjkh",
      "photoUrl": "https://lh3.googleusercontent.com/a/AAcHTtfcpNtGjK-LkuoJTnyE5zLBd81lF6vP7DozVlIVmA=s96-c",
      "timestamp": timestamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
