// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class gadai {
  final String docId; // Add the document ID field
  final String namaPenggadai;
  final String namaBarang;
  final String nik;
  final double jumlahGadai;
  final Timestamp? jatuhTempo;
  final double bunga;
  final String statusGadai;

  gadai({
    required this.docId,
    required this.namaPenggadai,
    required this.namaBarang,
    required this.nik,
    required this.jumlahGadai,
    this.jatuhTempo,
    required this.bunga,
    required this.statusGadai
  });

  factory gadai.fromDocument(DocumentSnapshot doc){
    return gadai(
      docId: doc.id, // Retrieve the document ID
      namaPenggadai: doc['namaPenggadai'],
      nik: doc['nik'],
      namaBarang: doc['namaBarang'],
      jumlahGadai: doc['jumlahGadai'],
      jatuhTempo: doc['jatuhTempo'],
      bunga: doc['bunga'],
      statusGadai: doc['statusGadai']
    );
  }

  // Rest of the class...
}
