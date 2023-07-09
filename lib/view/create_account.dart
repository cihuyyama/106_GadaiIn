import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gadain/widget/header.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final scaffoldkey = GlobalKey<ScaffoldMessengerState>();
  final formkey = GlobalKey<FormState>();
  double? balance;

  void submit() {
    final form = formkey.currentState;

    if (form!.validate()) {
      form.save();
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.pop(context, balance);
        },
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,
          titleText: "Set up your Balance", removeBackbutton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: formkey,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a balance';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid balance value';
                          }
                          return null;
                        },
                        onSaved: (val) => balance = double.parse(val!),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Balance",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Add balance first",
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Center(
                        child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
