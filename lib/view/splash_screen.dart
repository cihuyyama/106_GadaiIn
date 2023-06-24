import 'package:flutter/material.dart';
import 'package:gadain/widget/progress.dart';

Scaffold SplashScreen(){
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
                Image.asset(
                  "assets/images/pawnshop.jpg",
                  width: 300.0,
                  height: 200.0,
                ),
                CircularProgress(),
              ],
            ),
          ),
        ],
      ),
    );
}