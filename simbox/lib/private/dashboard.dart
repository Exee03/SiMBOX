import 'package:flutter/material.dart';
import 'package:simbox/services/auth_service.dart';
import 'package:simbox/widgets/provider_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.4),
              Text('Dashboard'),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.white,
                textColor: Colors.deepPurpleAccent,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("SignOut",
                        style: TextStyle(fontWeight: FontWeight.w300))),
                onPressed: () async {
                  try {
                    AuthService auth = Provider.of(context).auth;
                    await auth.signOut();
                    print("Signed Out!");
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
