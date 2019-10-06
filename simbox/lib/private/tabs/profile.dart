import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simbox/services/auth_service.dart';
import 'package:simbox/services/theme.dart';
import 'package:simbox/widgets/provider_widget.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    Key key,
  }) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of(context).auth;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: StreamBuilder<FirebaseUser>(
          stream: auth.getCurrentUser().asStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Stack(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(40),
                  constraints: BoxConstraints.expand(height: height),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [primaryColor, Colors.blueAccent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      stops: [0.2, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: width*0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: width * 0.2,
                        backgroundImage: NetworkImage(snapshot.data.photoUrl),
                      ),
                      SizedBox(height: 30),
                      Text(snapshot.data.displayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25, color: Colors.white)),
                      SizedBox(height: 10),
                      Text(snapshot.data.email,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25, color: Colors.white)),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: height * 0.1),
                        width: width * 0.5,
                        child: RaisedButton(
                          color: Colors.redAccent,
                          child: Text('Sign Out', style: TextStyle(color: Colors.white),),
                          onPressed: () => auth.signOut(),
                        ),
                      ),
                    ],
                  ),
                )
              ]);
              // return Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   // crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: <Widget>[
              //     CircleAvatar(
              //       radius: width*0.2,
              //       child: ClipOval(
              //         child: Image.network(
              //           snapshot.data.photoUrl,
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 30),
              //     Text(snapshot.data.displayName,
              //         textAlign: TextAlign.center,
              //         style: TextStyle(fontSize: 25)),
              //     SizedBox(height: 10),
              //     Text(snapshot.data.email,
              //         textAlign: TextAlign.center,
              //         style: TextStyle(fontSize: 25)),
              //     SizedBox(height: 20),
              //     Container(
              //       margin: EdgeInsets.symmetric(horizontal: height * 0.1),
              //       width: width * 0.5,
              //       child: RaisedButton(
              //         color: Colors.redAccent,
              //         child: Text('Sign Out'),
              //         onPressed: () => auth.signOut(),
              //       ),
              //     ),
              //   ],
              // );
            }
          }),
    );
  }
}
