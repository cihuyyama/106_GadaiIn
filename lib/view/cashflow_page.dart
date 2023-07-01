import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widget/header.dart';
import 'home_page.dart';

final GoogleSignInAccount? gUser = googleSignIn.currentUser;
final CollectionReference user =
    FirebaseFirestore.instance.collection('gadai');

class CashFlowPage extends StatefulWidget {
  const CashFlowPage({Key? key}) : super(key: key);

  @override
  State<CashFlowPage> createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage> {
  late Future<QuerySnapshot<Map<String, dynamic>>> subUser;
  int lunasQty = 0;
  int belumQty = 0;

  Map<String, double> monthlyData = {};

  @override
  void initState() {
    super.initState();
    subUser = user
        .doc(gUser!.id)
        .collection('transac')
        .get()
        .then((snapshot) => snapshot);
    fetchMonthlyData();
  }

  Future<void> fetchMonthlyData() async {
    try {
      final snapshot = await subUser;
      setState(() {
        monthlyData = _getMonthlyData(snapshot);
      });
    } catch (error) {
      print('Error fetching monthly data: $error');
    }
  }

  Map<String, double> _getMonthlyData(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final monthlyData = <String, double>{
      'Lunas': 0.0,
      'Belum Lunas': 0.0,
    };

    snapshot.docs.forEach((doc) {
      final statusGadai = doc.get('statusGadai') as String;
      final jumlahGadai = doc.get('jumlahGadai') as double? ?? 0.0;

      if (statusGadai == 'Lunas') {
        monthlyData['Lunas'] = (monthlyData['Lunas'] ?? 0.0) + jumlahGadai;
        lunasQty += 1;
      } else {
        monthlyData['Belum Lunas'] = (monthlyData['Belum Lunas'] ?? 0.0) + jumlahGadai;
        belumQty += 1;
      }
    });

    return monthlyData;
  }

  Widget _buildCashflow() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: ListView.builder(
      itemCount: monthlyData.length,
      itemBuilder: (context, index) {
        final entry = monthlyData.entries.elementAt(index);
        final statusGadai = entry.key;
        final totalAmount = entry.value;

        return ListTile(
          title: Text(statusGadai),
          subtitle: Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
        );
      },
    ),
  );
}

  Widget _buildReport() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: ListView(
      children: [
        ListTile(
          title: Text('Lunas'),
          subtitle: Text('Total Data: $lunasQty'),
        ),
        ListTile(
          title: Text('Belum Lunas'),
          subtitle: Text('Total Data: $belumQty'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Cashflow & Report"),
      body: Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildCashflow(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildReport(),
          ),
        ),
      ],
    ),
    );
  }
}
