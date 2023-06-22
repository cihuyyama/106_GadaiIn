import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gadain/view/activity_page.dart';
import 'package:gadain/view/cashflow_page.dart';
import 'package:gadain/view/dashboard.dart';
import 'package:gadain/view/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

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
        print("Account detected : $account");
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
          print("Account detected : $account");
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
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Dashboard(),
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
