import 'package:flutter/material.dart';

AppBar header (context){
  return AppBar(
    title: Text(
      "GadaiIn",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Signatra",
        fontSize: 50.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.secondary,
  );
}