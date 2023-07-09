import 'package:flutter/material.dart';
import 'package:gadain/widget/header.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';


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
      appBar: header(context, titleText: "Profile", logout: true),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(currentUser!.photoUrl)
            ),
            SizedBox(height: 10,),
            Text(
              'Nama : ' + currentUser!.displayName,
            ),
            SizedBox(height: 10,),
            Text(
              'Email : ' + currentUser!.email,
            ),
          ],
        ),
      ),
    );
  }
}
