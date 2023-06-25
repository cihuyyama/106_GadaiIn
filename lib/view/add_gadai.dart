import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AddGadai extends StatefulWidget {
  const AddGadai({super.key});

  @override
  State<AddGadai> createState() => _AddGadaiState();
}

class _AddGadaiState extends State<AddGadai> {
  TextEditingController _namaPenggadaiController = TextEditingController();
  TextEditingController _nikController = TextEditingController();
  TextEditingController _namaBarangController = TextEditingController();
  TextEditingController _jumlahGadaiController = TextEditingController();
  TextEditingController _statusGadaiController = TextEditingController();
  DateTime? _selectedDate;
  double _bunga = 0.0;

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
      initialDate: DateTime.now(),
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
      appBar: AppBar(
        title: Text('Add Data Penggadaian'),
      ),
      body: Padding(
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
              decoration: InputDecoration(labelText: 'Nama Barang yang Digadai'),
            ),
            TextField(
              controller: _jumlahGadaiController,
              decoration: InputDecoration(labelText: 'Jumlah Gadai'),
            ),
            TextField(
              controller: _statusGadaiController,
              decoration: InputDecoration(labelText: 'Status Gadai'),
            ),
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
            TextField(
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
              onPressed: () {
                // Perform data submission logic here
                String namaPenggadai = _namaPenggadaiController.text;
                String nik = _nikController.text;
                String namaBarang = _namaBarangController.text;
                String jumlahGadai = _jumlahGadaiController.text;
                String statusGadai = _statusGadaiController.text;
                DateTime? jatuhTempo = _selectedDate;
                String bunga = _bunga.toString();

                // Perform further actions with the retrieved data

                // Clear the text fields
                _namaPenggadaiController.clear();
                _nikController.clear();
                _namaBarangController.clear();
                _jumlahGadaiController.clear();
                _statusGadaiController.clear();
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
