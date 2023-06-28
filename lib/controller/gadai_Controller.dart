import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadain/model/gadai.dart';
import 'package:gadain/view/add_gadai.dart';
import 'package:gadain/view/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

CollectionReference user = FirebaseFirestore.instance.collection('gadai');
final GoogleSignInAccount? gUser = googleSignIn.currentUser;

class GadaiController {
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
    DocumentReference documentReference = user
        .doc(gUser!.id)
        .collection('transac')
        .doc(); // Generate a new document reference

    // Set the document data including the ID
    await documentReference.set({
      'id': documentReference.id, // Store the document ID
      'namaPenggadai': namaPenggadai,
      'nik': nik,
      'namaBarang': namaBarang,
      'jumlahGadai': jumlahGadai,
      'statusGadai': statusGadai,
      'jatuhTempo': jatuhTempo,
      'bunga': bunga,
    }).then((value) {
      // Success
      print('Data saved to Firestore!');
      Navigator.pop(context);
    }).catchError((error) {
      // Error
      print('Failed to save data to Firestore: $error');
    });
  }

  delTransacdoc(id)async{
    DocumentReference docRef = user.doc(gUser!.id).collection('transac').doc(id);
    await docRef.delete();
  }
}
