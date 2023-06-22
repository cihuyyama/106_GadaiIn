import 'package:flutter/material.dart';
import 'package:gadain/view/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          googleSignIn.signOut();
        },
        child: Text('Logout'));
  }
}
