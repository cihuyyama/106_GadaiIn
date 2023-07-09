import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gadain/view/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gadain/model/user.dart' as usermod;

import '../view/create_account.dart';


class AuthController {
  void createUserInFirestore(context) async {
    //check if exist
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user?.id).get();

    if (!doc.exists) {
      final balance = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAccount(),
          ));
      usersRef.doc(user!.id).set({
        "id": user.id,
        "balance": balance,
        "email": user.email,
        "displayName": user.displayName,
        "timestamp": timestamp,
        "photoUrl": user.photoUrl
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = usermod.User.fromDocument(doc);
    print(currentUser);
  }


  login() async {
    //with credential
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);

    //basic signin flow
    // await googleSignIn.signIn();
  }

  logout() async {
    // Get the current user
    final GoogleSignInAccount? currentUser = await googleSignIn.currentUser;

    if (currentUser != null) {
      // Get the authentication token
      final GoogleSignInAuthentication googleAuth = await currentUser.authentication;

      // Create a Google credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign out of Firebase using the credential
      await firebaseAuth.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();

      print('User logged out successfully.');
    } else {
      print('No user is currently signed in.');
    }

    //basi signout flow
    await googleSignIn.signOut();
  }

  void dispose() {
    googleSignIn.disconnect();
  }

  deleteUser(id)async{
    final user = FirebaseFirestore.instance.collection('users');
    await user.doc(id).delete();
  }
}
