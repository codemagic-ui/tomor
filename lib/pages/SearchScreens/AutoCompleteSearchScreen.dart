import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductDetailScreen.dart';
import 'package:i_am_a_student/pages/SearchScreens/SearchResultScreen.dart';
import 'package:i_am_a_student/parser/SearchProductParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoCompleteSearchScreen extends StatefulWidget {
  @override
  _AutoCompleteSearchScreenState createState() => _AutoCompleteSearchScreenState();
}

class _AutoCompleteSearchScreenState extends State<AutoCompleteSearchScreen> {
  bool isInternet;
  bool isError = false;
  SharedPreferences prefs;
  TextEditingController searchTextController = new TextEditingController();

  List<ProductListModel> searchedList = new List<ProductListModel>();
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
      return layoutMain();
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () async {
          isInternet = await Constants.isInternetAvailable();
          setState(() {});
        },
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: <Widget>[
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 4,
              child: Center(
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColor.appColor,
                  ),
                  child: TextField(
                    autofocus: true,
                    controller: searchTextController,
                    textInputAction: TextInputAction.search,
                    decoration: new InputDecoration.collapsed(
                      hintText: Constants.getValueFromKey(
                          "Common.Search", resourceData),
                      hintStyle: TextStyle(fontSize: 18.0),
                    ),
                    onSubmitted: (value) {
                      if (value.length > 2) {

                        navigatePushReplacement(SearchResultScreen(searchText: searchTextController.text.toString(),));
                      } else {
                        Fluttertoast.showToast(
                            msg: Constants.getValueFromKey(
                                "nop.autoCompleteSearch.searchLenght", resourceData));
                      }
                    },
                    onChanged: (value) {
                      if (value.length > 2) {
                        callApi(value);
                      }
                    },
                    style: TextStyle(fontSize: 18.0, color: AppColor.black),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: !isError
            ? ListView(
                children: List<Widget>.generate(searchedList.length, (int index) {
                  final ProductListModel model = searchedList[index];
                  return new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.only(
                            top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                        leading: CachedNetworkImage(
                          imageUrl: model.image.toString(),
                          placeholder: (context, url) => Image.asset(
                            ImageStrings.imgPlaceHolder,
                            height: 50.0,
                            width: 50.0,
                          ),
                          height: 50.0,
                          width: 50.0,
                        ),
                        title: new Body1Text(
                          text: model.name,
                        ),
                        subtitle: price(model),
                        onTap: () {
                          navigatePush(ProductDetailScreen(
                            productId: model.id,
                          ));
                        },
                      ),
                      new Container(
                        height: 1.0,
                        color: Colors.grey,
                      )
                    ],
                  );
                }),
              )
            : Container(),
      ),
    );
  }

  price(ProductListModel model) {
    String price;
    if (model.price != null && model.price.toString().isNotEmpty) {
      price = model.price.toString();
    }
    if (model.tierPriceModelList.length > 0) {
      price = "${Constants.getValueFromKey("Admin.System.QueuedEmails.Fields.From", resourceData)}${model.tierPriceModelList.last.price.toString()}";
    }
    if (price != null) {
      return Body2Text(
        color: AppColor.appColor,
        text: price,
        maxLine: 1,
      );
    }
    return Container();
  }

  Future callApi(String searchText) async {
    Map result = await SearchProductParser.callApi(
        "${Config.strBaseURL}products/search?parameters=" + searchText.toString());
    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      isError = false;
    } else {
      isError = true;
    }
    setState(() {});
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    setState(() {});

    if(isInternet){
    prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);}
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePush(Widget page) async {
      await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePushAndRemoveUntil(Widget page) async {
     await Navigator.pushAndRemoveUntil(
        context,
        AnimationPageRoute(page: page, context: context),
        (Route<dynamic> route) => false);
  }
}
