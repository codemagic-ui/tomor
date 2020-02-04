import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:i_am_a_student/pages/WebScreen.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/pages/ContactUsScreen.dart';
import 'package:i_am_a_student/pages/DownloadableProductScreen.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/MyOrderScreen.dart';
import 'package:i_am_a_student/pages/MyProductReviewScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/PasswordScreen.dart';
import 'package:i_am_a_student/pages/EditProfileScreen.dart';
import 'package:i_am_a_student/pages/MyAddress.dart';
import 'package:i_am_a_student/pages/RewardPointScreen.dart';
import 'package:i_am_a_student/pages/SplashScreen.dart';
import 'package:i_am_a_student/pages/WishListScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/MyAccoutDetailParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LanguageScreen.dart';
import 'LoginScreen.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  String strFirstName = "";
  String strLastName = "";
  var firstNameTextController = new TextEditingController();
  var lastNameTextController = new TextEditingController();
  SharedPreferences prefs;
  int userId;
  Function hp;
  Function wp;
  UserModel userModel;
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
        onPressedRetyButton: () async {
          internetConnection();
        },
      );
    }
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

  Widget layoutMain() {
    hp = Screen(MediaQuery.of(context).size).hp;
    wp = Screen(MediaQuery.of(context).size).wp;
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            new Container(
              height: hp(30),
              child: Stack(
                children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(ImageStrings.imgBg2),
                            fit: BoxFit.cover)),
                  ),
                  new Container(
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userModel.strImageUrl != null
                            ? NetworkImage(userModel.strImageUrl)
                            : AssetImage("images/user.png")),
                  ),
                ],
              ),
            ),
            new SizedBox(
              height: 10.0,
            ),
            new HeadlineText(
              text: strFirstName.toString() + " " + strLastName.toString(),
              align: TextAlign.center,
            ),
            new FlatBtn(
                onPressed: () async {
                 await Navigator.push(context, AnimationPageRoute(page: EditProfileScreen(), context: context));
                 setState(() {
                   isLoading=true;
                 });
                },
                text: Constants.getValueFromKey("nop.EditProfileScreen.title.myAccount", resourceData)),
            new SizedBox(
              height: 20.0,
            ),
            new ListTile(
              onTap: () {
                navigatePush(MyOrderScreen());
              },
              title: Body1Text(text: Constants.getValueFromKey("Admin.Customers.Customers.Orders", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.move_to_inbox,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(RewardPointScreen());
              },
              title: Body1Text(text: Constants.getValueFromKey("Account.RewardPoints", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(WishListScreen());
              },
              title: Body1Text(text: Constants.getValueFromKey("Wishlist", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(DownloadableProductScreen(userId: userId));
              },
              title: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Products.Download", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.file_download,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(MyProductReviewScreen(userId: userId));
              },
              title: Body1Text(text: Constants.getValueFromKey("PageTitle.CustomerProductReviews", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.star_half,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(MyAddress());
              },
              title: Body1Text(text: Constants.getValueFromKey("Account.CustomerAddresses", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.room,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(PasswordScreen(
                    type: Constants.CHANGE_PASSWORD,appbarTitle: Constants.getValueFromKey("Admin.Configuration.EmailAccounts.Fields.Password.Change", resourceData), isFromLoginPage: true));
              },
              title: Body1Text(text: Constants.getValueFromKey("Admin.Configuration.EmailAccounts.Fields.Password.Change", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.vpn_key,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(LanguageScreen());
              },
              title: Body1Text(text: Constants.getValueFromKey("nop.MyAccountScreen.title.myAccount.language", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.language,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(10.0),
              child: Body2Text(text: Constants.getValueFromKey("nop.MyAccountScreen.title.rateUs", resourceData)),
            ),
            new ListTile(
              onTap: () {
                LaunchReview.launch(androidAppId: "com.fourdeve.tomoroptions",);
              },
              title: Body1Text(text: Constants.getValueFromKey("nop.MyAccountScreen.title.rateUs", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.rate_review,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: (){
                navigatePush(WebScreen("http://defaultnop420.forefrontinfotech.com/about-us"));
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (BuildContext context) => WebScreen("http://defaultnop420.forefrontinfotech.com/about-us")));
              },
              title: Body1Text(text: Constants.getValueFromKey("nop.MyAccountScreen.title.aboutUs", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(ContactUsScreen());
              },
              title: Body1Text(text: Constants.getValueFromKey("pagetitle.contactus", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.contacts,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                navigatePush(WebScreen("http://defaultnop420.forefrontinfotech.com/privacy-notice"));
             /*   Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => WebScreen("http://defaultnop420.forefrontinfotech.com/privacy-notice")));*/
              },
              title: Body1Text(text: Constants.getValueFromKey("nop.MyAccountScreen.title.tearmAndConditions", resourceData)),
              leading: Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: AppColor.appColor, shape: BoxShape.circle),
                child: Icon(
                  Icons.view_list,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            new ListTile(
              onTap: sampleDialog,
              title: TitleText(
                text: Constants.getValueFromKey("Admin.Header.Logout", resourceData),
                color: AppColor.appColor,
              ),
              leading: Container(
                child: Icon(
                  Icons.exit_to_app,
                  color: AppColor.appColor,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      await getSharedPref();
      await getAccountDetail();
      isLoading = false;
      setState(() {});
    }
  }

  Future getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future getAccountDetail() async {
    Map result = await MyAccountDetailParser.callApi("${Config.strBaseURL}customers/$userId");
    if (result["errorCode"] == "0") {
      userModel = result["value"];

      if (userModel.strCustomerFirstName != null) {
        strFirstName = userModel.strCustomerFirstName;
      }

      if (userModel.strCustomerLastName != null) {
        strLastName = userModel.strCustomerLastName;
      }

      if (strFirstName != null) {
        firstNameTextController.text = strFirstName;
      }

      if (strLastName != null) {
        lastNameTextController.text = strLastName;
      }
    } else {
      isError = true;
    }
    isLoading = false;
  }

  Future getShoppingCartItemNumber() async {
    Map result = await AddProductIntoCartParser.callApiForGetCartItemTotal("${Config.strBaseURL}shopping_cart_items/" + userId.toString());
    if (result["errorCode"] == "0") {
      setState(() {
        Constants.cartItemCount = result["value"];
      });
    } else {
      isError = true;
    }
    isLoading = false;
  }

  void sampleDialog() {
    showDialog(
        context: context,builder: (_) => AssetGiffyDialog(
              image: Image.asset('images/logout.png', fit: BoxFit.fitHeight ,alignment: Alignment.center,),
              buttonOkText: Text(Constants.getValueFromKey("Common.Yes",resourceData)) ,
              onCancelButtonPressed: onCancel ,
              onOkButtonPressed: onOk,

              buttonCancelText: Text(Constants.getValueFromKey("Common.No",resourceData)),
              title: Text(Constants.getValueFromKey("nop.MyAccountScreen.title.logOutSubTitle", resourceData)),
    ) );  }

    void onCancel() {
      Navigator.pop(context);
    }

    Future onOk() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.remove(Constants.prefUserIdKeyInt);
      prefs.remove(Constants.loginUserName);
      prefs.remove(Constants.loginpassword);
      prefs.setBool(Constants.prefIsAlreadyVisitedKey, true);
      navigatePushReplacement(LoginScreen(type: Constants.FOR_LOGIN));
    }

void showAddPhotoAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
            elevation: 5.0,
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          title: Container(
            color: Colors.white10,
            child: new Text(
              Constants.getValueFromKey("Admin.Header.Logout", resourceData)+" !",
              style: TextStyle(color: Colors.black),
            ),
          ),
          content: Container(
            height: 50.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: TitleText(text: Constants.getValueFromKey("nop.MyAccountScreen.title.logOutSubTitle", resourceData),
                      ),
                    )),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  child: Container(color: Colors.grey,),
                  height: 1.0,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: FlatBtn(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: Constants.getValueFromKey("Common.No", resourceData)),
                      ),
                      Container(
                        child: FlatBtn(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove(Constants.prefUserIdKeyInt);
                              prefs.remove(Constants.loginUserName);
                              prefs.remove(Constants.loginpassword);
                              prefs.setBool(Constants.prefIsAlreadyVisitedKey, true);
                              navigatePushReplacement(LoginScreen(type: Constants.FOR_LOGIN));
                            },
                            text: Constants.getValueFromKey("Common.Yes",resourceData)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
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
    await Navigator.pushAndRemoveUntil(
        context,
        AnimationPageRoute(page: page, context: context),
        (Route<dynamic> route) => false);
  }

}
