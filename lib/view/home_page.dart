import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
    if (account != null) {
      print("Account detected");
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
      print("Account detected");
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


  Future<void> login() async {
    await googleSignIn.signIn();
  }

  Future<void> logout() async {
    await googleSignIn.signOut();
  }

  Widget buildAuthScreen() {
    return TextButton(
      onPressed: logout,
      child: Text('Logout'),
    );
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
