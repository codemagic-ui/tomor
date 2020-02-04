import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/LanguageStrings.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorScreenPage extends StatefulWidget {
  @override
  _ErrorScreenPageState createState() => _ErrorScreenPageState();
}

class _ErrorScreenPageState extends State<ErrorScreenPage> {
  Map resourceData;

  @override
  void initState() {
    getPreferences();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  getPreferences() async {
    // var prefs = await SharedPreferences.getInstance();
    // String jsonData = prefs.getString(Constants.prefMap);
    // resourceData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    getPreferences();
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new SafeArea(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Icon(Icons.error_outline,
                  size: 90.0, color: AppColor.errorColor),
              new SizedBox(height: 20.0),
              new HeadlineText(
                  align: TextAlign.center, text:"Oops!" ),
              new SizedBox(height: 10.0),
              new Body1Text(
                  align: TextAlign.center,
                  text: "Something went wrong."),
            ],
          ),
        ),
      ),
    );
  }
}
