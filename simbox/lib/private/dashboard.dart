import 'package:flutter/material.dart';
import 'package:simbox/private/tabs/home.dart';
import 'package:simbox/private/tabs/profile.dart';
import 'package:simbox/private/tabs/security.dart';
import 'package:simbox/services/theme.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [HomeTab(), SecurityTab(), ProfileTab()],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.security),
            ),
            Tab(
              icon: Icon(Icons.perm_identity),
            )
          ],
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: primaryColor,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
