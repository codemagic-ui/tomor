import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/SplashScreen.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/LanguageStrings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: LanguageStrings.appName,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: AppColor.appColor,
        primaryColor: AppColor.white,
        buttonTheme: ButtonThemeData().copyWith(buttonColor: AppColor.appColor, textTheme: ButtonTextTheme.primary),
        fontFamily: "EncodeSans",
      ),
      home: SplashScreen()
    );
  }
}
 