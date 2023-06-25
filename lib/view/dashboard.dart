import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gadain/view/add_gadai.dart';
import 'package:gadain/widget/header.dart';
import 'package:gadain/widget/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadain/model/user.dart' as usermod;

final usersRef = FirebaseFirestore.instance.collection('users');

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      backgroundColor: Colors.teal.withOpacity(0.7),
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
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
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
                  (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    );
                  },
                ),
              ),
              child: Text(
                "Add Gadai",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddGadai(),
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  buildSearchResult() {
    return FutureBuilder(
        future: searchResultFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            buildNoContent();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildSearchfiled(),
        body: searchResultFuture == null ? viewData() : buildSearchResult());
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
                              user.username,
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
    // return Container(
    //   color: Colors.teal.withOpacity(0.5),
    //   child: Column(
    //     children: <Widget>[
    //       GestureDetector(
    //         onTap: () => print('tapped'),
    //         child: ListTile(
    //           leading: CircleAvatar(
    //             backgroundColor: Colors.grey[400],
    //             backgroundImage: AssetImage("assets/images/transac.png"),
    //           ),
    //           title: Text(
    //             user.displayName,
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           subtitle: Text(
    //             user.username,
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       ),
    //       Divider(
    //         height: 2.0,
    //         color: Colors.white,
    //       ),
    //     ],
    //   ),
    // );
  }
}
