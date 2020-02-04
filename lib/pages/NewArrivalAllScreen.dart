import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/pages/LoadingScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/NewArrivalProductsParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddCartScreen.dart';
import 'ErrorScreenPage.dart';
import 'NoIntenetScreen.dart';
import 'ProductAllItem.dart';
import 'ProductDetailScreen.dart';
import 'ProductItem.dart';
import 'SearchScreens/AutoCompleteSearchScreen.dart';

class NewArrivalAllScreen extends StatefulWidget {
  @override
  NewArrivalAllScreenState createState() => NewArrivalAllScreenState();
}

class NewArrivalAllScreenState extends State<NewArrivalAllScreen> {
  List<ProductListModel> newArrivalProductList = new List<ProductListModel>();

  SharedPreferences prefs;
  int customerId;
  String appLogo;
  Map resourceData;

  bool isInternet;
  bool isLoading;
  bool isError = false;

  var currentIndex;

  Future getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    appLogo = prefs.getString(Constants.logo);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
    Constants.checkRTL = prefs.getBool(Constants.prefRTL);
  }

  @override
  Future initState() {
    // TODO: implement initState
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  Widget layout() {
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
        appBar: appBar(),
        body: new Container(
          child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (1/1.6),
                children: List.generate(newArrivalProductList.length, (index) {
                return Center(
                child:  ProductAllItem(
                      model: newArrivalProductList[index],
                      onTapFav: ()
                      {
                          favoriteOrDetail(index, newArrivalProductList);
                          },
                    onTapProductItem: () {
                        navigatePush(ProductDetailScreen(
                     productId: newArrivalProductList[index].id));
                    },
                  ));
                }),
        ),
      ),

    ));

  }

  AppBar appBar() {

      return new AppBar(
        title: new Text(Constants.getValueFromKey("nop.HomeScreen.newArrivalLabel", resourceData)),
        elevation: 0.0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        actions: <Widget>[
          new InkWell(
            onTap: () {
              onClickSearchOption();
            },
            child: new Container(
              child: new Icon(
                Icons.search,
              ),
              padding: EdgeInsets.only(right: 15.0),
            ),
          ),
          new InkWell(
            onTap: () {
              onClickCartOption();
            },
            child: new Center(
              child: Constants.cartItemCount != null &&
                  Constants.cartItemCount > 0
                  ? new Stack(children: <Widget>[
                Container(child: Icon(Icons.add_shopping_cart)),
                Positioned(
                  left: 10.0,
                  right: 3.0,
                  bottom: 12.5,
                  child: CircleAvatar(
                    backgroundColor: AppColor.appColor,
                    radius: 5.5,
                    child: Text(
                      Constants.cartItemCount.toString(),
                      style:
                      TextStyle(fontSize: 8.0, color: Colors.white),
                    ),
                  ),
                )
              ])
                  : Icon(Icons.shopping_cart),
            ),
          ),
          SizedBox(width: 10.0),
        ],
      );
  }

  @override
  void onRefresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        child: Theme(
            data: ThemeData(
              brightness: Brightness.light,
              primarySwatch: AppColor.appColor,
              primaryColor: AppColor.white,
              buttonTheme: ButtonThemeData().copyWith(
                  buttonColor: AppColor.appColor,
                  textTheme: ButtonTextTheme.primary),
              fontFamily: "EncodeSans",
            ),
            child: layout()),
        onWillPop: () {
          Navigator.pop(context);
        });
  }

  void favoriteOrDetail(int index, List<ProductListModel> arrayList) {
    arrayList[index].attributes.length == 0 &&
            (arrayList[index].isGiftCard != null &&
                !arrayList[index].isGiftCard)
        ? onTapFavorite(index, arrayList[index])
        : navigatePush(ProductDetailScreen(productId: arrayList[index].id));
  }

  navigatePush(Widget page) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }

  void onTapFavorite(int index, ProductListModel favorateProductList) {
    if (favorateProductList.attributes.length == 0 &&
        (favorateProductList.isGiftCard != null &&
            !favorateProductList.isGiftCard)) {
      //todo call api for add witshlist item
      Constants.progressDialog(true, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      callApiForAddToWishList(favorateProductList);
    }
  }

  Future callApiForAddToWishList(ProductListModel newArrivalProductList) async {
    String url =
        "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=$customerId&productId=${newArrivalProductList.id}&shoppingCartTypeId=2&quantity=${newArrivalProductList.minQuntity}&attributeControlIds=0&rentalStartDate=null&rentalEndDate=null";
    Map result = await AddProductIntoCartParser.callApi2(url);
    if (result["errorCode"] == "0") {
      String msg = result["value"];
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      setState(() {
        newArrivalProductList.IsProductInWishList=true;
      });
      onRefresh();
      Fluttertoast.showToast(
        msg: msg,
      );
    } else {
      String msg = result["value"];
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: msg,
      );
    }
  }

  Future newProductList() async {
    Map result = await NewArrivalProductsParser.callApi(
        "${Config.strBaseURL}products/newarrivalproducts?page=11"
            "&PageSize=10&orderby=0"
            "&Lid=&Cid=&customerId="+customerId.toString());
    if (result["errorCode"] == "0") {
      newArrivalProductList = result["value"];
      setState(() {});
    } else {
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  Future callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      await getSharedPreferences();
      await newProductList();
      isLoading = false;

      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void onClickSearchOption() {
    navigatePush(AutoCompleteSearchScreen());
  }

  void onClickCartOption() {
    navigatePush(AddCartScreen(isFromProductDetailScreen: true));
  }

  Future onClickShareOption() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appUrlForAndroid =
        "http://play.google.com/store/apps/details?id=${packageInfo.packageName}";
    String appUrlForIphone =
        "http://itunes.apple.com/+91/app/${packageInfo.appName}/id${packageInfo.packageName}?mt=8";
    final RenderBox box = context.findRenderObject();
    Share.share(
        "${Constants.getValueFromKey("nop.ProductDetailScreen.share", resourceData)} ${packageInfo.appName}.\n${Constants.getValueFromKey("nop.ProductDetailScreen.share1", resourceData)}\n${defaultTargetPlatform == TargetPlatform.iOS ? appUrlForIphone : appUrlForAndroid}",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
