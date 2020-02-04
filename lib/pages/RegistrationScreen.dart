import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/pages/EmailIntructionScreen.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/LoginScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/UserRegistrationPassword.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/LanguageStrings.dart';

import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:i_am_a_student/utils/inputDropDown.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailAddressController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController birthDateController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  FocusNode firstFocusNode = new FocusNode();
  FocusNode secondFocusNode = new FocusNode();
  FocusNode thirdFocusNode = new FocusNode();
  FocusNode forthFocusNode = new FocusNode();
  FocusNode fifthFocusNode = new FocusNode();
  FocusNode sixthFocusNode = new FocusNode();

  SharedPreferences prefs, loginUserId;

  final dateFormat = DateFormat("dd,mm,yyyy");

  DateTime strDate;

  DateTime date = new DateTime.now();

  bool isShowBDayError = false, isNewsCheck = true;

  int groupValue;

  int registrationType;
  Map resourceData;

  String selectedGender;

  bool isInternet;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    getPreferences();
    internetConnection();
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
          ? prefix0.TextDirection.rtl
          : prefix0.TextDirection.ltr,
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
          child: Padding(
            padding: EdgeInsets.only(
                left: 36.0,
                right: 36.0),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Image.asset(
                    ImageStrings.imgRegistration,
                    height: 80.0,
                    color: AppColor.appColor,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0)),
                  HeadlineText(
                      text: Constants.getValueFromKey("PageTitle.Register", resourceData),
                      align: TextAlign.center,
                      color: AppColor.appColor),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0)),
                  form(),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedBtn(
                        onPressed: () {
                          onPressedSignUp();
                        },
                        text: Constants.getValueFromKey("PageTitle.Register", resourceData)),
                  ),
                  SizedBox(height: 20.0),
                  bottomNavigationLayout()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Flexible(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: 15.0),
                    child: TextFormField(
                      focusNode: firstFocusNode,
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                          labelText: Constants.getValueFromKey("Account.Fields.FirstName", resourceData)),
                      validator: (value) {
                        return Validator.validateFormField(
                            value,
                            Constants.getValueFromKey("Account.Fields.FirstName.Required", resourceData),
                            "",
                            Constants.NORMAL_VALIDATION);
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(secondFocusNode);
                      },
                    ),
                  ),
                ),
                new Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: TextFormField(
                      focusNode: secondFocusNode,
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                          labelText: Constants.getValueFromKey("Account.Fields.LastName", resourceData)),
                      validator: (value) {
                        return Validator.validateFormField(
                            value,
                            Constants.getValueFromKey("Account.Fields.LastName.Required", resourceData),
                            "",
                            Constants.NORMAL_VALIDATION);
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(thirdFocusNode);
                      },
                    ),
                  ),
                )
              ],
            ),
            new TextFormField(
              focusNode: thirdFocusNode,
              controller: emailAddressController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(labelText: Constants.getValueFromKey("Account.Fields.Email", resourceData)),
              validator: (value) {
                return Validator.validateFormField(
                    value,
                    Constants.getValueFromKey("Account.Fields.Email.Required", resourceData),
                    Constants.getValueFromKey("Admin.Common.WrongEmail", resourceData),
                    Constants.EMAIL_VALIDATION);
              },
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(forthFocusNode);
              },
            ),
            new TextFormField(
              focusNode: forthFocusNode,
              controller: companyController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration:
                  new InputDecoration(labelText: Constants.getValueFromKey("Account.Fields.Company", resourceData)),
              validator: (value) {
                return Validator.validateFormField(value,
                    Constants.getValueFromKey("Account.Fields.Company.Required", resourceData), "", Constants.NORMAL_VALIDATION);
              },
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(fifthFocusNode);
              },
            ),
            new InputDropdown(
              labelText: Constants.getValueFromKey("Account.Fields.DateOfBirth", resourceData),
              valueText: birthDateController.text,
              onPressed: () {
                selectDate();
              },
            ),
            new TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(labelText: Constants.getValueFromKey("Account.Fields.Password", resourceData)),
              validator: (value) {
                return Validator.validateFormField(value,
                    Constants.getValueFromKey("Account.PasswordRecovery.ConfirmNewPassword.Required", resourceData), "", Constants.NORMAL_VALIDATION);
              },
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(sixthFocusNode);
              },
            ),
            new TextFormField(
              focusNode: sixthFocusNode,
              controller: confirmPasswordController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration:
                  new InputDecoration(labelText: Constants.getValueFromKey("Account.Fields.ConfirmPassword", resourceData)),
              validator: (value) {
                return Validator.validateFormField(
                    value,
                    Constants.getValueFromKey("Account.Fields.ConfirmPassword.Required", resourceData),
                    "",
                    Constants.NORMAL_VALIDATION);
              },
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(fifthFocusNode);
              },
            ),
            CheckboxListTile(
              value: isNewsCheck,
              onChanged: (value) {
                setState(() {
                  isNewsCheck = !isNewsCheck;
                });
              },
              title: Body1Text(text: Constants.getValueFromKey("Account.Fields.Newsletter", resourceData)),
            ),
            isShowBDayError ? birthDateError() : Container(),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Body1Text(
                  text: Constants.getValueFromKey("Account.Fields.Gender", resourceData),
                  color: Colors.grey,
                )),
            gender(),
          ],
        ),
      ),
    );
  }

  Widget birthDateError() {
    return new Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 5.0)),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CaptionText(
            text: LanguageStrings.birthDateErrorText,
            align: TextAlign.start,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget gender() {
    if(selectedGender == null) {
      selectedGender = Constants.getValueFromKey("Account.Fields.Gender.Male", resourceData);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: RadioListTile<String>(
            title: Text(Constants.getValueFromKey("Account.Fields.Gender.Male", resourceData)),
            groupValue: selectedGender,
            value: Constants.getValueFromKey("Account.Fields.Gender.Male", resourceData),
            onChanged: (gender) {
              setState(() {
                selectedGender = gender;
              });
            },
          ),
        ),
        new Expanded(
          child: RadioListTile<String>(
            title: Text(Constants.getValueFromKey("Account.Fields.Gender.Female", resourceData)),
            groupValue: selectedGender,
            value: Constants.getValueFromKey("Account.Fields.Gender.Female", resourceData),
            onChanged: (gender) {
              setState(() {
                selectedGender = gender;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget bottomNavigationLayout() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Body2Text(text: Constants.getValueFromKey("nop.RegistrationScreen.AlreadyAccount", resourceData)),
          FlatBtn(
              onPressed: () {
                onPressedSignIn();
              },
              text: Constants.getValueFromKey("Account.Login.LoginButton", resourceData).toUpperCase())
        ],
      ),
    );
  }

  Future<Null> selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: new DateTime(1918),
        lastDate: new DateTime.now());

    if (picked != null) {
      setState(() {
        date = picked;
        String pick = DateFormat('dd-MM-yyyy').format(date);
        birthDateController.text = pick;
      });
    }
  }

  Future callApiForRegistration(String strJson) async {
    Map result = await UserRegistrationPassword.userRegistration(
        "${Config.strBaseURL}customers/register", strJson);
    if (result["errorCode"] == 0) {
      checkValidation(result);
    } else {
      String msg = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future checkValidation(Map result) async {
    Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    var userId = result["value"][0];
    String msg = result["value"][1];
    if (userId != null) {
      setInPreferencesUserId(userId);
      if (registrationType == 1) {
        navigatePushReplacement(HomeScreen());
      } else if (registrationType == 2) {
        navigatePushReplacement(EmailInstructionScreen());
      } else if (registrationType == 3) {
        navigatePushReplacement(EmailInstructionScreen());
      }
    }

    Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_SHORT);
  }

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.prefIsAlreadyVisitedKey, true);
    registrationType = prefs.getInt(Constants.registrationType);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  void onPressedSignUp() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      if (formKey.currentState.validate()) {
        if (confirmPasswordController.text == passwordController.text) {
          Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));

          String strJson = UserModel.addUserInfo(
              emailAddressController.text.toString(),
              passwordController.text.toString(),
              firstNameController.text.toString(),
              lastNameController.text.toString(),
              phoneNumberController.text.toString(),
              selectedGender.toString(),
              birthDateController.text.toString(),
              companyController.text.toString(),
              isNewsCheck);

          await callApiForRegistration(strJson);
        } else {
          Fluttertoast.showToast(
            msg: Constants.getValueFromKey("Account.Fields.Password.EnteredPasswordsDoNotMatch", resourceData),
          );
        }
      }
      setState(() {});
    }else{
      Fluttertoast.showToast(msg: Constants.getValueFromKey("nop.LoginScreen.NoInternet", resourceData));
    }
  }

  void onPressedSignIn() {
    navigatePushReplacement(new LoginScreen(type: Constants.FOR_LOGIN));
  }

  void setInPreferencesUserId(customerId) async {
    loginUserId = await SharedPreferences.getInstance();
    loginUserId.setInt(Constants.prefUserIdKeyInt, customerId);
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
