import 'package:flutter/material.dart';
import 'package:simbox/private/tabs/home.dart';
import 'package:simbox/private/tabs/profile.dart';
import 'package:simbox/private/tabs/security.dart';
import 'package:simbox/services/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Dashboard extends StatefulWidget {
  
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isConfigured = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // String lastNoti = '';

  @override
  void initState() {
    super.initState();
    if (!_isConfigured) {
      firebaseMessagingListeners();
      _isConfigured = true;
    }
  }

  void firebaseMessagingListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _dialog(message['data']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _dialog(message['data']);
      },
      onResume: (Map<String, dynamic> message) async {
        _dialog(message['data']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
  
  _dialog(notification) {
    if (notification['emergency'] == "true") {
        return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            title: Text(notification['title'],
                style: TextStyle(fontSize: 20, color: primaryColor)),
            content: Container(
              height: 260,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: <Widget>[
                  new Image(
                    image: new CachedNetworkImageProvider(notification['url']),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'An unknown person attempts to open your Mailbox on ${notification['time']} !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Dismiss'),
              )
            ],
          ),
        );
      } else if (notification['emergency'] == "false") {
        String textDialog = '';
        String titleDialog = '';
        if (notification['count'] == 0) {
          titleDialog = 'Congratulations !';
          textDialog =
              'Your stuff have been safely taken away on ${notification['time']}.';
        } else {
          titleDialog = 'Your stuff is here !';
          textDialog =
              '${notification['count']} of your goods is arrived on ${notification['time']}, please check and take your goods in Mailbox !';
        }
        return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            title: Text(titleDialog,
                style: TextStyle(fontSize: 20, color: primaryColor)),
            content: Container(
              height: 250,
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.markunread_mailbox,
                    size: 100,
                    color: primaryColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    textDialog,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Dismiss'),
              )
            ],
          ),
        );
      }
  }

   @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [ HomeTab(), SecurityTab(), ProfileTab()],
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
