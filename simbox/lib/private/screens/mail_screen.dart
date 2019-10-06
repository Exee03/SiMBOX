import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simbox/models/mail.dart';
import 'package:simbox/services/theme.dart';

class MailScreen extends StatefulWidget {
  @override
  _MailScreenState createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> with TickerProviderStateMixin {
  List<Mail> _item;
  String text = '';
  String itemCount = "0";
  int itemLength;
  bool _value = true;
  DatabaseReference _itemRef;
  StreamSubscription<Event> _itemSubscription;
  DatabaseError _error;
  DateTime date = DateTime.now();
  String dateNow = '';

  @override
  void initState() {
    super.initState();
    _itemRef = FirebaseDatabase.instance.reference().child('item');
    _itemRef.keepSynced(true);
    _itemSubscription = _itemRef.onValue.listen((Event event) {
      setState(() {
        _error = null;
        _item = fromDb(event.snapshot);
        itemLength = _item.length;
        if (itemLength != 0) {
          itemCount = _item[_item.length - 1].count.toString();
        }
        dateNow = date.day.toString() + ' / ' + date.month.toString();
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
    _itemSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: secondaryColor,
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('$dateNow\n$itemCount Item for Today!', textAlign: TextAlign.end),
              ),
              actions: <Widget>[
                // Container(child: Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     Text(date.toString()),
                //   ],
                // ),)
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (_item.length == 0) {
                      return Text('No Item');
                    } else {
                      return Card(
                        child: ListTile(
                          title: Text(_item[index].date),
                          subtitle: Text(_item[index].time),
                          trailing: Text(_item[index].count.toString()),
                        ),
                      );
                    }
                  },
                  childCount: itemLength,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
