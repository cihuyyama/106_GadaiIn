import 'package:cached_network_image/cached_network_image.dart';
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
  TextEditingController searchController = TextEditingController();

  Future<QuerySnapshot>? searchResultFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("username", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultFuture = users;
    });
  }

  clearSearch(){
    searchController.clear();
  }

  AppBar buildSearchfiled() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: "Search",
            filled: true,
            prefixIcon: const Icon(
              Icons.search,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
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
          List<Result> searchResult = [];
          snapshot.data?.docs.forEach((doc) {
            usermod.User user = usermod.User.fromDocument(doc);
            Result result = Result(user);
            searchResult.add(result);
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
  final usermod.User user;
  Result(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.withOpacity(0.5),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => print('tapped'),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[400],
                backgroundImage: AssetImage("assets/images/transac.png"),
              ),
              title: Text(user.displayName, style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
              subtitle: Text(user.username, style: TextStyle(
                color: Colors.white
              ),),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
