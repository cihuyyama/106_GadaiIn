import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/auth_Controller.dart';
import '../view/activity_page.dart';
import '../view/cashflow_page.dart';
import '../view/dashboard.dart';
import '../view/profile_page.dart';

final AuthController authController = AuthController();
PageController pageController = PageController(initialPage: 0);

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int pageIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Dashboard(),
          // TextButton(onPressed: authController.logout, child: Text('Logout')),
          // ActivityPage(),
          CashFlowPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: (index) {
          onPageChanged(index);
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard)),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded)),
          // BottomNavigationBarItem(icon: Icon(Icons.monitor_heart_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded)),
        ],
      ),
    );
  }
}
