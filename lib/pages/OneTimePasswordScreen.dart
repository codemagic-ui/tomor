import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/PasswordScreen.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/Strings.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneTimePasswordScreen extends StatefulWidget {
  final String sentAddress;
  final bool isEmail;
  final int type;

  OneTimePasswordScreen(
      {@required this.sentAddress, @required this.type, this.isEmail});

  @override
  _OneTimePasswordScreenState createState() => _OneTimePasswordScreenState();
}

class _OneTimePasswordScreenState extends State<OneTimePasswordScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  static const int kStartValue = 60;

  var otpTextController = new TextEditingController();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool isInternet;
  bool isError;
  int number = 123456;

  Map resourceData;

  @override
  void initState() {
    Constants.otpCode = "$number";
    controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );
    controller.forward(from: 0.0);
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    getSharedPref();
    super.initState();
  }

  getSharedPref() async {
    var prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      return layout();
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
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget layout() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Image.asset(
                    ImageStrings.imgVerification,
                    height: 80.0,
                    width: 80.0,
                    color: AppColor.appColor,
                  ),
                  Padding(padding: EdgeInsets.only(top: 5.0)),
                  HeadlineText(
                      text: Constants.getValueFromKey("nop.OTPScreen.strOTPScreenTitle", resourceData),
                      align: TextAlign.center,
                      color: AppColor.appColor),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Body1Text(
                    text: "${Constants.getValueFromKey("nop.OTPScreen.strOTPScreenSubTitle", resourceData)}${widget.sentAddress}.",
                    align: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Theme(
                    data: ThemeData(
                      primaryColor: AppColor.appColor,
                    ),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: otpTextController,
                        keyboardType: TextInputType.number,
                        maxLength: Constants.otpLength,
                        textInputAction: TextInputAction.done,
                        decoration:
                            new InputDecoration(labelText: Constants.getValueFromKey("String nop.OTPScreen.strHintOTP", resourceData)),
                        validator: (value) {
                          var validator = Validator.validateFormField(
                              value,
                              Constants.getValueFromKey("nop.OTPScreen.strErrorEmptyOTP", resourceData),
                              "",
                              Constants.NORMAL_VALIDATION);
                          if (validator == null) {
                            if (value != Constants.otpCode) {
                              return Constants.getValueFromKey("nop.OTPScreen.strInvalidOTP", resourceData);
                            } else {
                              return validator;
                            }
                          }
                          return "";
                        },
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  RaisedBtn(
                      onPressed: () {
                        onPressedBtnVerify();
                      },
                      text: Constants.getValueFromKey("nop.OTPScreen.strBtnVerify", resourceData).toUpperCase()),
                  Padding(padding: EdgeInsets.only(top: 30.0)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Body1Text(text: Constants.getValueFromKey("nop.OTPScreen.strDidNotGetOTP", resourceData))),
                        Container(
                          child: Countdown(
                            animation: new StepTween(
                              begin: kStartValue,
                              end: 0,
                            ).animate(controller),
                            onPressed: () {
                              callApiForSendOtp();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  callApiForSendOtp() {
    //todo call api
    number = number + 1;
    Constants.otpCode = "$number";
    controller.forward(from: 0.0);
  }

  onPressedBtnVerify() {
    if (formKey.currentState.validate()) {
      if (widget.type == Constants.SEND_OTP_FROM_FORGOT_PASSWORD) {
        //todo send necessary data
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new PasswordScreen(
                  type: Constants.RESET_PASSWORD,
                  appbarTitle: Constants.getValueFromKey("Admin.Orders.Products.Download.ResetDownloadCount", resourceData),
                  isFromLoginPage: false,
                ));
        navigateAndReturn(context, route);
      } else if (widget.type == Constants.SEND_OTP_FROM_CREATE_ACCOUNT) {
        //todo send necessary data
         new MaterialPageRoute(
            builder: (BuildContext context) => new PasswordScreen(
              appbarTitle: Constants.getValueFromKey("nop.passwordscreen.createpassword", resourceData),
                type: Constants.CREATE_PASSWORD, isFromLoginPage: false));
      } else if (widget.type == Constants.SEND_OTP_FROM_PROFILE) {
        Navigator.of(context).pop(true);
      }
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    setState(() {});
  }

  navigateAndReturn(BuildContext context, var route) async {
    await Navigator.pushReplacement(context, route);
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation, this.onPressed})
      : super(key: key, listenable: animation);
  final Animation<int> animation;
  final GestureTapCallback onPressed;

  @override
  build(BuildContext context) {
    String time = "(${animation.value})";
    if (animation.value == 0) {
      time = "";
    }
    return InkWell(
      onTap: animation.value == 0 ? onPressed : null,
      child: Body2Text(
        text: "${Strings.strBtnResend} $time",
        color: animation.value == 0 ? AppColor.appColor : AppColor.disableColor,
      ),
    );
  }
}
