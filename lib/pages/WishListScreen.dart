import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/pages/AddCartScreen.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductDetailScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/WishProductList.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';
import 'package:package_info/package_info.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  int userId;
  SharedPreferences prefs;
  Map resourceData;
  List<ProductListModel> modelProductList=new List<ProductListModel>();
  ProductListModel mProductListModel;

  @override
  void initState() {
    internetConnection();
    getPreferences();
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
          title: Text(
            Constants.getValueFromKey("account.wishList.title", resourceData),
          ),
          actions: <Widget>[
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
            InkWell(
                onTap: () {
                  onClickShareOption();
                },
                child: Icon(Icons.share)),
            SizedBox(width: 15.0),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: mProductListModel.wishProductList.length != null &&
                  mProductListModel.wishProductList.length != 0
              ? productList()
              : noWishList(),
        ),
      ),
    );
  }

  Widget productList() {
    if (mProductListModel.wishProductList.length == 0) {
      return Container();
    }
    return ListView(
      children: List<Widget>.generate(mProductListModel.wishProductList.length,
          (index) {
        ProductListModel model = mProductListModel.wishProductList[index];
        return Slidable(
          delegate: new SlidableDrawerDelegate(),
          actionExtentRatio: 0.25,
          child: InkWell(
            onTap: () {
              navigatePush(ProductDetailScreen(
                productId: mProductListModel.wishProductList[index].id,
              ));
            },
            child: new Card(
              child: Container(
                height: 155.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                        width: 130.0,
                        height: 140.0,
                        child: new ClipRRect(
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0)),
                          child: model.image.toString() != null &&
                                  model.image.toString().isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: model.image.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Image.asset(ImageStrings.imgPlaceHolder),
                                )
                              : Image.asset(ImageStrings.imgPlaceHolder),
                        ),
                      ),
                    ),
                    new Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex:3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new SubHeadText(
                                    text: model.name != null ? model.name : "",
                                    maxLine: 2,
                                    align: TextAlign.start,
                                  ),
                                  SizedBox(height: 5.0),
                                  new Body1Text(
                                    text: model.skuName != null
                                        ? model.skuName
                                        : "",
                                    maxLine: 2,
                                    align: TextAlign.start,
                                  ),
                                  SizedBox(height: 10.0),
                                  quantity(model, index),
                                  SizedBox(height: 10.0),
                                  new Body1Text(
                                    text: model.unitPrice != null
                                        ? Constants.getValueFromKey(
                                                "account.wishList.priceLabel",
                                                resourceData) +
                                            ": " +
                                            model.unitPrice.toString()
                                        : "",
                                    maxLine: 2,
                                    align: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Body2Text(
                                  text: Constants.getValueFromKey(
                                          "account.wishList.totalLabel",
                                          resourceData) +
                                      ": ",
                                  maxLine: 2,
                                  align: TextAlign.start,
                                ),
                                new TitleText(
                                  align: TextAlign.end,
                                  text: model.price.toString(),
                                  color: AppColor.appColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          secondaryActions: <Widget>[
            new IconSlideAction(
              caption: Constants.getValueFromKey(
                  "account.wishList.deleteLabel", resourceData),
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                _showDialog(index, resourceData);
              },
            ),
          ],
        );
      }),
    );
  }

  Widget noWishList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "images/nowishlist.png",
          height: 150.0,
          width: 150.0,
        ),
        SizedBox(
          height: 40.0,
        ),
        Text(
          Constants.getValueFromKey(
              "account.wishList.emptyLabel", resourceData),
          maxLines: 6,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title.copyWith(color: Colors.red),
        ),
      ],
    );
  }

  Widget quantity(ProductListModel model, int index) {
    if (model.stockQuantity != null &&
        model.stockQuantity.toString().isNotEmpty) {
      return Body2Text(
          text: Constants.getValueFromKey(
                  "account.wishList.qtyLabel", resourceData) +
              ": ${model.stockQuantity}",
          align: TextAlign.start);
    }

    return Container();
  }

  void _showDialog(int index, Map resourceData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(Constants.getValueFromKey(
                  "account.wishList.dailogTitle", resourceData) +
              "!"),
          content: new Text(Constants.getValueFromKey(
              "account.wishList.dailogLabel", resourceData)+"?"),
          actions: <Widget>[
            new FlatBtn(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  Constants.progressDialog(true, context, Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                  deleteItem(mProductListModel.wishProductList[index].deleteId);
                  mProductListModel.wishProductList.removeAt(index);
                });
              },
              text: Constants.getValueFromKey("account.wishList.yes", resourceData),
            ),
            SizedBox(
              width: 10.0,
            ),

            new FlatBtn(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: Constants.getValueFromKey("account.wishList.no", resourceData),
            ),
          ],
        );
      },
    );
  }

  void onClickCartOption() {
    //todo redirect to cart Screen
    navigatePush(AddCartScreen(isFromProductDetailScreen: false));
  }

  Future onClickShareOption() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appUrlForAndroid =
        "http://play.google.com/store/apps/details?id=${packageInfo.packageName}";
    String appUrlForIphone =
        "http://itunes.apple.com/+91/app/${packageInfo.appName}/id${packageInfo.packageName}?mt=8";
    final RenderBox box = context.findRenderObject();
    Share.share(
        "${Constants.getValueFromKey("Account.WishList.shareLabel", resourceData)} ${packageInfo.appName}.\n${Constants.getValueFromKey("Account.WishList.shareLabel1", resourceData)}\n${defaultTargetPlatform == TargetPlatform.iOS ? appUrlForIphone : appUrlForAndroid}",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

    //todo redirect to search
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      //todo call api to get searchList

      await wishListApi();

      isLoading = false;
      setState(() {});
    }
  }

  Future deleteItem(deleteId) async {
    Map result = await AddProductIntoCartParser.callApiDelete(
        "${Config.strBaseURL}shopping_cart_items/deleteshoppingcartorwishlistitem?id="+
            deleteId.toString());
    if (result["errorCode"] == "0") {
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey(
            "Account.WishList.deleteLabel", resourceData),
      );
    } else {
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey(
            "Account.WishList.notDeleteLabel", resourceData),
      );
    }
  }

  Future getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future wishListApi() async {
    try {
      Map result = await WishProductList.callApi(
          "${Config.strBaseURL}shopping_cart_items/getwishlistbycustomerId?customerId=$userId");
      if (result["errorCode"] == "0") {
        mProductListModel = result["value"];
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

  navigatePush(Widget page) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }
}
