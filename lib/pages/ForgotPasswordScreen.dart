import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/GetRecoveryPassword.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  var emailOrTextController = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool isInternet;

  bool isErrorInSubCategory = false;

  bool isErrorInRelatedProduct = false;

  SharedPreferences prefs;
  Map resourceData;

  @override
  void initState() {
    internetConnection();
    getPreferences();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      return layoutMain();
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () {
          internetConnection();
        },
      );
    } else {
      return Scaffold(
        body: Center(
          child: SpinKitThreeBounce(
            color: AppColor.appColor,
            size: 30.0,
          ),
        ),
      );
    }
  }

  Widget layoutMain() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar:  AppBar(
          // title: new Text(Constants.getValueFromKey("nop.HomeScreen.newArrivalLabel", resourceData)),
          elevation: 0.0,
          leading: InkWell(
              onTap: () {
                navigatePushReplacement(LoginScreen(type: Constants.FOR_LOGIN));
              },
              child: Icon(Icons.arrow_back)),),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Image.asset(
                    ImageStrings.imgQuestionMark,
                    height: 80.0,
                    width: 80.0,
                    color: AppColor.appColor,
                  ),
                  Padding(padding: EdgeInsets.only(top: 5.0)),
                  HeadlineText(
                      text: Constants.getValueFromKey("Account.PasswordRecovery", resourceData),
                      align: TextAlign.center,
                      color: AppColor.appColor),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Body1Text(
                    text: Constants.getValueFromKey("Account.PasswordRecovery.Tooltip", resourceData),
                    align: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Theme(
                    data: ThemeData(primaryColor: AppColor.appColor),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: emailOrTextController,
                        textInputAction: TextInputAction.done,
                        decoration: new InputDecoration(
                            labelText: Constants.getValueFromKey("Products.EmailAFriend.YourEmailAddress", resourceData)),
                        validator: (value) {
                          return Validator.validateFormField(
                              value,
                              Constants.getValueFromKey("Products.EmailAFriend.YourEmailAddress.Hint", resourceData),
                              Constants.getValueFromKey("Admin.Common.WrongEmail", resourceData),
                              Constants.PHONE_OR_EMAIL_VALIDATION);
                        },
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  RaisedBtn(
                      onPressed: () {
                        onPressedBtnContinue();
                      },
                      text: Constants.getValueFromKey("Account.PasswordRecovery.RecoverButton", resourceData).toUpperCase()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onPressedBtnContinue() async {
    if (formKey.currentState.validate()) {
      await getPasswordRecovery();
    }
  }

  Future getPasswordRecovery() async {
    Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    Map result = await GetRecoveryPassword.callApi(
        "${Config.strBaseURL}customers/forgotpassword?Email="+emailOrTextController.text.toString());
    if (result["errorCode"] == "0") {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(msg: result["value"]);
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(msg: result["value"]);
    }
  }

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    setState(() {});
  }

  navigatePush(Widget page) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }
}
