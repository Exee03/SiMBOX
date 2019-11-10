import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simbox/models/door.dart';
import 'package:simbox/models/mail.dart';
import 'package:simbox/services/theme.dart';

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
  Color doorCardColor = CupertinoColors.activeOrange;
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    doorDbListeners();
    itemDbListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _doorSubscription.cancel();
    _itemSubscription.cancel();
  }

  void doorDbListeners() {
    _doorRef = FirebaseDatabase.instance.reference().child('door');
    _doorRef.keepSynced(true);
    _doorSubscription = _doorRef.onValue.listen((Event event) {
      FirebaseAuth.instance.currentUser().then((user) {
        _user = user;
        setState(() {
          _error = null;
          _doorStatus = getStatusDoor(event.snapshot, user.uid);
          // _doorStatus = event.snapshot.value ?? 'synchronizing...';
          if (_doorStatus == 'Unlock') {
            doorCardColor = CupertinoColors.activeGreen;
          } else if (_doorStatus == 'Unknown') {
            doorCardColor = CupertinoColors.activeOrange;
          } else if (_doorStatus == 'Lock') {
            doorCardColor = CupertinoColors.destructiveRed;
          }
        });
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        _error = error;
      });
    });
  }

  void itemDbListeners() {
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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (_user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Hi !\n${_user.displayName}",
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 25.0,
                                  color: secondaryColor),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: width * 0.1,
                            backgroundImage: NetworkImage(_user.photoUrl),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      "Dashboard",
                      style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: height * 0.42),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                doorCard(height, width),
                mailCard(height, width, _user)
              ],
            ),
          ),
        ],
      );
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Oppsss...',
              style: TextStyle(fontSize: 30),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    'There are something with your SiMBOX.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please contact KoolBox Intelligent (M) Pvt. Ltd. for more infomation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Card doorCard(double height, double width) {
    return Card(
      margin: EdgeInsets.only(
          bottom: height * 0.03, left: width * 0.1, right: width * 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: doorCardColor,
      elevation: 10,
      child: InkWell(
        onTap: () {
          if (_doorStatus == 'Unknown') {
            _showDialog();
          } else {
            Navigator.pushNamed(context, '/doorScreen');
          }
        },
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
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card mailCard(double height, double width, FirebaseUser user) {
    return Card(
      margin: EdgeInsets.only(
          bottom: height * 0.03, left: width * 0.1, right: width * 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: secondaryColor,
      elevation: 10,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/mailScreen'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.markunread_mailbox, size: 40),
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
