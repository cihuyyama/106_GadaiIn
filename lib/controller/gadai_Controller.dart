import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadain/model/gadai.dart';
import 'package:gadain/view/add_gadai.dart';
import 'package:gadain/view/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

CollectionReference user = FirebaseFirestore.instance.collection('gadai');
final GoogleSignInAccount? gUser = googleSignIn.currentUser;
final DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(currentUser!.id);

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

    final DocumentSnapshot userDoc = await usersRef.doc(gUser!.id).get();
    final double currentBalance = userDoc.get('balance') ?? 0.0;

    if (statusGadai == 'Belum Lunas') {
      usersRef.doc(gUser!.id).update({
        'balance': currentBalance - jumlahGadai,
      });
    } else if (statusGadai == 'Lunas') {
      usersRef.doc(gUser!.id).update({
        'balance': currentBalance + jumlahGadai,
      });
    }
  }

  updateDataToFirestore(
      context,
      String id,
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
        .doc(id); // Get the document reference using the document ID

    // Update the document data
    await documentReference.update({
      'namaPenggadai': namaPenggadai,
      'nik': nik,
      'namaBarang': namaBarang,
      'jumlahGadai': jumlahGadai,
      'statusGadai': statusGadai,
      'jatuhTempo': jatuhTempo,
      'bunga': bunga,
    }).then((value) {
      // Success
      print('Data updated in Firestore!');
      Navigator.pop(context);
    }).catchError((error) {
      // Error
      print(doc.id);
      print('Failed to update data in Firestore: $error');
    });

    final DocumentSnapshot userDoc = await usersRef.doc(gUser!.id).get();
    final double currentBalance = userDoc.get('balance') ?? 0.0;

    if (statusGadai == 'Belum Lunas') {
      usersRef.doc(gUser!.id).update({
        'balance': currentBalance - jumlahGadai,
      });
    } else if (statusGadai == 'Lunas') {
      usersRef.doc(gUser!.id).update({
        'balance': currentBalance + jumlahGadai + (jumlahGadai*(bunga/100.0)),
      });
    }
  }

  delTransacdoc(id) async {
    DocumentReference docRef =
        user.doc(gUser!.id).collection('transac').doc(id);
    final DocumentSnapshot transacDoc = await docRef.get();
    final String statusGadai = transacDoc.get('statusGadai') as String;
    final double jumlahGadai = transacDoc.get('jumlahGadai') as double? ?? 0.0;
    await docRef.delete();

    final DocumentSnapshot userDoc = await usersRef.doc(gUser!.id).get();
    final double currentBalance = userDoc.get('balance') ?? 0.0;


    if (statusGadai == 'Belum Lunas') {
      usersRef.doc(gUser!.id).update({
        'balance': currentBalance + jumlahGadai,
      });
    } else if (statusGadai == 'Lunas') {
      usersRef.doc(gUser!.id).update({
        'balance': currentBalance - jumlahGadai,
      });
    }
  }
}
