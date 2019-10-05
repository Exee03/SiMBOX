import 'package:flutter/material.dart';

const Color primaryColor = Colors.deepPurpleAccent;
const Color secondaryColor = Color(0xFFF78D12);

// TextStyle appTitle = TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w500, fontSize: 31.0);
// TextStyle appTitleBig = TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w500, fontSize: 45.0);
// TextStyle appHeader1 = TextStyle(fontFamily: 'TitilliumWeb', fontWeight: FontWeight.w300, fontSize: 30.0, letterSpacing: 2, color: Colors.black45);
// TextStyle appHeader2 = TextStyle(fontFamily: 'TitilliumWeb', fontWeight: FontWeight.w300, fontSize: 25.0, letterSpacing: 2, color: Colors.black45);
TextStyle cardTitleBig = TextStyle(fontSize: 28.0, letterSpacing: 5);
// TextStyle cardTitleBigInv = TextStyle(fontFamily: 'Exo_2', color: Colors.white, fontWeight: FontWeight.w300, fontSize: 28.0, letterSpacing: 5);
// TextStyle cardTitle = TextStyle(fontFamily: 'Exo_2', fontWeight: FontWeight.w300, fontSize: 20.0, letterSpacing: 5);
// TextStyle cardTitleInv = TextStyle(fontFamily: 'Exo_2', color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20.0, letterSpacing: 5);
// TextStyle cardSmallTitle = TextStyle(fontFamily: 'Exo_2', fontWeight: FontWeight.w300, fontSize: 15.0, letterSpacing: 5);
// TextStyle cardSubtitle = TextStyle(fontFamily: 'Exo_2', fontWeight: FontWeight.w300, fontSize: 15.0, letterSpacing: 3);
// TextStyle cardSmallSubtitle = TextStyle(fontFamily: 'Exo_2', fontWeight: FontWeight.w300, fontSize: 10.0, letterSpacing: 3);
// TextStyle appBarTextStyle = TextStyle(color: Colors.black, fontSize: 24.0);
// TextStyle radioSelectedTextStyle = TextStyle(color: Colors.white, fontSize: 18.0);
// TextStyle radioUnSelectedTextStyle = TextStyle(color: Colors.black, fontSize: 18.0);
// TextStyle extraSmallTextStyle = TextStyle(fontFamily: 'VarelaRound',fontSize: 10.0);
// TextStyle smallTextStyle = TextStyle(fontFamily: 'VarelaRound',fontSize: 12.0);
TextStyle mediumTextStyle = TextStyle(fontFamily: 'OpenSans', fontSize: 17.0);
// TextStyle bigTextStyle = TextStyle(fontFamily: 'VarelaRound', fontSize: 20.0);
// TextStyle smallTextStyleInv = TextStyle(fontFamily: 'VarelaRound',fontSize: 12.0, color: Colors.white);
// TextStyle mediumTextStyleInv = TextStyle(fontFamily: 'VarelaRound', fontSize: 17.0, color: Colors.white);
// TextStyle bigTextStyleInv = TextStyle(fontFamily: 'VarelaRound', fontSize: 20.0, color: Colors.white);
TextStyle smallBoldTextStyle = TextStyle(fontFamily: 'OpenSans', color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w900);
TextStyle bigTextTitleStyle = TextStyle(fontFamily: 'OpenSans', color: Colors.white, fontSize: 50.0);

ThemeData buildThemeData(){
  final baseTheme= ThemeData.light();
  return baseTheme.copyWith(
    primaryColor: Colors.orange,
    primaryColorLight: Color(0xFFFFB74D),
    primaryColorDark: Colors.orangeAccent
  );
}