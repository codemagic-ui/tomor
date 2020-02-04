import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoAddressFoundScreen extends StatefulWidget {
  @override
  _NoAddressFoundScreenState createState() => _NoAddressFoundScreenState();
}

class _NoAddressFoundScreenState extends State<NoAddressFoundScreen> {
  SharedPreferences prefs;
  Map resourceData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    prefs =  SharedPreferences.getInstance() as SharedPreferences;
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);

  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/noaddress.png", height: 150, width: 150),
              SizedBox(height: 20.0),
              TitleText(text: Constants.getValueFromKey("nop.NoAddressFoundScreen.NoAddressFound", resourceData)),
              SizedBox(height: 20.0),
              RaisedBtn(onPressed: () {}, text: Constants.getValueFromKey("nop.NoAddressFoundScreen.AddAddressButton", resourceData))
            ],
          ),
        ),
      ),
    );
  }
}
