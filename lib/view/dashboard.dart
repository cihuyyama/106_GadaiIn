import 'package:flutter/material.dart';
import 'package:gadain/widget/header.dart';
import 'package:gadain/widget/progress.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isApptitle: true, titleText: "Dashboard"),
      body: CircularProgress(),
    );
  }
}