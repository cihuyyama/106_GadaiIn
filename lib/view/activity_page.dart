import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gadain/view/dashboard.dart';
import 'package:gadain/widget/progress.dart';
import 'package:gadain/model/user.dart' as usermod;

import '../widget/header.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Future<QuerySnapshot>? searchResultFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("username", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultFuture = users;
    });
  }

  AppBar buildSearchfiled() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        decoration: InputDecoration(
            hintText: "Search",
            filled: true,
            prefixIcon: const Icon(
              Icons.search,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => print('cleared'),
            )),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/not_found.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text(
              "not found",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResult() {
    return FutureBuilder(
        future: searchResultFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgress();
          }
          List<Text> searchResult = [];
          snapshot.data?.docs.forEach((doc) {
            usermod.User user = usermod.User.fromDocument(doc);
            searchResult.add(Text(user.username));
          });
          return ListView(
            children: searchResult
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.withOpacity(0.7),
      appBar: buildSearchfiled(),
      body: searchResultFuture == null ? buildNoContent() : buildSearchResult(),
    );
  }
}

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
