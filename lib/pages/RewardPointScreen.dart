import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/RewardPointModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/RewardListParser.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardPointScreen extends StatefulWidget {
  @override
  _RewardPointScreenState createState() => _RewardPointScreenState();
}

class _RewardPointScreenState extends State<RewardPointScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  RewardPointModel rewardPointListModel;

  int userLoginId;

  Map resourceData;

  @override
  void initState() {
    internetConnection();
    getUserLoginId();
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
          title: Text(Constants.getValueFromKey("admin.customers.rewardpoints", resourceData)),
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(10.0),
              color: AppColor.appColor,
              height: 250,
              child: Row(
                children: <Widget>[

                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TitleText(text: Constants.getValueFromKey("account.rewardpointscreen.appname", resourceData), color: Colors.white),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          Constants.getValueFromKey("admin.customers.rewardpoints", resourceData),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),

                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Body2Text(
                              align: TextAlign.center,
                              color: Colors.white,
                              maxLine: 3,
                              text:Constants.getValueFromKey("account.rewardpointscreen.pointshortlable", resourceData)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      "images/rewardpiont.png",
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                ],
              ),
            ),
            new ListView(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.only(top: 210),
              children: <Widget>[
                new Container(
                  height: 170.0,
                  child: new Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          TitleText(
                            text: Constants.getValueFromKey("account.rewardpointscreen.currentpointlabel", resourceData),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            rewardPointListModel.rewardPoints.toString() +
                                " "+Constants.getValueFromKey("myaccount.rewardpoints.fields.points", resourceData)+" " +
                                "(" +
                                rewardPointListModel.rewardPointsAmount
                                    .toString() +
                                ")",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline.copyWith(
                                fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Flexible(
                            child: Body1Text(
                                text:
                                Constants.getValueFromKey("account.rewardpointscreen.pointshortlable.point", resourceData)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                new ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: rewardPointListModel.rewardPointProductList.length,
                    padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0),
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                        height: 100.0,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Body2Text(
                                          maxLine: 1,
                                          text: rewardPointListModel
                                              .rewardPointProductList[position]
                                              .rewardListMessage
                                              .toString()),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Body1Text(
                                        maxLine: 1,
                                        text: rewardPointListModel
                                            .rewardPointProductList[position]
                                            .rewardListDate
                                            .toString(),
                                        color: Colors.blueAccent,
                                      ),
                                    ],
                                  ),
                                ),
                                TitleText(
                                    text: rewardPointListModel
                                        .rewardPointProductList[position]
                                        .rewardListPoints
                                        .toString(),
                                    color: Colors.green),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      //todo call api to get searchList
      await getRewardPointList();
      isLoading = false;
      setState(() {});
    }
  }

  getUserLoginId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userLoginId = sharedPreferences.getInt(Constants.prefUserIdKeyInt);
    String jsonData = sharedPreferences.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future getRewardPointList() async {
    try {
      Map result = await RewardListParser.callApi(
          "${Config.strBaseURL}orders/getrewardpoint?customerId=" +
              userLoginId.toString());
      if (result["errorCode"] == "0") {
        rewardPointListModel = result["value"];
      } else {
        isError = true;
      }
      isLoading = false;
    } catch (e) {
      print(e);
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }
}
