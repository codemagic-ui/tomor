import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/RewardPointModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/DownloadAbleProductListParser.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';

import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadableProductScreen extends StatefulWidget {
  final int userId;

  DownloadableProductScreen({this.userId});

  @override
  _DownloadableProductScreenState createState() =>
      _DownloadableProductScreenState();
}

class _DownloadableProductScreenState extends State<DownloadableProductScreen> {
  RewardPointModel downloadAbleProducts;

  bool isInternet;
  bool isError = false;
  bool isLoading;
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
          title: Text(Constants.getValueFromKey("Account.DownloadableProducts", resourceData)),
        ),
        body: new SafeArea(
          child: downloadAbleProducts.downloadAbleProductList.length != null &&
                  downloadAbleProducts.downloadAbleProductList.length != 0
              ? new ListView.builder(
                  itemCount: downloadAbleProducts.downloadAbleProductList.length,
                  padding: EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0),
                  itemBuilder: (BuildContext context, int position) {
                    return Container(
                      height: 150.0,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Body2Text(
                                  maxLine: 1,
                                  text: Constants.getValueFromKey("Admin.Affiliates.Orders.CustomOrderNumber", resourceData) +
                                      downloadAbleProducts
                                          .downloadAbleProductList[position]
                                          .orderProductId
                                          .toString()),
                              SizedBox(
                                height: 3.0,
                              ),
                              Body1Text(
                                maxLine: 1,
                                text:
                                    "${formatDate(DateTime.parse(downloadAbleProducts.downloadAbleProductList[position].orderProductDate.toString()), [
                                  DD,
                                  ', ',
                                  MM,
                                  ' ',
                                  d,
                                  ',',
                                  yyyy
                                ])}",
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Body2Text(
                                maxLine: 1,
                                text: downloadAbleProducts
                                    .downloadAbleProductList[position]
                                    .orderProductName
                                    .toString(),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Body2Text(
                                maxLine: 1,
                                text: "Size: 8",
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Body2Text(
                                      maxLine: 1,
                                      text: "Color: Red",
                                    ),
                                  ),
                                  new Body2Text(
                                    maxLine: 1,
                                    text: Constants.getValueFromKey("Admin.DownloadableProducts.Downloaded", resourceData)+": " +
                                        downloadAbleProducts
                                            .downloadAbleProductList[position]
                                            .orderProductDownload
                                            .toString(),
                                  ),
                                ],
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
                      "images/downloadproduct.png",
                      height: 170.0,
                      width: 170.0,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                     Constants.getValueFromKey("admin.affiliates.orders.customordernumber.noproduct", resourceData),
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
      await getDownloadAbleProduct();
      isLoading = false;
      setState(() {});
    }
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future getDownloadAbleProduct() async {
    Map result = await DownloadAbleProductListParser.callApi(
        "${Config.strBaseURL}customers/getdownloadableproducts?customerId=" +
            widget.userId.toString());
    if (result["errorCode"] == "0") {
      downloadAbleProducts = result["value"];
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
}
