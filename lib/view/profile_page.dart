import 'package:flutter/material.dart';
import 'package:gadain/view/home_page.dart';
import 'package:gadain/widget/header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: TextButton(
        onPressed: () {
          authController.logout();
        },
        child: Text('Logout'),
      ),
    );
  }
}
