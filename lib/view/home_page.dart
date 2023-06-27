import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gadain/model/user.dart' as usermod;
import 'package:gadain/view/login_page.dart';
import 'package:gadain/controller/auth_Controller.dart';
import 'package:gadain/view/splash_screen.dart';
import 'package:gadain/widget/bottomnavbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gadain/view/create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final usersRef = FirebaseFirestore.instance.collection('users');
final AuthController authController = AuthController();
final timestamp = DateTime.now();
usermod.User? currentUser;
Bottomnavbar bottomnavbar = Bottomnavbar();

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
        authController.createUserInFirestore(context);
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    }, onError: (error) {
      print('Error occurred during current user check: $error');
    });
    googleSignIn.signInSilently(suppressErrors: false).then(
      (account) {
        if (account != null) {
          authController.createUserInFirestore(context);
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

  
  
  Bottomnavbar buildAuthScreen() {
    return bottomnavbar;
  }

  Scaffold buildUnAuthScreen() {
    return LoginPage();
  }

  Scaffold loadingscreen(){
    return SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
