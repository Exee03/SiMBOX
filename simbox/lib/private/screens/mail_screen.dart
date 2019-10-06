import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simbox/models/mail.dart';
import 'package:simbox/services/auth_service.dart';
import 'package:simbox/services/theme.dart';
import 'package:simbox/widgets/provider_widget.dart';

class MailScreen extends StatefulWidget {
  @override
  _MailScreenState createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> with TickerProviderStateMixin {
  List<Mail> _item;
  // String text = '';
  String itemCount = "0";
  // int itemLength;
  // // bool _value = true;
  // DatabaseReference _itemRef;
  // StreamSubscription<Event> _itemSubscription;
  // DatabaseError _error;
  DateTime date = DateTime.now();
  String dateNow = '';

  @override
  void initState() {
    super.initState();
    // _itemRef = FirebaseDatabase.instance.reference().child('item');
    // _itemRef.keepSynced(true);
    // _itemSubscription = _itemRef.onValue.listen((Event event) {
    // setState(() {
    // _error = null;
    // _item = fromDb(event.snapshot);
    // itemLength = _item.length;
    dateNow = date.day.toString() + ' - ' + date.month.toString() + ' - ' + date.year.toString();
    // if (itemLength != 0) {
    //   itemCount = _item[_item.length - 1].count.toString();
    // }
    // });
    // }, onError: (Object o) {
    //   final DatabaseError error = o;
    //   setState(() {
    //     _error = error;
    //   });
    // });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _itemSubscription.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of(context).auth;
    return FutureBuilder<FirebaseUser>(
        future: auth.getCurrentUser(),
        builder: (context, user) {
          if (!user.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new Scaffold(
              body: Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: secondaryColor,
                      expandedHeight: 150.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('$dateNow\n$itemCount Item for Today!',
                            textAlign: TextAlign.end),
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
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection("items")
                            .where('userUid', isEqualTo: user.data.uid)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return SliverFillRemaining(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          List data = snapshot.data.documents;
                          data.forEach((e) => {
                                if (e['date'] == dateNow)
                                  {itemCount = e['count'].toString()}
                              });

                          return SliverPadding(
                            padding: const EdgeInsets.all(20.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.documents[index];
                                  if (snapshot.data.documents.length == 0) {
                                    return Center(child: Text('No Item'));
                                  } else {
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(Icons.card_giftcard,
                                            size: 40, color: secondaryColor),
                                        title: Text(ds['date']),
                                        subtitle: Text(ds['time']),
                                        trailing: CircleAvatar(
                                          child: Text(ds['count'].toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                          backgroundColor: secondaryColor,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                childCount: snapshot.data.documents.length,
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            );
          }
        });
  }
}
