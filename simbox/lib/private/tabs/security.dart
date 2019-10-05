import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simbox/services/theme.dart';

class SecurityTab extends StatefulWidget {
  const SecurityTab({
    Key key,
  }) : super(key: key);

  @override
  _SecurityTabState createState() => _SecurityTabState();
}

class _SecurityTabState extends State<SecurityTab> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Stack(children: <Widget>[
      Container(
        padding: EdgeInsets.all(40),
        constraints: BoxConstraints.expand(height: height * 0.7),
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [primaryColor, Colors.blueAccent],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
            stops: [0.2, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
    ]);
  }
}
