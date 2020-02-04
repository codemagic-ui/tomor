import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/DefaultUserInfo.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';

import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailInstructionScreen extends StatefulWidget {
  @override
  _EmailInstructionScreenState createState() => _EmailInstructionScreenState();
}

class _EmailInstructionScreenState extends State<EmailInstructionScreen> {
  bool isError = false;
  bool isInternet;
  bool isLoading;
  Map resourceData;

  @override
  void initState() {
    internetConnection();
    getPreferences();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if (!isError) {
        return buildLayout();
      }else{
        return ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () async {
          internetConnection();
        },
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: SpinKitThreeBounce(color: AppColor.appColor,size: 30.0,),
        ),
      );
    }
  }

  Widget buildLayout() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/emailsend.png",
                height: 150.0,
                width: 150.0,
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                Constants.getValueFromKey("Account.Register.Result.EmailValidation", resourceData),
                maxLines: 6,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.green),
              ),
              SizedBox(
                height: 40.0,
              ),
              RaisedBtn(
                onPressed: () {


                  if (isInternet) {
                    isLoading = true;
                    getDefaultUser();

                    isLoading = false;
                    setState(() {});
                  }
                },
                text: Constants.getValueFromKey("Account.Register.Result.Continue", resourceData).toUpperCase(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getDefaultUser() async {
    Map result = await DefaultUserInfo.callApi("${Config.strBaseURL}customers/default");
    if (result["errorCode"] == "0") {
      int defaultUserId = result["value"];
      setInPreferences(defaultUserId);
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      navigatePushReplacement(HomeScreen());
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      isError = true;
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  navigatePush(Widget page) async {

    await Navigator.push(context, AnimationPageRoute(page: page,context: context));
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page,context: context));
  }

  setInPreferences(int defaultUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.prefUserIdKeyInt, defaultUserId);
    prefs.setBool(Constants.prefIsLoginSkippedKey, true);
  }
}
