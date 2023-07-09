import 'package:flutter/material.dart';
import 'package:gadain/controller/auth_Controller.dart';

final AuthController authController = AuthController();

Widget logoutButton(){
  return TextButton(
    onPressed: () {
      authController.logout();
    },
    child: Text(
      'logout',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

AppBar header(context,
    {bool isApptitle = false,
    required String titleText,
    removeBackbutton = false,
    logout = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackbutton ? false : true,
    title: Text(
      isApptitle ? "GadaiIn" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isApptitle ? "Signatra" : "",
        fontSize: isApptitle ? 50.0 : 25.0,
      ),
    ),
    actions: [
      logout ? logoutButton() : TextButton(onPressed: () {
      }, child: Text(''))
    ],
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.secondary,
  );
}
