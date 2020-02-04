import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/ResourceString.dart';
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/LoginScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/GetLogoAndColorParser.dart';
import 'package:i_am_a_student/parser/LanguageParser.dart';
import 'package:i_am_a_student/parser/UserLoginParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'LanguageScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool isAlreadyVisited;
  bool isLoginSkipped;
  String strPassword = "", strPhoneOrEmail = "";
  int userId;
  int registrationType;
  SharedPreferences prefs;
  bool isError = false;
  bool isInternet;
  bool isLoading;
  String color;
  String logo = "";
  String languageId;
  List<ResourceString> languageList = new List<ResourceString>();

  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    getPreferences();
    getLogoAndColor();
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isLoading != null && isLoading) {
          callApi();
        }
        return layoutMain();
      } else {
        return ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () async {
          internetConnection();
        },
      );
    }
    return Scaffold(
      body: layoutMain(),
    );
  }

  Widget layoutMain() {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
         child: Image.asset("images/logo.png", width: 200,),
        ),
      ),
    );
  }

  callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      await checkCustomerRegistrationType();
      nextScreen();
      isLoading = false;
      setState(() {});
    }
  }

  Future checkCustomerRegistrationType() async {
    try {
      Map result = await UserLoginParser.callApiForRegistration(
          "${Config.strBaseURL}customers/registrationtype");
      if (result["errorCode"] == "0") {
        if (result["value"] == "fail") {
        } else {
          UserModel userModel = result["value"];
          registrationType = userModel.strUserRegistrationType;
          if (registrationType != null) {
            saveRegistrationType(registrationType);
          }
        }
      } else if (result == null) {}
    } catch (e) {
      print(e);
    }
  }

  Future getLogoAndColor() async {
    Map result = await GetLogoAndColorParser.getLogoAndColorParser(
        Config.strBaseURL + "customers/getappcolorlogo");
    if (result["errorCode"] == 0) {
      try {
        color = result["value"][0];
        logo = result["value"][1];
        AppColor.appColor = hexToColor(color);
        prefs.setString(Constants.logo, logo);
      } catch (e) {
        print(e);
      }
    }
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }


  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    isAlreadyVisited = prefs.getBool(Constants.prefIsAlreadyVisitedKey);
    isLoginSkipped = prefs.getBool(Constants.prefIsLoginSkippedKey);
    strPassword = prefs.getString(Constants.loginpassword);
    strPhoneOrEmail = prefs.getString(Constants.loginUserName);
    userId = prefs.getInt(Constants.prefUserIdKeyInt);
    languageId = prefs.getString(Constants.prefLanguageId);
    Constants.checkRTL = prefs.getBool(Constants.prefRTL);
  }

  void loginApiCall() async {
    Map result = await UserLoginParser.callApi(
        "${Config.strBaseURL}customers/login?username=" +
            strPhoneOrEmail +
            "&password=" +
            strPassword);
    if (result["errorCode"] == "0") {
      navigatePushReplacement(HomeScreen());
    } else {
      navigatePushReplacement(LoginScreen(type: Constants.FOR_LOGIN));
    }
  }

  Future nextScreen() async {
    if (languageId != null) {
      // Todo call api for getResource String
      await getResourceString();
      if (userId != null) {
        if (strPhoneOrEmail != null && strPassword != null) {
          loginApiCall();
        } else {
          navigatePushReplacement(HomeScreen());
        }
      } else if (isAlreadyVisited != null && isAlreadyVisited) {
        navigatePushReplacement(LoginScreen(type: Constants.FOR_LOGIN));
      } else {
        navigatePushReplacement(LoginScreen(type: Constants.FOR_LOGIN));
      }
    } else {
      navigatePushReplacement(LanguageScreen());
    }
  }

  Future getResourceString() async {
    Map result = await LanguageParser.languageParser(
        "${Config.strBaseURL}languages/getallresourcestrings?languagesId=" +
            languageId.toString());
    if (result["errorCode"] == "0") {
      languageList = result["value"];
    } else {
      isError = true;
    }
  }

  void saveRegistrationType(int registrationType) {
    if (prefs != null) {
      prefs.setInt(Constants.registrationType, registrationType);
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }
}
