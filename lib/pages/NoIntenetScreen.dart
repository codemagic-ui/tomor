import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/LanguageStrings.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoInternetScreen extends StatefulWidget {
  final GestureTapCallback onPressedRetyButton;

  NoInternetScreen({Key key, @required this.onPressedRetyButton})
      : super(key: key);

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  Completer completer = new Completer();

  Map resourceData;

  @override
  void initState() {
    getSharedPref();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  getSharedPref() async {
    var prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    getSharedPref();
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: SafeArea(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        ImageStrings.imgNoInternet,
                        height: 80.0,
                        color: AppColor.appColor,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      TitleText(
                        text: Constants.getValueFromKey("nop.noInternetScreen.noInternetTitle", resourceData),
                        align: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(top: 16.0)),
                      Body1Text(
                        text: Constants.getValueFromKey("nop.nointernetscreen.nointernetsubtext", resourceData),
                        align: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(top: 27.0)),
                      RaisedBtn(
                        onPressed: widget.onPressedRetyButton,
                        text: Constants.getValueFromKey("common.fileUploader.retry", resourceData),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
