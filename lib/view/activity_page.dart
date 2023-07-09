import 'package:cloud_firestore/cloud_firestore.dart';
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
  final usersRef = FirebaseFirestore.instance.collection('users');
  TextEditingController searchController = TextEditingController();

  Future<QuerySnapshot>? searchResultFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("username", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultFuture = users;
    });
  }

  clearSearch() {
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

  viewData() {
    return StreamBuilder<QuerySnapshot>(
      stream: usersRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildNoContent();
        }
        List<Result> searchResult = [];
        snapshot.data?.docs.forEach((doc) {
          usermod.User user = usermod.User.fromDocument(doc);
          Result result = Result(user);
          searchResult.add(result);
        });
        return ListView(children: searchResult);
      },
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
          return ListView(children: searchResult);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.withOpacity(0.7),
      appBar: buildSearchfiled(),
      body: searchResultFuture == null ? viewData() : buildSearchResult(),
    );
  }
}

class Result extends StatelessWidget {
  final usermod.User user;
  Result(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: 150.0,
      height: MediaQuery.of(context).size.height * 0.18,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 10, right: 10),
            padding:
                EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 15),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withOpacity(0.15),
                  offset: Offset(5.0, 4.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 30,
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            user.displayName,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        // height: 30,
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              user.displayName,
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
