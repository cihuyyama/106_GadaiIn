import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadain/view/add_gadai.dart';

class GadaiController {
  // saveDataToFirestore() {
  //   String namaPenggadai = _namaPenggadaiController.text;
  //   String nik = _nikController.text;
  //   String namaBarang = _namaBarangController.text;
  //   double jumlahGadai =
  //       double.parse(_jumlahGadaiController.text.replaceAll(',', ''));
  //   String statusGadai = _statusGadaiController.text;
  //   DateTime? jatuhTempo = _selectedDate;
  //   double bunga = _bunga;

  //   FirebaseFirestore.instance.collection('gadai').add({
  //     'namaPenggadai': namaPenggadai,
  //     'nik': nik,
  //     'namaBarang': namaBarang,
  //     'jumlahGadai': jumlahGadai,
  //     'statusGadai': statusGadai,
  //     'jatuhTempo': jatuhTempo,
  //     'bunga': bunga,
  //   }).then((value) {
  //     // Success
  //     print('Data saved to Firestore!');
  //     // Clear the text fields
  //     _namaPenggadaiController.clear();
  //     _nikController.clear();
  //     _namaBarangController.clear();
  //     _jumlahGadaiController.clear();
  //     _statusGadaiController.clear();
  //     _selectedDate = null;
  //     _bunga = 0.0;
  //   }).catchError((error) {
  //     // Error
  //     print('Failed to save data to Firestore: $error');
  //   });
  // }
}
