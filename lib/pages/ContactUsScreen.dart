import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/ContactUsParser.dart';
import 'package:i_am_a_student/parser/GetEditProfileInfo.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;

  String verifiedEmail = "";
  String userName = "";
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  var emailTextController = new TextEditingController();
  var nameTextController = new TextEditingController();
  var enquiryTextController = new TextEditingController();
  Map resourceData;

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
        appBar: AppBar(
          title: Text(
              Constants.getValueFromKey("PageTitle.ContactUs", resourceData)),
        ),
        body: Center(
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(8.0),
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                Image.asset(
                  ImageStrings.imgContactUs,
                  height: 200.0,
                  width: 200.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TitleText(
                  text: Constants.getValueFromKey(
                      "nop.ContactUsScreen.title.subTitle", resourceData),
                  align: TextAlign.center,
                  color: AppColor.appColor,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Body1Text(
                    text: Constants.getValueFromKey(
                        "nop.ContactUsScreen.title.description", resourceData),
                    align: TextAlign.center),
                SizedBox(
                  height: 20.0,
                ),
                Theme(
                  data: ThemeData(primaryColor: AppColor.appColor),
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0, left: 15.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5.0)),
                      height: 50.0,
                      child: Center(
                        child: TextFormField(
                          controller: nameTextController,
                          decoration: InputDecoration.collapsed(
                              hintText: Constants.getValueFromKey(
                                  "ContactUs.FullName", resourceData)),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return Constants.getValueFromKey(
                                  "ContactUs.FullName.Required", resourceData);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Theme(
                  data: ThemeData(primaryColor: AppColor.appColor),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5.0)),
                      height: 50.0,
                      child: Center(
                        child: TextFormField(
                          controller: emailTextController,
                          decoration: InputDecoration.collapsed(
                              hintText: Constants.getValueFromKey(
                                  "ContactUs.Email", resourceData)),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return Constants.getValueFromKey(
                                  "ContactUs.Email.Required", resourceData);
                              ;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Theme(
                  data: ThemeData(primaryColor: AppColor.appColor),
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0, left: 15.0),
                    child: TextFormField(
                      controller: enquiryTextController,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: Constants.getValueFromKey(
                              "ContactUs.Enquiry", resourceData),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Constants.getValueFromKey(
                              "ContactUs.Enquiry.Required", resourceData);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: RaisedBtn(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          String jsonContactUs = UserModel.contactUs(
                              emailTextController.text.toString(),
                              enquiryTextController.text.toString(),
                              nameTextController.text.toString());
                          Constants.progressDialog(
                              true,
                              context,
                              Constants.getValueFromKey(
                                  "nop.ProgressDilog.title", resourceData));
                          await onContactUsSubmit(jsonContactUs);
                        }
                      },
                      text: Constants.getValueFromKey(
                              "ContactUs.Button", resourceData)
                          .toUpperCase()),
                )
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
      await getPreferences();
      await getUserInfoToGetEmailList();
      isLoading = false;
      setState(() {});
    }
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future getUserInfoToGetEmailList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(Constants.prefUserIdKeyInt);

    Map result = await GetEditProfileInfo.callApi(
        "${Config.strBaseURL}customers/" + userId.toString());
    if (result["errorCode"] == "0") {
      try {
        UserModel userModel = result["value"][0];

        verifiedEmail = userModel.strCustomerEmail;
        emailTextController.text = verifiedEmail;
        if (userModel.strCustomerFirstName != null) {
                userName = userModel.strCustomerFirstName +
                            " " +
                            userModel.strCustomerLastName !=
                        null
                    ? userModel.strCustomerLastName
                    : "";
              }
        nameTextController.text = userName;
      } catch (e) {
        print(e);
      }
    } else {
      isError = true;
    }
    isLoading = false;
  }

  Future onContactUsSubmit(String jsonContactUs) async {
    Map result = await ContactUsParser.callApi(
        "${Config.strBaseURL}customers/contactussend", jsonContactUs);
    if (result["errorCode"] == 0) {
      String mMessage = result['value'];
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      errorDialog(mMessage);
    } else {
      String mMessage = result['value'];
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: mMessage,
      );
    }
  }

  void errorDialog(String reason) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    color: Colors.green,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Padding(padding: new EdgeInsets.only(top: 30.0)),
                          new Icon(
                            Icons.done_outline,
                            color: Colors.white,
                            size: 60.0,
                          ),
                          new Padding(padding: new EdgeInsets.only(top: 5.0)),
                          new Text(
                            Constants.getValueFromKey(
                                "ContactUs.YourEnquiryHasBeenSent",
                                resourceData),
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          new Padding(padding: new EdgeInsets.only(top: 17.0)),
                        ]),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height / 4.7,
                    padding: new EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 17.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          new Text(
                            "$reason",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.body1,
                          ),
                          new Padding(padding: new EdgeInsets.only(top: 17.0)),
                          new FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: new Text(Constants.getValueFromKey(
                                "Admin.Common.Ok", resourceData)),
                            textColor: AppColor.appColor,
                          )
                        ]),
                  ),
                ],
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
}
