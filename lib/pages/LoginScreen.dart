import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/pages/ForgotPasswordScreen.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/RegistrationScreen.dart';
import 'package:i_am_a_student/parser/UserLoginParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  final int type;

  LoginScreen({@required this.type});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController emailOrPhoneTextController =
  new TextEditingController();
  TextEditingController passwordTextController =
  new TextEditingController();
  FocusNode secondFocusNode = new FocusNode();

  SharedPreferences prefs;

  String strUserName;
  String strPassword;

  int registrationType;

  bool isHidePassword = true;
  IconData icon = Icons.remove_red_eye;

  bool isInternet;

  Function hp;
  Function wp;

  final key = new GlobalKey<ScaffoldState>();
  Map resourceData;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    getPreferences();
    internetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    hp = Screen(MediaQuery.of(context).size).hp;
    wp = Screen(MediaQuery.of(context).size).wp;
    if (isInternet != null && isInternet) {
      return buildLayout();
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
          child: SpinKitThreeBounce(
            color: AppColor.appColor,
            size: 30.0,
          ),
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: wp(7), right: wp(7)),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Image.asset(
                    ImageStrings.imgLogin,
                    color: AppColor.appColor,
                    height: 80.0,
                  ),
                  Padding(padding: EdgeInsets.only(top: wp(0))),
                  HeadlineText(
                      text: Constants.getValueFromKey(
                          "Account.Login.Welcome", resourceData),
                      align: TextAlign.center,
                      color: AppColor.appColor),
                  SizedBox(
                    height: hp(1),
                  ),
                  loginForm(),
                  SizedBox(
                    height: hp(1.56),
                  ),
                  InkWell(
                      onTap: () {
                        onPressedForgotPassword();
                      },
                      child: Body2Text(
                        text: Constants.getValueFromKey(
                            "Account.Login.ForgotPassword", resourceData),
                        color: AppColor.appColor,
                        align: TextAlign.end,
                      )),
                  SizedBox(height: hp(1.56)),
                  RaisedBtn(
                      elevation: 0.0,
                      onPressed: () {
                        onPressedLoginBtn();
                      },
                      text: Constants.getValueFromKey(
                          "Account.Login.LoginButton", resourceData)
                          .toUpperCase()),
                  SizedBox(
                    height: hp(0.30),
                  ),
                  registrationType == 4
                      ? Container()
                      : new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: Body2Text(
                            text: Constants.getValueFromKey(
                                "nop.LoginScreen.accountLabel",
                                resourceData),
                          align: TextAlign.start,),
                      ),
                      new FlatBtn(
                          onPressed: () {
                            onPressedSignUp();
                          },
                          text: Constants.getValueFromKey(
                              "nop.LoginScreen.signUpButtonLabel",
                              resourceData))
                    ],
                  ),
                  SizedBox(
                    height: hp(0.56),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginForm() {
    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: emailOrPhoneTextController,
              decoration: InputDecoration(
                  labelText: Constants.getValueFromKey(
                      "Account.Login.Fields.Email", resourceData)),
              textInputAction: TextInputAction.next,
              validator: (value) {
                return Validator.validateFormField(
                    value,
                    Constants.getValueFromKey(
                        "Account.Login.Fields.Email.Required", resourceData),
                    Constants.getValueFromKey(
                        "Admin.Common.WrongEmail", resourceData),
                    Constants.PHONE_OR_EMAIL_VALIDATION);
              },
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(secondFocusNode);
              },
            ),
            SizedBox(
              height: wp(1),
            ),
            TextFormField(
              controller: passwordTextController,
              decoration: InputDecoration(
                labelText: Constants.getValueFromKey(
                    "Account.Login.Fields.Password", resourceData),
                suffixIcon: passwordTextController.text.isNotEmpty
                    ? new IconButton(
                    icon: new Icon(icon),
                    onPressed: () {
                      hidePassword();
                    })
                    : null,
              ),
              textInputAction: TextInputAction.done,
              focusNode: secondFocusNode,
              obscureText: isHidePassword,
              validator: (value) {
              },
            ),
          ],
        ),
      ),
    );
  }

  hidePassword() {
    if (isHidePassword) {
      isHidePassword = false;
      icon = Icons.visibility_off;
    } else {
      isHidePassword = true;
      icon = Icons.remove_red_eye;
    }
    setState(() {});
  }


  void onPressedForgotPassword() {
    navigatePush(ForgotPasswordScreen());
  }

  void onPressedLoginBtn() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      if (formKey.currentState.validate()) {
        Constants.progressDialog(true, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
        prefs.setString(
            Constants.prefUserNameKey, emailOrPhoneTextController.text);
        prefs.setString(Constants.prefPasswordKey, passwordTextController.text);

        await getUserLoginInfo();
      }
      setState((){});
    } else {
      Fluttertoast.showToast(
          msg: Constants.getValueFromKey(
              "nop.LoginScreen.NoInternet", resourceData));
    }
  }

  void onPressedSignUp() {
    navigatePushReplacement(RegistrationScreen());
  }

  Future setInPreferences(int defaultUserId) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.prefUserIdKeyInt, defaultUserId);
    prefs.setBool(Constants.prefIsLoginSkippedKey, true);
  }

  Future getUserLoginInfo() async {
    Map result = await UserLoginParser.callApi(
        "${Config.strBaseURL}customers/login?username=" +
            emailOrPhoneTextController.text +
            "&password=" +
            passwordTextController.text +
            "&captchaValid=true");
    Constants.progressDialog(false, context,
        Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    if (result["errorCode"] == "0") {
      if (result["value"] == "fail") {
        Fluttertoast.showToast(msg: "Invalid Username or Password");
      } else {
        int customerId = result["value"];
        prefs.setBool(Constants.prefIsLoginSkippedKey, false);
        setInPreferencesUserNameOrPhone(emailOrPhoneTextController.text);
        setInPreferencesUserPassword(passwordTextController.text);
        setInPreferencesUserId(customerId);
        navigatePushReplacement(HomeScreen());
      }
    } else if (result['value'] != null) {
      Fluttertoast.showToast(msg: result['value'].toString());
    } else {
      Fluttertoast.showToast(
        msg: "Invalid Username or Password",
      );
    }
  }

  void setInPreferencesUserNameOrPhone(String text) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.loginUserName, text);
  }

  void setInPreferencesUserPassword(String text) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.loginpassword, text);
  }

  void setInPreferencesUserId(customerId) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.prefUserIdKeyInt, customerId);
  }

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    strPassword = prefs.getString(Constants.prefPasswordKey);
    strUserName = prefs.getString(Constants.prefUserNameKey);
    registrationType = prefs.getInt(Constants.registrationType);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
    Constants.checkRTL = prefs.getBool(Constants.prefRTL);
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
