import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppColor.dart';
import 'SpinKitThreeBounce.dart';
import 'TextStyle.dart';

class Constants {
  static const String prefIsAlreadyVisitedKey = "isAlreadyVisited";
  static const String prefPasswordKey = "user_password";
  static const String prefUserNameKey = "user_name";
  static const String prefIsLoginSkippedKey = "isLoginSkipped";
  static const String prefUserIdKeyInt = "UserId";
  static const String prefMap = "HashMap";
  static const String prefLanguageId = "LanguageId";
  static const String prefRTL = "RTL";
  static const String loginUserName = "loginUserName";
  static const String loginpassword = "loginpassword";
  static const String registrationType = "registrationType";
  static const String logo = "logo";
  static const String color = "color";
  static  bool onsearchresultpage = false;

  static bool checkRTL = false;

  static int cartItemCount = 0;

  static const int NO_INTERNET = 1;

  static const int FOR_LOGIN = 2;

  static const int NORMAL_VALIDATION = 1;
  static const int EMAIL_VALIDATION = 2;
  static const int PHONE_VALIDATION = 3;
  static const int STRONG_PASSWORD_VALIDATION = 4;
  static const int PHONE_OR_EMAIL_VALIDATION = 5;

  static const int SEND_OTP_FROM_FORGOT_PASSWORD = 1;
  static const int SEND_OTP_FROM_CREATE_ACCOUNT = 2;
  static const int SEND_OTP_FROM_PROFILE = 3;

  static int otpLength = 6;
  static String otpCode = "";

  static const int CREATE_PASSWORD = 0;
  static const int RESET_PASSWORD = 1;
  static const int CHANGE_PASSWORD = 2;



  static var typeOfGroupProductDetailPage = "GroupedProduct";
  static var typeOfSimpleProductDetailPage = "SimpleProduct";


  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static bool isValidPhone(String phone) {
    bool isPhone = false;
    RegExp exp = new RegExp('^[0-9]{10}\$');
    Iterable<Match> matches = exp.allMatches(phone);
    for (Match m in matches) {
      m.group(0);
      isPhone = true;
    }
    return isPhone;
  }

  static bool isValidEmail(String email) {
    bool isEmail = false;
    RegExp exp = new RegExp("[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+");
    Iterable<Match> matches = exp.allMatches(email);
    for (Match m in matches) {
      m.group(0);
      isEmail = true;
    }
    return isEmail;
  }

  static progressDialog(bool isLoading, BuildContext context,String resourceData) async {
    AlertDialog dialog = new AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: new Container(
        height: 100.0,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitThreeBounce(
                  color: AppColor.appColor,
                  size: 30.0,
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                TitleText(text: "Please wait",color: Colors.white)
              ],
            ),
          )),
      contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
    );
    if (!isLoading) {
      Navigator.of(context).pop();
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  static progressDialog1(bool isLoading, BuildContext context) async {
    AlertDialog dialog = new AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: new Container(
          height: 100.0,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitThreeBounce(
                  color: AppColor.appColor,
                  size: 30.0,
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                TitleText(text: "Please wait",color: Colors.white)
              ],
            ),
          )),
      contentPadding: new EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
    );
    if (!isLoading) {
      Navigator.of(context).pop();
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  static String getValueFromKey(String mapKey,Map map){
    String key=mapKey.toLowerCase();
    if(map != null && map.containsKey(key) && map[key] != null && map[key].toString().isNotEmpty){
      return map[key];
    }
    return key;
  }
}

abstract class RefreshListener {
  void onRefresh();
}
