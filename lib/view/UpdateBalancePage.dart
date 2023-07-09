import 'package:flutter/material.dart';

import 'home_page.dart';

class UpdateBalancePage extends StatefulWidget {
  const UpdateBalancePage({Key? key}) : super(key: key);

  @override
  _UpdateBalancePageState createState() => _UpdateBalancePageState();
}

class _UpdateBalancePageState extends State<UpdateBalancePage> {
  final TextEditingController _balanceController = TextEditingController();

  void _updateBalance() {
    final double newBalance = double.tryParse(_balanceController.text) ?? 0.0;
    usersRef.doc(currentUser!.id).update({'balance': newBalance});
    Navigator.pop(context); // Go back to the previous page after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Balance"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "New Balance",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _updateBalance,
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }
}
