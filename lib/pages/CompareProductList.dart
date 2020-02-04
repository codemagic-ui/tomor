import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';

class CompareProductList extends StatefulWidget {
  @override
  _CompareProductListState createState() => _CompareProductListState();
}

class _CompareProductListState extends State<CompareProductList> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  var subscription;

  @override
  void initState() {
    super.initState();
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if(isLoading != null && isLoading){
        callApi();
      }
      if (!isError) {
        return layoutMain();
      } else {
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

  Widget layoutMain() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare Products"),
      ),
      resizeToAvoidBottomPadding: false,
      body: isLoading != null && isLoading
          ? Center(child: SpinKitThreeBounce(color: AppColor.appColor,size: 30.0,),)
          : Row(
              children: <Widget>[
                Text("a"),
                Text("a"),
              ],
            ),
    );
  }

  oldPriceTextNewArrival(int index) {
    if (1000 < 5000) {
      if (1000 > 0) {
        return new RichText(
          maxLines: 1,
          text: new TextSpan(
            text: "\$ ${1000}",
            style: new TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                fontSize: 12.0),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
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
    isLoading = isInternet;
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isInternet = await Constants.isInternetAvailable();
      isLoading = isInternet;
      setState(() {});
    });
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
