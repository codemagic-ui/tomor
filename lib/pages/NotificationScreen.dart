import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Constants.dart';

import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  var subscription;

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if (!isError) {
        return layoutMain();
      }else{
        return ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () async {
          isInternet = await Constants.isInternetAvailable();
          setState(() {});
        },
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: SpinKitThreeBounce(color: AppColor.appColor,size: 30.0,),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    callApi();
  }

  Widget layoutMain() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Notification"),
        ),
        body: new SafeArea(
          child: new ListView.builder(
              itemCount: 10,
              padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0),
              itemBuilder: (BuildContext context, int position) {
                return Container(
                  height: 90.0,
                  child: Card(
                    child: Row(children: <Widget>[
                      Padding(
                        padding:   EdgeInsets.all(10.0),
                        child: new Container(
                          width: 80.0,
                          child: new ClipRRect(
                            borderRadius: new BorderRadius.only(
                                topLeft:
                                Radius.circular(4.0),
                                bottomLeft:
                                Radius.circular(4.0)),
                            child: CachedNetworkImage(
                              imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyjESVY64dum7y3o0MD9OpRTVABIuVXD8xjppAZMsqYM_sJG32",

                              placeholder:(context, url) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Body2Text(
                                maxLine: 1, text: "Product Deliverd :"),
                            SizedBox(
                              height: 3.0,
                            ),
                            SmallText(
                              maxLine: 1,
                              text: "Thursday,july 26,2018 8:30 am",
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Flexible(
                              child: Body1Text(
                                  maxLine: 2,
                                  text:
                                  "Online shopping is the process consumers go through to purchase products or services over the Internet. You can edit this in the admin site."),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ),
                    ],

                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      isLoading = true;
      //todo call api to get searchList
      isLoading = false;
      setState(() {});
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    var connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isInternet = await Constants.isInternetAvailable();
      if (isLoading == null) {
        isLoading = true;
      }
      setState(() {});
    });
  }

  navigatePush(Widget page) async {

    await Navigator.push(context, AnimationPageRoute(page: page,context: context));
  }

  navigatePushReplacement(Widget page) async {
     await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page,context: context));
  }
}
