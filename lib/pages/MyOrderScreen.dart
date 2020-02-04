import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/MyOrderProductListModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/OrderInformationScreen.dart';
import 'package:i_am_a_student/parser/OrderListParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderScreen extends StatefulWidget {
  final isFrom;

  MyOrderScreen({this.isFrom});

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  List<MyOrderProductListModel> myOrderItemList =
      new List<MyOrderProductListModel>();

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
      child: WillPopScope(
        onWillPop: () {
          widget.isFrom == "OrderPlacedSuccess"
              ? navigatePushReplacement(HomeScreen())
              :  Navigator.pop(context);
          return null;
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(Constants.getValueFromKey("Account.CustomerOrders", resourceData)),
          ),
          body: myOrderItemList.length != null && myOrderItemList.length != 0
              ? listView()
              : noOrders(),
        ),
      ),
    );
  }

  Widget noOrders() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image.asset(
          "images/no_orders.png",
          height: 170.0,
          width: 170.0,
        ),
        new SizedBox(
          height: 40.0,
        ),

        new Text(
          Constants.getValueFromKey("Account.CustomerOrders.NoOrders", resourceData)+"!",
          maxLines: 6,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title.copyWith(color: Colors.red),
        ),
      ],
    );
  }

  Widget listView() {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: myOrderItemList.length,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new InkWell(
              onTap: () {
                navigatePush(OrderInformationScreen(
                  orderItemId: myOrderItemList[index].orderNumber.toString(),
                ));
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text(
                          Constants.getValueFromKey("Account.CustomerOrders.OrderNumber", resourceData)+": " +
                              myOrderItemList[index].orderNumber.toString(),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subhead.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      Icon(
                        Icons.sort,
                        color: AppColor.appColor,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      new TitleText(
                        text: Constants.getValueFromKey("Account.CustomerOrders.OrderDetails", resourceData),
                        color: AppColor.appColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),

                  Body1Text(
                      maxLine: 1,
                      text: Constants.getValueFromKey("Account.CustomerOrders.OrderStatus", resourceData)+": " +
                          myOrderItemList[index].orderItemStatus.toString()),
                  SizedBox(height: 10.0),
                  date(index),
                  SizedBox(height: 10.0),
                  new Body2Text(
                    align: TextAlign.end,
                    text: Constants.getValueFromKey("Admin.SalesReport.Incomplete.Total", resourceData)+": " +myOrderItemList[index].orderItemProductList[0].orderCurrency.toString()+
                        myOrderItemList[index].orderTotal.toString(),
                    color: AppColor.appColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      //todo call api to get searchList
      try {
        await getPreferences();
        await orderListCallApi();
      } catch (e) {
        print(e);
        isError = true;
        isLoading = false;
      }
      isLoading = false;
      setState(() {});
    }
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future orderListCallApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(Constants.prefUserIdKeyInt);
    Map result = await OrderListParser.callApi(
        "${Config.strBaseURL}orders?customer_id=$userId");
    if (result["errorCode"] == "0") {
      myOrderItemList = result['value'];
      myOrderItemList = myOrderItemList.reversed.toList();
    } else {
      isError = true;
    }
    isLoading = false;
  }

  Widget date(int index) {
    return new Body1Text(
      text: Constants.getValueFromKey("Order.OrderDate", resourceData)+": " + myOrderItemList[index].orderItemDate.toString(),
    );
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
