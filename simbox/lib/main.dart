import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:simbox/public/intro.dart';
import 'package:simbox/private/dashboard.dart';
import 'package:simbox/private/screens/door_screen.dart';
import 'package:simbox/private/screens/mail_screen.dart';
import 'package:simbox/public/sign_up.dart';
import 'package:simbox/services/auth_service.dart';
import 'package:simbox/widgets/provider_widget.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    Function duringSplash = () {
      print('Something background process');
      int a = 123 + 23;
      print(a);

      if (a > 100)
        return 1;
      else
        return 2;
    };

    Map<int, Widget> op = {1: MyApp(), 2: MyApp()};

    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SiMBOX",
        theme: ThemeData(
          fontFamily: 'OpenSans',
          primarySwatch: Colors.green,
        ),
        home: CustomSplash(
          imagePath: 'assets/app_logo_icon.png',
          backGroundColor: Colors.white,
          // backGroundColor: Color(0xfffc6042),
          animationEffect: 'zoom-out',
          logoSize: 200,
          home: HomeController(),
          customFunction: duringSplash,
          duration: 2500,
          type: CustomSplashType.StaticDuration,
          outputAndHome: op,
        ),
        routes: <String, WidgetBuilder>{
          '/signUp': (BuildContext context) =>
              SignUp(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUp(authFormType: AuthFormType.signIn),
          '/home': (BuildContext context) => HomeController(),
          '/doorScreen': (BuildContext context) => DoorScreen(),
          '/mailScreen': (BuildContext context) => MailScreen(),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Dashboard() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
