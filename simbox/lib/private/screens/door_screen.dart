import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simbox/services/theme.dart';
import 'package:xlive_switch/xlive_switch.dart';

class DoorScreen extends StatefulWidget {
  @override
  _DoorScreenState createState() => _DoorScreenState();
}

class _DoorScreenState extends State<DoorScreen> with TickerProviderStateMixin {
  String _doorStatus = '';
  String text = '';
  bool _value = true;
  DatabaseReference _doorRef;
  StreamSubscription<Event> _doorSubscription;
  DatabaseError _error;

  @override
  void initState() {
    super.initState();
    _doorRef = FirebaseDatabase.instance.reference().child('door');
    _doorRef.keepSynced(true);
    _doorSubscription = _doorRef.onValue.listen((Event event) {
      if (event.snapshot.value == 'Lock') {
        setState(() {
          _error = null;
          _doorStatus = event.snapshot.value ?? 'synchronizing...';
          _value = false;
          text = 'Unlock';
        });
      } else {
        setState(() {
          _error = null;
          _doorStatus = event.snapshot.value ?? 'synchronizing...';
          _value = true;
          text = 'Lock';
        });
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: primaryColor),),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildIcon(),
            ),
            Text('Switch the toggle to',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 40)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: XlivSwitch(
                value: _value,
                onChanged: _changeValue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon buildIcon() {
    if (_value == true) {
      return Icon(Icons.lock_open, color: CupertinoColors.activeGreen, size: 100);
    } else {
      return Icon(Icons.lock_outline, color: CupertinoColors.destructiveRed, size: 100);
    }
  }

  Future _changeValue(bool value) async {
    String status = 'Lock';
    String reverseStatus = 'Unlock';
    if (value == true) {
      status = 'Unlock';
      reverseStatus = 'Lock';
    }
    await _doorRef.runTransaction((MutableData mutableData) async {
      mutableData.value = status;
      return mutableData;
    });
    setState(() {
      _value = value;
      _doorStatus = status;
      text = reverseStatus;
    });
  }
}
