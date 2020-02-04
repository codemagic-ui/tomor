import 'package:flutter/material.dart';

class AppColor {
//  static MaterialColor primarySwatchColor = appColor;
//  static MaterialColor primarySwatchColor = Colors.white;
//  static MaterialColor errorColor = Colors.red;
//  static MaterialColor disableColor = Colors.grey;
//
//  static Color white = Colors.white;
//  static Color black = Colors.black;
//  static Color grey = Color(0xFFFAFAFA);
//  static int appColorPrimaryValue = 0xFF17569B; //0xFFC70851;
//
//  static Color primaryColor = Color(0xFF17569B);
//
//  static MaterialColor appColor = MaterialColor(
//    primaryColor.value,
//    <int, Color>{
//      50: primaryColor.withAlpha(50),/*Color(0xFFD5E0ED),*/
//      100: primaryColor.withAlpha(100),//Color(0xFFC0D1E4),
//      200: primaryColor.withAlpha(200),//Color(0xFFABC2DB),
//      300: primaryColor.withAlpha(300),
//      400: primaryColor.withAlpha(400),
//      500: primaryColor.withAlpha(500),
//      600: primaryColor.withAlpha(600),
//      700: primaryColor.withAlpha(700),
//      800: primaryColor.withAlpha(800),
//      900: primaryColor.withAlpha(900),
//    },
//  );

  static MaterialColor primarySwatchColor = Colors.white;
  static MaterialColor errorColor = Colors.red;
  static MaterialColor disableColor = Colors.grey;

  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color grey = Color(0xFFFAFAFA);

  static int appColorPrimaryValue = 0xFF17569B; //0xFFC70851;
  static MaterialColor appColor = MaterialColor(
    appColorPrimaryValue,
    <int, Color>{
      50: Color(0xFFD5E0ED),
      100: Color(0xFFC0D1E4),
      200: Color(0xFFABC2DB),
      300: Color(0xFF96B2D2),
      400: Color(0xFF80A3C8),
      500: Color(0xFF6B93BF),
      600: Color(0xFF5684B6),
      700: Color(0xFF4175AD),
      800: Color(0xFF2C65A4),
      900: Color(0xFF17569B),
    },
  );

}
