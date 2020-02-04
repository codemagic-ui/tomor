import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/LanguageModel.dart';
import 'package:i_am_a_student/models/ResourceString.dart';
import 'package:i_am_a_student/parser/GetLanguageParser.dart';
import 'package:i_am_a_student/parser/LanguageParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ErrorScreenPage.dart';
import 'HomeScreen.dart';
import 'LoadingScreen.dart';
import 'LoginScreen.dart';
import 'NoIntenetScreen.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isError = false;
  bool isInternet;
  bool isLoading;
  TextEditingController searchController = new TextEditingController();
  List<LanguageModel> languageList = new List<LanguageModel>();
  List<LanguageModel> searchedLanguageList = new List<LanguageModel>();
  List<ResourceString> resourceStringList = new List<ResourceString>();
  SharedPreferences prefs;
  int userId;
  String strPassword = "", strPhoneOrEmail = "";

  @override
  void initState() {
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: new ThemeData(
          brightness: Brightness.light,
          primarySwatch: AppColor.appColor,
          primaryColor: AppColor.appColor,
          buttonTheme: ButtonThemeData().copyWith(
              buttonColor: AppColor.appColor,
              textTheme: ButtonTextTheme.primary),
          fontFamily: "EncodeSans",
        ),
        child: layout());
  }

  Widget layout() {
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isLoading != null && isLoading) {
          callApi();
          return new LoadingScreen();
        } else if (isLoading != null && !isLoading) {
          return layoutMain();
        }
      } else {
        return new ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return new NoInternetScreen(
        onPressedRetyButton: () {
          internetConnection();
        },
      );
    }
    return new Scaffold(
      body: new Center(
        child: new SpinKitThreeBounce(
          color: AppColor.appColor,
          size: 30.0,
        ),
      ),
    );
  }

  Widget layoutMain() {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text("Select Languages"),
        bottom: new PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: new Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: new Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: new Container(
                height: 48.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  border: Border.all(color: AppColor.white, width: 1.0),
                ),
                child: new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    onChanged: onSearchTextChanged,
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: new InputDecoration.collapsed(
                      hintText: "Search",
                      fillColor: AppColor.white,
                      hintStyle: TextStyle(fontSize: 18.0),
                    ),
                    style: new TextStyle(fontSize: 18.0, color: AppColor.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: bodyLayout(),
    );
  }

  Widget bodyLayout() {
    return ListView(children: <Widget>[
      new Column(
          children: new List<Widget>.generate(
              searchedLanguageList.length != 0 || searchController.text.isNotEmpty
                  ? searchedLanguageList.length
                  : languageList.length, (index) {
        if (searchedLanguageList.length != 0 || searchController.text.isNotEmpty) {
          return new InkWell(
            onTap: () async {
              await getResourceString(searchedLanguageList[index].id.toString());
              setInPreferences(searchedLanguageList[index].id.toString());
              setInPreferencesRtl(searchedLanguageList[index].rtl);
              if (userId != null) {
                if (strPhoneOrEmail != null && strPassword != null) {
                  navigatePushAndRemoveUntil(HomeScreen());
                } else {
                  navigatePushAndRemoveUntil(
                      LoginScreen(type: Constants.FOR_LOGIN));
                }
              } else {
                navigatePushAndRemoveUntil(LoginScreen(type: Constants.FOR_LOGIN));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: languageLayout(searchedLanguageList[index]),
            ),
          );
        }
        return new InkWell(
          onTap: () async {
            await getResourceString(languageList[index].id.toString());
            setInPreferences(languageList[index].id.toString());
            setInPreferencesRtl(languageList[index].rtl);
            if (userId != null) {
              if (strPhoneOrEmail != null && strPassword != null) {
                navigatePushAndRemoveUntil(HomeScreen());
              } else {
                navigatePushAndRemoveUntil(LoginScreen(type: Constants.FOR_LOGIN));
              }
            } else {
              navigatePushAndRemoveUntil(LoginScreen(type: Constants.FOR_LOGIN));
            }
          },
          child: new Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: languageLayout(languageList[index]),
          ),
        );
      }))
    ]);
  }

  Widget languageLayout(LanguageModel model) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: image(model),
              ),
              new Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(
                      left: 10.0, top: 4.0, bottom: 4.0, right: 5.0),
                  width: MediaQuery.of(context).size.width,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      name(model),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              height: 1.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
            ),
          )
        ],
      ),
    );}

  Widget image(LanguageModel model) {
    if (model.image != null && model.image.toString().isNotEmpty) {
      return new Container(
        width: 40.0,
        height: 25.0,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new NetworkImage(
                "https://www.nopcommerce.com/images/flags/" +
                    model.image.toString()),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Container(
      width: 40.0,
      height: 25.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: AssetImage('images/placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget name(LanguageModel model) {
    if (model.name != null && model.name.toString().isNotEmpty) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: 30.0, top: 5.0),
            child: SubTitleText(text: model.name.toString(), maxLine: 2),
          ),
        ],
      );
    }
    return Container();
  }

  onSearchTextChanged(String text) async {
    searchedLanguageList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    languageList.forEach((userDetail) {
      if (userDetail.name.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.name.toLowerCase().contains(text.toLowerCase()))
        searchedLanguageList.add(userDetail);
    });

    setState(() {});
  }

  callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }
    if (isInternet) {
      await getPreferences();
      await getLanguageList();
      isLoading = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  Future getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    strPassword = prefs.getString(Constants.loginpassword);
    strPhoneOrEmail = prefs.getString(Constants.loginUserName);
    userId = prefs.getInt(Constants.prefUserIdKeyInt);
    Constants.checkRTL = prefs.getBool(Constants.prefRTL);
  }

  Future getLanguageList() async {
    Map result = await GetLanguageParser.getLanguageParser(
        "${Config.strBaseURL}languages");
    if (result["errorCode"] == "0") {
      languageList = result["value"];
    } else {
      isError = true;
    }
  }

  Future getResourceString(String languageId) async {
    Constants.progressDialog1(true, context);
    Map result = await LanguageParser.languageParser(
        "${Config.strBaseURL}languages/getallresourcestrings?languagesId=" +
            languageId.toString());
    if (result["errorCode"] == "0") {
      resourceStringList = result["value"];
      Constants.progressDialog1(false, context);
    } else {
      Constants.progressDialog1(false, context);
      isError = true;
    }
  }

  Future setInPreferences(String languageId) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.prefLanguageId, languageId);
  }

  Future setInPreferencesRtl(bool rtl) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.prefRTL, rtl);
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
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
  navigatePushAndRemoveUntil(Widget page) async {
    await Navigator.pushAndRemoveUntil(
        context,
        AnimationPageRoute(page: page, context: context),
            (Route<dynamic> route) => false);
  }
}
