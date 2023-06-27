import 'dart:async';
import 'package:gadain/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:gadain/widget/header.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({super.key});

  final formkey = GlobalKey<FormState>();

  final scaffoldkey = GlobalKey<ScaffoldMessengerState>();

  String? username;

  submit(BuildContext context) {
  final form = formkey.currentState;
  final scaffold = scaffoldkey.currentState;

  if (form != null && scaffold != null) {
    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text("Welcome $username"));
      scaffold.showSnackBar(snackBar);
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.of(context).pop(username);
        },
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,
          titleText: "Set up your Username", removeBackbutton: true),
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
                  onTap: submit(context),
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
