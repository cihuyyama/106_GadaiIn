import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadain/view/add_gadai.dart';
import 'package:gadain/view/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GadaiController {
  CollectionReference user = FirebaseFirestore.instance.collection('gadai');
  final GoogleSignInAccount? gUser = googleSignIn.currentUser;
  addDataToFirestore(
      context,
      DocumentSnapshot doc,
      String namaPenggadai,
      String nik,
      String namaBarang,
      double jumlahGadai,
      String statusGadai,
      DateTime? jatuhTempo,
      double bunga) async {
    user.doc(gUser!.id).set({'id': gUser!.id}).then((value) {
      // Success
      print('Data saved to Firestore!');
      Navigator.pop(context);
    }).catchError((error) {
      // Error
      print('Failed to save data to Firestore: $error');
    });

    addSubCollection(doc, namaPenggadai, nik, namaBarang, jumlahGadai,
        statusGadai, jatuhTempo, bunga);
  }

  addSubCollection(
      DocumentSnapshot doc,
      String namaPenggadai,
      String nik,
      String namaBarang,
      double jumlahGadai,
      String statusGadai,
      DateTime? jatuhTempo,
      double bunga) {
    CollectionReference user = FirebaseFirestore.instance.collection('gadai');
    user.doc(gUser!.id).collection('transac').add({
      'namaPenggadai': namaPenggadai,
      'nik': nik,
      'namaBarang': namaBarang,
      'jumlahGadai': jumlahGadai,
      'statusGadai': statusGadai,
      'jatuhTempo': jatuhTempo,
      'bunga': bunga,
    });
  }
}
