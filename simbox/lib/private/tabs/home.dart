import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simbox/models/mail.dart';
import 'package:simbox/services/auth_service.dart';
import 'package:simbox/services/theme.dart';
import 'package:simbox/widgets/provider_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key key,
  }) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _doorStatus;
  String _itemStatus;
  DatabaseReference _doorRef;
  DatabaseReference _itemRef;
  StreamSubscription<Event> _doorSubscription;
  StreamSubscription<Event> _itemSubscription;
  DatabaseError _error;
  Color doorCardColor = CupertinoColors.destructiveRed;

  @override
  void initState() {
    super.initState();
    _doorRef = FirebaseDatabase.instance.reference().child('door');
    _doorRef.keepSynced(true);
    _doorSubscription = _doorRef.onValue.listen((Event event) {
      setState(() {
        _error = null;
        _doorStatus = event.snapshot.value ?? 'synchronizing...';
        if (_doorStatus == 'Unlock') {
          doorCardColor = CupertinoColors.activeGreen;
        }
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        _error = error;
      });
    });
    _itemRef = FirebaseDatabase.instance.reference().child('item');
    _itemRef.keepSynced(true);
    _itemSubscription = _itemRef.onValue.listen((Event event) {
      List<Mail> _item = fromDb(event.snapshot);
      setState(() {
        _error = null;
        _itemStatus =
            _item[_item.length - 1].count.toString() ?? 'synchronizing...';
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        _error = error;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _doorSubscription.cancel();
    _itemSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of(context).auth;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(40),
          constraints: BoxConstraints.expand(height: height * 0.4),
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
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<FirebaseUser>(
                  future: auth.getCurrentUser(),
                  builder: (context, user) {
                    return Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Hai ${user.data.displayName}!",
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 25.0,
                                  color: secondaryColor),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: width * 0.1,
                            backgroundImage: NetworkImage(user.data.photoUrl),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Container(
          // color: Colors.red,
          // height: 500,
          margin: EdgeInsets.only(top: height * 0.42),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              doorCard(height, width),
              mailCard(height, width)
            ],
          ),
        ),
      ],
    );
  }

  InkWell doorCard(double height, double width) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/doorScreen'),
      child: Card(
        margin: EdgeInsets.only(
            bottom: height * 0.03, left: width * 0.1, right: width * 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: doorCardColor,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.lock, size: 40),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('DOOR',
                    style: TextStyle(
                        color: Colors.white, fontSize: 28.0, letterSpacing: 3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  height: 0.5,
                  width: width * 0.8,
                  child: Container(color: Colors.white)),
            ),
            ButtonTheme.bar(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('Status:',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                    Text('  $_doorStatus',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell mailCard(double height, double width) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/mailScreen'),
      child: Card(
        margin: EdgeInsets.only(
            bottom: height * 0.03, left: width * 0.1, right: width * 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: secondaryColor,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.local_mall, size: 40),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('MAIL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      letterSpacing: 3,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  height: 0.5,
                  width: width * 0.8,
                  child: Container(color: Colors.white)),
            ),
            ButtonTheme.bar(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('Items:',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                    Text('  $_itemStatus',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
