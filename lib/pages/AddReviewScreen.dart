import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/ProductReviewModel.dart';
import 'package:i_am_a_student/models/productDetail/ProductDetailModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/ReviewListParser.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
//import 'package:i_am_a_student/utils/Strings.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReviewScreen extends StatefulWidget {
  final String productId;
  final String productImage;
  final ProductDetailModel getProductDetailModel;

  AddReviewScreen(
      {this.productId, this.productImage, this.getProductDetailModel});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  bool isError = false;
  bool isInternet;
  bool isLoading;

  SharedPreferences prefs;
  double ratingByUser = 0;
  int customerId;

  List<ProductReviewModel> reviewList = new List<ProductReviewModel>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController reviewTitleController = new TextEditingController();
  TextEditingController reviewController = new TextEditingController();
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
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: false,
              title: new TitleText(
                text: Constants.getValueFromKey("nop.AddReviewScreen.addReview", resourceData),
                color: Colors.white,
              ),
              leading: new InkWell(
                child: new Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: new FlexibleSpaceBar(
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.network(
                      widget.productImage,
                      color: Colors.black26,
                      colorBlendMode: BlendMode.darken,
                      fit: BoxFit.cover,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Center(
                            child: new TitleText(
                                color: Colors.white,
                                text: widget.getProductDetailModel.productTitle
                                    .toString())),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(
                                  top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Body1Text(
                                    text:
                                        "${widget.getProductDetailModel.approvedRatingSum}",
                                    color: AppColor.white,
                                  ),
                                  SizedBox(width: 3.0),
                                  Icon(
                                    Icons.star,
                                    size: 14.0,
                                    color: AppColor.white,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Body2Text(
                              text: Constants.getValueFromKey("nop.AddReviewScreen.basedOn", resourceData),
                              color: AppColor.white,
                            ),
                            Body2Text(
                              text: "${widget.getProductDetailModel.approvedTotalReviews} "+ Constants.getValueFromKey("nop.AddReviewScreen.reviews", resourceData),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            new SliverToBoxAdapter(
                child: new Stack(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(18.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new TitleText(
                        text: Constants.getValueFromKey("Reviews.Write", resourceData),
                        align: TextAlign.start,
                        color: AppColor.appColor,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new RatingBar(
                            color: AppColor.appColor,
                            rating: ratingByUser,
                            size: 45.0,
                            onRatingChanged: (rating) {
                              setState(() {
                                //change rating
                                ratingByUser = rating;
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      new Text(
                        Constants.getValueFromKey("Reviews.Overview.AddNew", resourceData),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.body2,
                      ),
                      new Padding(padding: new EdgeInsets.only(top: 30.0)),
                      new Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Theme(
                              data: new ThemeData(
                                  primaryColor: AppColor.appColor,
                                  accentColor: AppColor.appColor,
                                  textSelectionColor: AppColor.appColor),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  new TextFormField(
                                    controller: reviewTitleController,
                                    validator: (value) {
                                      return Validator.validateFormField(
                                          value,
                                          Constants.getValueFromKey("Reviews.Fields.Title.Required", resourceData),
                                          "",
                                          Constants.NORMAL_VALIDATION);
                                    },
                                    decoration: InputDecoration(
                                      labelText: Constants.getValueFromKey("Reviews.Fields.Title", resourceData),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                    ),
                                  ),
                                  new Padding(
                                      padding: new EdgeInsets.only(top: 27.0)),
                                ],
                              ),
                            ),
                            new Theme(
                              data: new ThemeData(
                                  primaryColor: AppColor.appColor,
                                  accentColor: AppColor.appColor,
                                  textSelectionColor: AppColor.appColor),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  new TextFormField(
                                    controller: reviewController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    validator: (value) {
                                      return Validator.validateFormField(
                                          value,
                                          Constants.getValueFromKey("Reviews.Fields.ReviewText.Required", resourceData),
                                          "",
                                          Constants.NORMAL_VALIDATION);
                                    },
                                    decoration: InputDecoration(
                                      labelText: Constants.getValueFromKey("Reviews.Write", resourceData),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                    ),
                                  ),
                                  new Padding(
                                      padding: new EdgeInsets.only(top: 27.0)),
                                ],
                              ),
                            ),
                            RaisedBtn(
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    if (ratingByUser != 0) {
                                      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                                      String strJson =
                                          ProductReviewModel.addReview(
                                              widget.productId.toString(),
                                              reviewTitleController.text,
                                              reviewController.text,
                                              ratingByUser);
                                      await getReviewPost(strJson);
                                    } else {
                                      Fluttertoast.showToast(msg: Constants.getValueFromKey("nop.AddReviewScreen.giveRate", resourceData));
                                    }
                                  }
                                },
                                text: Constants.getValueFromKey("Reviews.SubmitButton", resourceData))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      reviewList.length != 0
                          ? new TitleText(
                              text: Constants.getValueFromKey("Reviews.ExistingReviews", resourceData),
                              align: TextAlign.start,
                              color: AppColor.appColor,
                            )
                          : Container(),
                      ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: reviewList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 3.0),
                                  new Container(
                                    margin: EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: new Body2Text(
                                                    maxLine: 2,
                                                    text: reviewList[index]
                                                        .mTitle
                                                        .toString())),
                                            new Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5.0),
                                              child: new RatingBar(
                                                size: 20.0,
                                                rating: double.parse(
                                                    reviewList[index]
                                                        .mRating
                                                        .toString()),
                                                color: AppColor.appColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Body1Text(
                                          text: reviewList[index]
                                              .mReviewText
                                              .toString(),
                                          maxLine: 3,
                                        ),
                                        SizedBox(height: 8.0),
                                        Body1Text(
                                            maxLine: 1,
                                            text: Constants.getValueFromKey("Reviews.From", resourceData)+": " +
                                                reviewList[index]
                                                    .mCustomerName
                                                    .toString() +
                                                " | ${Constants.getValueFromKey("Reviews.Date", resourceData)}: " +
                                                reviewList[index]
                                                    .mWrittenOnStr
                                                    .toString()),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: SmallText(
                                                    maxLine: 1,
                                                    text: Constants.getValueFromKey("Reviews.Helpfulness.WasHelpful?", resourceData))),
                                            IconButton(
                                                icon: Icon(Icons.thumb_up),
                                                onPressed: () async {
                                                  Constants.progressDialog(
                                                      true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                                                  if (reviewList[index]
                                                          .mReviewId !=
                                                      null) {
                                                    await likeApi(
                                                        reviewList[index]
                                                            .mReviewId
                                                            .toString());
                                                  }
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.thumb_down),
                                                onPressed: () async {
                                                  Constants.progressDialog(
                                                      true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                                                  if (reviewList[index]
                                                          .mReviewId !=
                                                      null) {
                                                    await disLikeApi(
                                                        reviewList[index]
                                                            .mReviewId
                                                            .toString());
                                                  }
                                                }),
                                            Body1Text(
                                                maxLine: 1,
                                                text: "(" +
                                                    reviewList[index]
                                                        .mHelpfulYesTotal
                                                        .toString() +
                                                    "/" +
                                                    reviewList[index]
                                                        .mHelpfulNoTotal
                                                        .toString() +
                                                    ")"),
                                            SizedBox(width: 8.0),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      await getSharedPref();
      await getReviewList();
      isLoading = false;
      setState(() {});
    }
  }

  Future getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future likeApi(String reviewId) async {
    Map result = await ReviewListParser.callApiForLike(
        "${Config.strBaseURL}products/setproductreviewhelpfulness?customerId=" +
            customerId.toString() +
            "&productReviewId=" +
            reviewId +
            "&washelpful=true");
    if (result["errorCode"] == 0) {
      await getReviewList();
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      String error = result['value'];
      Fluttertoast.showToast(msg: error);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      String error = result['value'];
      Fluttertoast.showToast(msg: error);
    }
  }

  Future disLikeApi(String reviewId) async {
    Map result = await ReviewListParser.callApiForLike(
        "${Config.strBaseURL}products/setproductreviewhelpfulness?customerId=" +
            customerId.toString() +
            "&productReviewId=" +
            reviewId +
            "&washelpful=false");
    if (result["errorCode"] == 0) {
      await getReviewList();
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      String error = result['value'];
      Fluttertoast.showToast(msg: error);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      String error = result['value'];
      Fluttertoast.showToast(msg: error);

    }
  }

  Future getReviewList() async {
    Map result = await ReviewListParser.callApi(
        "${Config.strBaseURL}products/productreviewslist?productId=" +
            widget.productId.toString() +
            "&customerId=" +
            customerId.toString());
    if (result["errorCode"] == "0") {
      reviewList = result["value"];
    } else {
//      String error = result["msg"];
      isError = true;
    }
  }

  Future getReviewPost(String strJson) async {
    Map result = await ReviewListParser.callApiPostReview(
        "${Config.strBaseURL}products/addproductreviews?customerId=" +
            customerId.toString(),
        strJson);
    if (result["errorCode"] == 0) {
      await getReviewList();
      String msg = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(msg: msg);
      await getReviewList();
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      String msg = result["value"];
      Fluttertoast.showToast(msg: msg);
      isError = true;
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }
}
