import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gadain/view/add_gadai.dart';
import 'package:gadain/widget/header.dart';
import 'package:gadain/widget/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadain/model/user.dart' as usermod;
import 'package:intl/intl.dart';


final usersRef = FirebaseFirestore.instance.collection('users');
DateTime now = DateTime.now();

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
                    ));
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
  String formattedDate = DateFormat.yMMMEd().format(now);
  final usermod.User user;
  Result(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onLongPress: () {
          // Navigator.push(
          //   // context,
          //   // MaterialPageRoute(
          //   //   builder: (context) => DetailDataTbc(
          //   //       tbcid: datatbc[index]['tbcid'],
          //   //       hari: datatbc[index]['hari'],
          //   //       datetime: datatbc[index]['datetime'],
          //   //       bb: datatbc[index]['beratbadan'],
          //   //       keluhan: datatbc[index]['keluhan'],
          //   //       tindakan: datatbc[index]['tindakan']),
          //   // ),
          // );
        },
        child: Card(
          elevation: 10,
          child: ListTile(
            title: Text(user.displayName),
            leading: Text(formattedDate),
            subtitle: Text(user.username),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                
                // tbcctrl.removeTbc(datatbc[index]['tbcid'].toString());
                // setState(() {
                //   tbcctrl.getTbc();
                // });

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact Deleted')));
              },
            ),
          ),
        ),
      ),
    );
  }
}
