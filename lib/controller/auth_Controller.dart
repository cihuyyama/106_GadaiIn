import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadain/view/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gadain/model/user.dart' as usermod;

import '../view/create_account.dart';


class AuthController{


  void createUserInFirestore(context) async {
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

  login() async {
    await googleSignIn.signIn();
  }

  logout() async {
    await googleSignIn.signOut();
  }
}