import 'package:flutter/material.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  bool isInternet;
  bool isError = false;
  bool isLoading;

  @override
  void initState() {
    internetConnection();
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Add Product",
        ),
      ),
      body: Container(),
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet != null && isInternet) {
      isLoading = false;
      setState(() {});
    }
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
