import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simbox/services/auth_service.dart';
import 'package:simbox/services/theme.dart';
import 'package:simbox/widgets/provider_widget.dart';

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
    AuthService auth = Provider.of(context).auth;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder<FirebaseUser>(
        future: auth.getCurrentUser(),
        builder: (context, user) {
          if (!user.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: false,
                  backgroundColor: primaryColor,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Security',
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    background: Container(
                      constraints: BoxConstraints.expand(height: height * 0.7),
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [Colors.blueAccent, primaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                  expandedHeight: 150.0,
                ),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("camera")
                        .where('userUid', isEqualTo: user.data.uid)
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 10.0),
                                        child: CachedNetworkImage(
                                          imageUrl: ds['imageURL'],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: ListTile(
                                          // leading: Icon(Icons.card_giftcard,
                                          //     size: 40, color: secondaryColor),
                                          title: Text(
                                              '${ds['date']} at ${ds['time']}'),
                                          subtitle: Text(ds['detail']),
                                          // trailing: CircleAvatar(
                                          //   child: Text(ds['count'].toString(),
                                          //       style: TextStyle(
                                          //         color: Colors.white,
                                          //       )),
                                          //   backgroundColor: secondaryColor,
                                          // ),
                                        ),
                                      ),
                                    ],
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
            );
          }
        });
  }
}
