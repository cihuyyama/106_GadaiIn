import 'package:flutter/material.dart';
import 'package:gadain/controller/auth_Controller.dart';

Scaffold LoginPage() {
  final AuthController authController = AuthController();

  return Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.deepPurple,
                Colors.teal,
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
                onTap: authController.login,
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
