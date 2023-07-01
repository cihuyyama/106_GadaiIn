import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controller/gadai_Controller.dart';
import '../widget/header.dart';
import 'home_page.dart';

class UpdateGadai extends StatefulWidget {
  const UpdateGadai({
    Key? key,
    this.docId,
    this.namaPenggadai,
    this.nik,
    this.namaBarang,
    this.jumlahGadai,
    this.statusGadai,
    this.jatuhTempo,
    this.bunga,
  }) : super(key: key);

  @override
  State<UpdateGadai> createState() => _UpdateGadaiState();
  final String? docId;
  final String? namaPenggadai;
  final String? nik;
  final String? namaBarang;
  final double? jumlahGadai;
  final String? statusGadai;
  final DateTime? jatuhTempo;
  final double? bunga;
}

class _UpdateGadaiState extends State<UpdateGadai> {
  final GadaiController gadaiController = GadaiController();
  TextEditingController _namaPenggadaiController = TextEditingController();
  TextEditingController _nikController = TextEditingController();
  TextEditingController _namaBarangController = TextEditingController();
  TextEditingController _jumlahGadaiController = TextEditingController();
  TextEditingController _statusGadaiController = TextEditingController();
  final GoogleSignInAccount? user = googleSignIn.currentUser;
  DateTime? _selectedDate;
  double _bunga = 0.0;

  @override
  void initState() {
    super.initState();
    _namaPenggadaiController.text = widget.namaPenggadai ?? '';
    _nikController.text = widget.nik ?? '';
    _namaBarangController.text = widget.namaBarang ?? '';
    _jumlahGadaiController.text = widget.jumlahGadai?.toString() ?? '';
    _statusGadaiController.text = widget.statusGadai ?? '';
    _selectedDate = widget.jatuhTempo;
    _bunga = widget.bunga ?? 0.0;
  }

  updatedata() async {
    gadaiController.updateDataToFirestore(
      context,
      widget.docId!,
      await usersRef.doc(user?.id).get(),
      _namaPenggadaiController.text,
      _nikController.text,
      _namaBarangController.text,
      double.parse(_jumlahGadaiController.text.replaceAll(',', '')),
      _statusGadaiController.text,
      _selectedDate,
      _bunga,
    );

    _namaPenggadaiController.clear();
    _nikController.clear();
    _namaBarangController.clear();
    _jumlahGadaiController.clear();
    _statusGadaiController.clear();
    _selectedDate = null;
    _bunga = 0.0;
  }

  @override
  void dispose() {
    _namaPenggadaiController.dispose();
    _nikController.dispose();
    _namaBarangController.dispose();
    _jumlahGadaiController.dispose();
    _statusGadaiController.dispose();
    super.dispose();
  }

  void _calculateBunga(DateTime? selectedDate) {
    if (selectedDate != null) {
      DateTime today = DateTime.now();
      Duration difference = selectedDate.difference(today);
      int weeks = (difference.inDays / 7).ceil();

      if (weeks == 1) {
        _bunga = 5.0;
      } else if (weeks == 2) {
        _bunga = 10.0;
      } else if (weeks == 3) {
        _bunga = 15.0;
      } else if (weeks == 4) {
        _bunga = 20.0;
      } else {
        _bunga = 0.0;
      }
    } else {
      _bunga = 0.0;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 28)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calculateBunga(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Update Penggadaian"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _namaPenggadaiController,
                decoration: InputDecoration(labelText: 'Nama Penggadai'),
              ),
              TextField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK'),
              ),
              TextField(
                controller: _namaBarangController,
                decoration:
                    InputDecoration(labelText: 'Nama Barang yang Digadai'),
              ),
              TextField(
                controller: _jumlahGadaiController,
                decoration: InputDecoration(labelText: 'Jumlah Gadai'),
                keyboardType: TextInputType.number,
              ),
              // TextField(
              //   controller: _statusGadaiController,
              //   decoration: InputDecoration(labelText: 'Status Gadai'),
              // ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(right: 225),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10),
                  icon: const Icon(Icons.arrow_drop_down_circle_rounded),
                  value: _statusGadaiController.text,
                  items: [
                    DropdownMenuItem(
                      value: 'Lunas',
                      child: Text('Lunas'),
                    ),
                    DropdownMenuItem(
                      value: 'Belum Lunas',
                      child: Text('Belum Lunas'),
                    ),
                  ],
                  onChanged: (item) {
                    setState(() {
                      _statusGadaiController.text = item!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: _selectedDate?.toString() ?? ''),
                    decoration: InputDecoration(
                      labelText: 'Jatuh Tempo',
                      suffixIcon: Icon(Icons.event),
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: TextEditingController(text: _bunga.toString()),
                decoration: InputDecoration(labelText: 'Bunga (%)'),
                readOnly: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Bunga'),
                        content: Text('Bunga Rate: $_bunga%'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  // backgroundColor: Colors.teal.shade100
                ),
                onPressed: updatedata,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
