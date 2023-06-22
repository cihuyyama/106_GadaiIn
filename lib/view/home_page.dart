import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gadain/model/user.dart' as usermod;
import 'package:gadain/view/activity_page.dart';
import 'package:gadain/view/cashflow_page.dart';
import 'package:gadain/view/create_account.dart';
import 'package:gadain/view/dashboard.dart';
import 'package:gadain/view/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gadain/controller/auth_Controller.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
final AuthController authController = AuthController();
final timestamp = DateTime.now();
usermod.User? currentUser;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAuth = false;
  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        createUserInFirestore();
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    }, onError: (error) {
      // Handle the error here
      print('Error occurred during current user check: $error');
    });
    googleSignIn.signInSilently(suppressErrors: false).then(
      (account) {
        if (account != null) {
          createUserInFirestore();
          setState(() {
            isAuth = true;
          });
        } else {
          setState(() {
            isAuth = false;
          });
        }
      },
    ).catchError((r) {
      print(r);
    });
  }

  createUserInFirestore() async {
    //check if exist
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user?.id).get();

    if (!doc.exists) {
      final username = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAccount(),
          ));
      usersRef.doc(user!.id).set({
        "id": user.id,
        "username": username,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = usermod.User.fromDocument(doc);
    print(currentUser);
    print(currentUser?.username);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    await googleSignIn.signIn();
  }

  Future<void> logout() async {
    await googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  void onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          // Dashboard(),
          TextButton(onPressed: logout, child: Text('Logout')),
          ActivityPage(),
          CashFlowPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard)),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded)),
        ],
      ),
    );
    // return TextButton(
    //   onPressed: logout,
    //   child: Text('Logout'),
    // );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            alignment: Alignment.center,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Gadain',
                  style: TextStyle(
                    fontFamily: "Signatra",
                    fontSize: 90,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: login,
                  child: Container(
                    width: 260.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/btn_google_signin_dark_normal_web.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
