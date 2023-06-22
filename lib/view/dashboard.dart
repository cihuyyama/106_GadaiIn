import 'package:flutter/material.dart';
import 'package:gadain/widget/header.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: Text('Dashboard'),
    );
  }
}