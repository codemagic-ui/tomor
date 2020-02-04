import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/RewardPointModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/ProductReviewListParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';

import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProductReviewScreen extends StatefulWidget {
  final int userId;

  MyProductReviewScreen({this.userId});

  @override
  _MyProductReviewScreenState createState() => _MyProductReviewScreenState();
}

class _MyProductReviewScreenState extends State<MyProductReviewScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  RewardPointModel productReview;
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
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(Constants.getValueFromKey("PageTitle.CustomerProductReviews", resourceData)),
        ),
        body: new SafeArea(
          child: productReview.productReviewList.length != null &&
                  productReview.productReviewList.length != 0
              ? new ListView.builder(
                  itemCount: productReview.productReviewList.length,
                  padding: EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0),
                  itemBuilder: (BuildContext context, int position) {
                    return new Container(
                      height: 110.0,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  Expanded(
                                    child: new Body2Text(
                                        maxLine: 1,
                                        text: productReview
                                            .productReviewList[position]
                                            .reviewProductName),
                                  ),
                                  new RatingBar(
                                    size: 15.0,
                                    rating: double.parse(productReview
                                        .productReviewList[position]
                                        .reviewProductRating
                                        .toString()),
                                    color: AppColor.appColor,
                                  )
                                ],
                              ),
                              new SizedBox(
                                height: 3.0,
                              ),
                              new Body1Text(
                                maxLine: 1,
                                text: productReview
                                    .productReviewList[position].reviewProductDate
                                    .toString(),
                                color: Colors.blueAccent,
                              ),
                              new SizedBox(
                                height: 8.0,
                              ),
                              new Flexible(
                                child: SmallText(
                                    maxLine: 3,
                                    text: productReview
                                        .productReviewList[position]
                                        .reviewProductDescription
                                        .toString()),
                              ),
                              new SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "images/noreview.png",
                      height: 170.0,
                      width: 170.0,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),

                    Text(
                      Constants.getValueFromKey("nop.MyAccountScreen.myProductReviewScreen.noReview", resourceData),
                      maxLines: 6,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      //todo call api to get searchList
      await getPreferences();
      await getProductReviewList();
      isLoading = false;
      setState(() {});
    }
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future getProductReviewList() async {
    Map result = await ProductReviewListParser.callApi(
        "${Config.strBaseURL}products/getcustomerproductreviews?customerId=" +
            widget.userId.toString());
    if (result["errorCode"] == "0") {
      productReview = result["value"];
    } else {
      isError = true;
    }
    isLoading = false;
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
}
