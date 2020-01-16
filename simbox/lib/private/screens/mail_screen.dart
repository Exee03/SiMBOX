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
  String itemCount;
  DateTime date = DateTime.now();
  String dateNow = '';

  @override
  void initState() {
    super.initState();
    itemCount = '0';
    dateNow = date.day.toString() +
        ' - ' +
        date.month.toString() +
        ' - ' +
        date.year.toString();
  }

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
                    iconTheme: IconThemeData(color: Colors.white),
                    backgroundColor: secondaryColor,
                    expandedHeight: 150.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: StreamBuilder(
                          stream: Firestore.instance
                              .collection("items")
                              .where('userUid', isEqualTo: user.data.uid)
                              .where('date', isEqualTo: dateNow)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List list = snapshot.data.documents;
                              list.forEach((f) {
                                itemCount = f['count'].toString();
                              });
                              return Text(
                                  '$dateNow\n$itemCount Item for Today!',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.white),
                                );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ),
                  ),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("items")
                          .where('userUid', isEqualTo: user.data.uid)
                          .orderBy("date")
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
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
            ));
          }
        });
  }
}
