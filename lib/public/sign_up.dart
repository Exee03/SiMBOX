import 'package:flutter/material.dart';
import 'package:SiMBOX/services/auth.service.dart';

final primaryColor = const Color(0xFF75A2EA);

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(child: Column(
        children: <Widget>[Text("SignUp")]
      ),)
    );
  }
}