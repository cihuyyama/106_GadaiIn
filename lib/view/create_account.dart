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
  String? username;

  void submit() {
    final form = formkey.currentState;

    if (form!.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text("Welcome $username"));
      scaffoldkey.currentState?.showSnackBar(snackBar);
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.pop(context, username);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Set up your Username", removeBackbutton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Create Username",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: formkey,
                      // autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.trim().length < 3 || value.isEmpty) {
                            return "Username too short";
                          } else if (value.trim().length > 12) {
                            return "Username too long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "min 3 character"),
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
