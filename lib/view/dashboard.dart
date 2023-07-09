import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gadain/model/gadai.dart';
import 'package:gadain/view/add_gadai.dart';
import 'package:gadain/view/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadain/view/update_gadai.dart';
import 'package:intl/intl.dart';

import '../controller/gadai_Controller.dart';

DateTime now = DateTime.now();

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final transac = FirebaseFirestore.instance
      .collection('gadai')
      .doc(googleSignIn.currentUser!.id)
      .collection("transac");
  TextEditingController searchController = TextEditingController();

  Future<QuerySnapshot>? searchResultFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        transac
        .where("namaPenggadai", isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      
    });
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
            stream: transac.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return buildNoContent();
              }
              List<Result> searchResult = [];
              snapshot.data?.docs.forEach((doc) {
                gadai user = gadai.fromDocument(doc);
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
            gadai user = gadai.fromDocument(doc);
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
  final formKey = GlobalKey<FormState>();
  String formattedDate = DateFormat.yMMMEd().format(now);
  final gadai user;
  Result(this.user);

  @override
  Widget build(BuildContext context) {
    final GadaiController gadaiController = GadaiController();
    String penggadai = user.namaPenggadai;
    String barang = user.namaBarang;
    var tempo = DateFormat.yMMMEd().format(user.jatuhTempo!.toDate());
    String status = user.statusGadai;

    Text istatus(){
      if (status =="Lunas") {
        return Text(
          "Lunas",
          style: TextStyle(
            color: Colors.green.shade600
          ),
        );
      } else {
        return Text(
          "Belum\nLunas",
          style: TextStyle(
            color: Colors.red
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Text("Nama : $penggadai \nBarang : $barang"),
            leading: istatus(),
            subtitle: Text("Tempo : $tempo"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    print(user.docId);
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateGadai(
                        docId: user.docId,
                        namaPenggadai: user.namaPenggadai,
                        nik: user.nik,
                        bunga: user.bunga,
                        jatuhTempo: user.jatuhTempo!.toDate(),
                        jumlahGadai: user.jumlahGadai,
                        namaBarang: user.namaBarang,
                        statusGadai: user.statusGadai,
                      ),
                    ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    gadaiController.delTransacdoc(user.docId);
    
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('data Deleted')));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
