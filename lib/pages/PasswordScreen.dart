import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/LoginScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/ChangePasswordParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordScreen extends StatefulWidget {
  final int type;
  final bool isFromLoginPage;
  final String appbarTitle;

  PasswordScreen({this.type, this.isFromLoginPage, this.appbarTitle});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  var oldPasswordTextController = new TextEditingController();
  var newPasswordTextController = new TextEditingController();
  var confirmPasswordTextController = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool isInternet;
  bool isLoading;
  bool isConfirmMatch = true;
  bool isError = false;

  bool isHideOldPassword = true;
  bool isHideNewPassword = true;
  bool isHideConfirmPassword = true;
  IconData iconOldPassword = Icons.remove_red_eye;
  IconData iconNewPassword = Icons.remove_red_eye;
  IconData iconConfirmPassword = Icons.remove_red_eye;

  FocusNode firstFocusNode = new FocusNode();
  FocusNode secondFocusNode = new FocusNode();
  FocusNode thirdFocusNode = new FocusNode();

  SharedPreferences prefs;

  Map resourceData;
  int userId;

  @override
  void initState() {
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
        } else if (isLoading != null && !isLoading) {
          return layoutMain();
        }
      } else {
        return ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () {
          internetConnection();
        },
      );
    }
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          color: AppColor.appColor,
          size: 30.0,
        ),
      ),
    );
  }

  Widget layoutMain() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: widget.isFromLoginPage
            ? AppBar(
                title: Text(widget.appbarTitle
                    ),
              )
            : null,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 36, right: 36.0),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                Theme(
                  data: ThemeData(primaryColor: AppColor.appColor),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          ImageStrings.imgKeyHole,
                          width: 80.0,
                          height: 80.0,
                          color: AppColor.appColor,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.0)),
                        HeadlineText(
                            text:
                                "${widget.appbarTitle}",
                            align: TextAlign.center,
                            color: AppColor.appColor),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Body1Text(
                          text: Constants.getValueFromKey(
                              "nop.password.dontshare", resourceData),
                          align: TextAlign.center,
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        widget.type == Constants.CHANGE_PASSWORD
                            ? TextFormField(
                                focusNode: firstFocusNode,
                                obscureText: isHideOldPassword,
                                controller: oldPasswordTextController,
                                textInputAction: TextInputAction.next,
                                decoration: new InputDecoration(
                                  labelText: Constants.getValueFromKey(
                                      "Account.ChangePassword.Fields.OldPassword",
                                      resourceData),
                                  suffixIcon:
                                      oldPasswordTextController.text.isNotEmpty
                                          ? new IconButton(
                                              icon: new Icon(iconOldPassword),
                                              onPressed: () {
                                                hideOldPassword();
                                              })
                                          : null,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return Constants.getValueFromKey(
                                        "Account.ChangePassword.Fields.OldPassword",
                                        resourceData);
                                  }
                                },
                                onFieldSubmitted: (String value) {
                                  FocusScope.of(context)
                                      .requestFocus(secondFocusNode);
                                },
                              )
                            : Container(),
                        TextFormField(
                          focusNode: secondFocusNode,
                          obscureText: isHideNewPassword,
                          controller: newPasswordTextController,
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                            labelText: Constants.getValueFromKey(
                                "Account.PasswordRecovery.NewPassword",
                                resourceData),
                            suffixIcon:
                                newPasswordTextController.text.isNotEmpty
                                    ? new IconButton(
                                        icon: new Icon(iconNewPassword),
                                        onPressed: () {
                                          hideNewPassword();
                                        })
                                    : null,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return Constants.getValueFromKey(
                                  "Account.PasswordRecovery.NewPassword.NewPasswordIsRequired",
                                  resourceData);
                            }
                          },
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context).requestFocus(thirdFocusNode);
                          },
                        ),
                        TextFormField(
                          focusNode: thirdFocusNode,
                          obscureText: isHideConfirmPassword,
                          controller: confirmPasswordTextController,
                          textInputAction: TextInputAction.done,
                          decoration: new InputDecoration(
                            labelText: Constants.getValueFromKey(
                                "Account.ChangePassword.Fields.ConfirmNewPassword",
                                resourceData),
                            suffixIcon:
                                confirmPasswordTextController.text.isNotEmpty
                                    ? new IconButton(
                                        icon: new Icon(iconConfirmPassword),
                                        onPressed: () {
                                          hideConfirmPassword();
                                        })
                                    : null,
                          ),
                          validator: (value) {
                            if (!isConfirmMatch) {
                              return Constants.getValueFromKey(
                                  "Account.ChangePassword.Fields.NewPassword.EnteredPasswordsDoNotMatch",
                                  resourceData);
                            }
                            if (value.isEmpty) {
                              return Constants.getValueFromKey(
                                  "Account.Fields.ConfirmPassword.Required",
                                  resourceData);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedBtn(
                      onPressed: () async {
                        await onClickSubmit();
                      },
                      text: Constants.getValueFromKey(
                          "Forum.Submit", resourceData)),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      await getSharedPref();

      isLoading = false;
      setState(() {});
    }
  }

  Future getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future onClickSubmit() async {
    isConfirmMatch = true;
    if (formKey.currentState.validate()) {

      if (widget.type == Constants.CREATE_PASSWORD) {
        //todo call api and redirect to Home
        navigatePushReplacement(HomeScreen());
      } else if (widget.type == Constants.RESET_PASSWORD) {
        //todo call api and redirect to login
        navigatePushReplacement(
          LoginScreen(
            type: Constants.FOR_LOGIN,
          ),
        );
      } else if (widget.type == Constants.CHANGE_PASSWORD) {
        //todo call api and redirect to MyAccount
        if (newPasswordTextController.text ==
            confirmPasswordTextController.text) {
          Constants.progressDialog(
              true,
              context,
              Constants.getValueFromKey(
                  "nop.ProgressDilog.title", resourceData));
          await changePassword();
        } else {
          isConfirmMatch = false;
          formKey.currentState.validate();
        }
      }
    }
  }

  Future changePassword() async {
    if (userId != null) {
      Map result = await ChangePasswordParser.callApi(
          "${Config.strBaseURL}customers/changecustomerpassword?OldPassword=" +
              oldPasswordTextController.text.toString() +
              "&NewPassword=" +
              newPasswordTextController.text.toString() +
              "&customerId=" +
              userId.toString());
      if (result["errorCode"] == 0) {
        String mMessage = result['value'];
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));

        Fluttertoast.showToast(
          msg: mMessage +
              " " +
              Constants.getValueFromKey(
                  "nop.Account.Password.SuccessToast", resourceData),
        );
        Navigator.pop(context);
      } else {
        String mMessage = result['value'];
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
        errorDialog(mMessage);
      }
    }
  }

  hideOldPassword() {
    if (isHideOldPassword) {
      isHideOldPassword = false;
      iconOldPassword = Icons.visibility_off;
    } else {
      isHideOldPassword = true;
      iconOldPassword = Icons.remove_red_eye;
    }
    setState(() {});
  }

  hideNewPassword() {
    if (isHideNewPassword) {
      isHideNewPassword = false;
      iconNewPassword = Icons.visibility_off;
    } else {
      isHideNewPassword = true;
      iconNewPassword = Icons.remove_red_eye;
    }
    setState(() {});
  }

  hideConfirmPassword() {
    if (isHideConfirmPassword) {
      isHideConfirmPassword = false;
      iconConfirmPassword = Icons.visibility_off;
    } else {
      isHideConfirmPassword = true;
      iconConfirmPassword = Icons.remove_red_eye;
    }
    setState(() {});
  }

  void errorDialog(String reason) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            children: <Widget>[
              new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      color: Colors.red,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Padding(
                                padding: new EdgeInsets.only(top: 30.0)),
                            new Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 60.0,
                            ),
                            new Padding(padding: new EdgeInsets.only(top: 5.0)),
                            new Text(
                              Constants.getValueFromKey(
                                  "nop.Account.Password.fail", resourceData),
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                          ]),
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height / 4,
                      padding: new EdgeInsets.fromLTRB(17.0, 17.0, 17.0, 17.0),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              Constants.getValueFromKey(
                                  "nop.Error.SomethingWentWrong", resourceData),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                            new Text(
                              Constants.getValueFromKey(
                                      "nop.Account.Password.Reason",
                                      resourceData) +
                                  "\n$reason",
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.center,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                            new FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: new Text(Constants.getValueFromKey(
                                  "Common.OK", resourceData)),
                              textColor: AppColor.appColor,
                            )
                          ]),
                    ),
                  ],
                ),
              )
            ],
          );
        });
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
