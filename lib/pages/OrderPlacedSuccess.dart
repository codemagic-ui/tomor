import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/OrderInformationScreen.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPlacedSuccess extends StatefulWidget {
  final String orderId;

  OrderPlacedSuccess(this.orderId);

  @override
  _OrderPlacedSuccessState createState() => _OrderPlacedSuccessState();
}

class _OrderPlacedSuccessState extends State<OrderPlacedSuccess> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  SharedPreferences prefs;

  Map resourceData;
  @override
  void initState() {
    internetConnection();
    getSharedPref();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  Future  getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      return layoutMain();
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () {},
      );
    } else {
      return Scaffold(
        body: Center(
          child: SpinKitThreeBounce(color: AppColor.appColor,size: 30.0,),
        ),
      );
    }
  }



  Widget layoutMain() {
    return WillPopScope(
      onWillPop: () {
        return navigatePushReplacement(HomeScreen());
      },
      child: Directionality(
        textDirection: Constants.checkRTL != null && Constants.checkRTL
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: Center(
            child: new ListView(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.all(8.0),
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    Constants.getValueFromKey("nop.Checkout.Success.subTitle", resourceData),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                Image.asset(
                  ImageStrings.imgConfirmOrder,
                  height: 150,
                  width: 150,
                ),
                SizedBox(
                  height: 35.0,
                ),

                Body2Text(
                  text: Constants.getValueFromKey("Admin.Configuration.Settings.Order.OrderIdent", resourceData)+": ${widget.orderId}",
                  color: AppColor.appColor,
                  align: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),

                Body2Text(
                    text: Constants.getValueFromKey("nop.Checkout.Success.strDescription", resourceData),
                    color: Colors.green,
                    align: TextAlign.center),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: (){
                    navigatePushReplacement(OrderInformationScreen(orderItemId: widget.orderId,isFrom: "OrderPlacedSuccess",));

                  },
                  child: Text(Constants.getValueFromKey("PageTitle.OrderDetails", resourceData),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0,
                          decoration: TextDecoration.underline,
                          color: AppColor.appColor)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 60.0,
                      right: 60.0),
                  child: RaisedBtn(
                    onPressed: () {
                      navigatePushReplacement(HomeScreen());
                    },
                    text: Constants.getValueFromKey("nop.checkout.success.strdone", resourceData).toUpperCase(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
