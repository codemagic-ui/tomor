import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Constants.dart';

import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;

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
          internetConnection();
        },
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: SpinKitThreeBounce(
            color: AppColor.appColor,
            size: 30.0,
          ),
        ),
      );
    }
  }

  Widget layoutMain() {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("News"),
      ),
      body: new SafeArea(
        child: new ListView.builder(
            itemCount: 10,
            padding: EdgeInsets.only(
                top: 8.0,
                bottom: 8.0),
            itemBuilder: (BuildContext context, int position) {
              return Container(
                height: 110.0,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Body2Text(
                            maxLine: 1, text: "New Online Store is Open "),
                        SizedBox(
                          height: 3.0,
                        ),
                        Body1Text(
                          maxLine: 1,
                          text: "- Thursday,july 26,2018",
                          color: Colors.blueAccent,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Flexible(
                          child: SmallText(
                              maxLine: 3,
                              text:
                                  "Online shopping is the process consumers go through to purchase products or services over the Internet. You can edit this in the admin site."),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
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
