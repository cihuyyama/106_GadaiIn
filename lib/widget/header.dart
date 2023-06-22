import 'package:flutter/material.dart';

AppBar header (context, {bool isApptitle = false, required String titleText}){
  return AppBar(
    title: Text(
      isApptitle ? "GadaiIn" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isApptitle ? "Signatra" : "",
        fontSize: isApptitle ? 50.0 : 25.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.secondary,
  );
}