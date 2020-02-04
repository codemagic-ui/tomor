import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:i_am_a_student/parser/BestSellerProductParser.dart';
import 'package:i_am_a_student/parser/FetureProductParser.dart';
import 'package:i_am_a_student/parser/GetBrandProductListBySubCategory.dart';
import 'package:i_am_a_student/parser/GetProductListBySubCategory.dart';
import 'package:i_am_a_student/parser/GetProductListByTagParser.dart';
import 'package:i_am_a_student/parser/NewArrivalProductsParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/RangeSliderData.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:i_am_a_student/pages/SearchScreens/AutoCompleteSearchScreen.dart';

class ProductListScreen extends StatefulWidget {
  final manufactureId;
  final categoryName;
  final bool isFromBrandList;
  final bool isFromTag;
  final bool isFromNewArrival;
  final bool isFromFeatured;
  final bool isFromBestSeller;
  final bool isFromSubCategory;

  ProductListScreen(
      {this.manufactureId,
        this.categoryName,
        this.isFromBrandList,
        this.isFromTag,
        this.isFromNewArrival,
        this.isFromFeatured,
        this.isFromBestSeller,
        this.isFromSubCategory});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;

  bool isShow = false;

  bool isList = false;

  var subscription;

  List<ProductListModel> productList = new List<ProductListModel>();

  List<RangeSliderData> rangeSliders;

  SharedPreferences prefs;

  int customerId;

  Function hp;

  Function wp;
  bool isPageLoad = false;
  int limit = 10;

  String sortBy = "";
  int page = 1;
  double lower, upper;
  String priceFrom, priceTo;

  var minPriceForRanger, maxPriceForRanger, currencyType = "";
  Map resourceData;
  @override
  void initState() {
    super.initState();
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Future getSharedPrefHere() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isLoading != null && isLoading) {
          callApi();
          return Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: AppColor.appColor,
                size: 30.0,
              ),
            ),
          );
        } else if (isLoading != null && !isLoading) {
          if (isPageLoad != null && isPageLoad) {
            apiCall(page);
          }
          return layoutMain();
        }
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
        body: Center(
          child: SpinKitThreeBounce(
            color: AppColor.appColor,
            size: 30.0,
          ),
        ),
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
    hp = Screen(MediaQuery.of(context).size).hp;
    wp = Screen(MediaQuery.of(context).size).wp;
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          bottom: tabs(),
          title: Text(
            widget.categoryName,
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
            SizedBox(width: wp(3)),
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
          ],
        ),
        body: new Stack(
          children: <Widget>[
            constantLayout(),
            isShow
                ? new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Expanded(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                      child: Container(
                        color: Colors.black12,
                      )),
                ),
                new Card(
                  margin: EdgeInsets.all(0.0),
                  elevation: 0.0,
                  child: Container(
                    height: 160.0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: productList != null && productList.length > 0
                            ? new Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset(
                                      "images/filter_white.png",
                                      color: AppColor.appColor,
                                      height: 20.0,
                                      width: 20.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: TitleText(
                                        text: Constants.getValueFromKey("Admin.Orders.Products.Price", resourceData),
                                        color: AppColor.appColor),
                                  ),
                                  FlatBtn(
                                      onPressed: () async {
                                          priceFrom=null;
                                          priceTo=null;
                                        isShow = true;
                                        page = 1;
                                        isLoading = true;
                                        setState(() {});
                                      },
                                      text: Constants.getValueFromKey("nop.ProductListScreen.Clearbutton", resourceData)),
                                  FlatBtn(
                                      onPressed: () async {
                                        if (lower.round() != null && upper.round() != null) {
                                          priceFrom = lower.round().toString();
                                          priceTo = upper.round().toString();
                                        }
                                        isShow = false;
                                        page = 1;
                                        isLoading = true;
                                        setState(() {});
                                      },
                                      text: Constants.getValueFromKey("nop.ProductListScreen.ApplyButton", resourceData))
                                ],
                              ),
                              SizedBox(
                                height: 25.0,
                              )
                            ]..addAll(_buildRangeSliders()))
                            : Container(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              TitleText(
                                  text: Constants.getValueFromKey("nop.ProductListScreen.NoDataFound", resourceData),
                                  color: AppColor.appColor),
                          FlatBtn(
                              onPressed: () async {
                                priceFrom=null;
                                priceTo=null;
                                isShow = false;
                                page = 1;
                                isLoading = true;
                                setState(() {});
                              },
                              text: Constants.getValueFromKey("nop.ProductListScreen.Clearbutton", resourceData))
                         ],),),
                      ),
                    ),
                  ),
                ),
              ],
            )
                : Container(),
          ],
        ),
        bottomNavigationBar: new Container(
          height: kBottomNavigationBarHeight,
          padding: EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: InkWell(
                    onTap: () {
                      navigatePushAndRemoveUntil(HomeScreen(currentIndex: 0));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.home, color: Colors.grey),
                      ],
                    ),
                  )),
              new Expanded(
                  child: InkWell(
                    onTap: () {
                      navigatePushAndRemoveUntil(HomeScreen(currentIndex: 1));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.shop, color: Colors.grey),
                      ],
                    ),
                  )),
              new Expanded(
                  child: InkWell(
                    onTap: () {
                      navigatePushAndRemoveUntil(HomeScreen(currentIndex: 2));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Constants.cartItemCount != null && Constants.cartItemCount > 0
                            ? new Stack(children: <Widget>[
                          Icon(Icons.add_shopping_cart),
                          Positioned(
                            left: 10.0,
                            right: 3.0,
                            bottom: 12.5,
                            child: CircleAvatar(
                              backgroundColor: AppColor.appColor,
                              radius: 5.5,
                              child: Text(
                                Constants.cartItemCount.toString(),
                                style: TextStyle(
                                    fontSize: 8.0, color: Colors.white),
                              ),
                            ),
                          )
                        ])
                            : Icon(Icons.shopping_cart),
                      ],
                    ),
                  )),
              new Expanded(
                  child: InkWell(
                    onTap: () {
                      navigatePushAndRemoveUntil(HomeScreen(currentIndex: 3));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.account_circle, color: Colors.grey),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  navigatePushAndRemoveUntil(Widget page) async {
    await Navigator.pushAndRemoveUntil(
        context,
        AnimationPageRoute(page: page, context: context),
            (Route<dynamic> route) => false);
  }

  Widget constantLayout() {
    return productList.length != null && productList.length != 0
        ? isList ? verticalList() : gridList()
        : new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "images/no_orders.png",
          height: 170.0,
          width: 170.0,
        ),
        SizedBox(
          height: 40.0,
        ),
        Text(
          Constants.getValueFromKey("nop.ProductListScreen.NoProducts", resourceData),
          maxLines: 6,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(color: Colors.red),
        ),
      ],
    );
  }

  Widget gridList() {
    return LazyLoadScrollView(
      onEndOfPage: () {
        page = page + 1;
        isPageLoad = true;
        setState(() {});
      },
      scrollOffset: 50,
      child: new GridView.count(
        shrinkWrap: true,
        primary: false,
        childAspectRatio: (1 / 1.55),
        crossAxisCount: 2,
        padding: EdgeInsets.all(8.0),
        children: List.generate(
            isPageLoad ? productList.length + 1 : productList.length, (index) {
          if (isPageLoad == true && index == productList.length) {
            return Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: AppColor.appColor,
                  size: 30.0,
                ),
              ),
            );
          }
          return InkWell(
            onTap: () {
              navigatePush(ProductDetailScreen(
                productId: productList[index].id,
              ));
            },
            child: new Card(
              child: Column(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height/4.5,
                        width: MediaQuery.of(context).size.width/1,
                        padding: EdgeInsets.all(hp(0.56)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(wp(1)),
                              topLeft: Radius.circular(wp(1))),
                          child: CachedNetworkImage(
                            imageUrl: productList[index].image,
                            placeholder: (context, url) => Image.asset(
                              ImageStrings.imgPlaceHolder,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: hp(0.10)),
                  new Container(
                    margin: EdgeInsets.only(
                      left: wp(1),
                    ),
                    child: new Stack(
                      alignment: Alignment(0.9, -1.3),
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.only(top: hp(7)),
                            child: new GestureDetector(
                              onTap: () {
                                favoriteOrDetail(index, productList);
                              },
                              child: Container(
                                padding: EdgeInsets.all(hp(0.70)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColor.appColor,
                                  ),
                                ),
                                child: Icon(
                                  productList[index].IsProductInWishList ? Icons.favorite : Icons.favorite_border,
                                  color: AppColor.appColor,
                                  size: 15.0,
                                ),
                              ),
                            )),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Body1Text(
                                maxLine: 2, text: productList[index].name),
                            SizedBox(
                              height: hp(0.56),
                            ),
                            productList[index].rating.toString() != null
                                ? new Padding(
                              padding: EdgeInsets.only(bottom: hp(0.56)),
                              child: new RatingBar(
                                size: hp(2.25),
                                rating: double.parse(
                                    productList[index].rating.toString()),
                                color: AppColor.appColor,
                              ),
                            )
                                : Container(),
                            oldPriceText(index),
                            SizedBox(height: hp(1)),
                            price(productList[index])
                          ],
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
    );
  }

  Widget verticalList() {
    return LazyLoadScrollView(
      onEndOfPage: () {
        page = page + 1;
        isPageLoad = true;
        setState(() {});
      },
      scrollOffset: 50,
      child: new ListView.builder(
          itemCount: isPageLoad ? productList.length + 1 : productList.length,
          padding: EdgeInsets.all(wp(1)),
          itemBuilder: (BuildContext context, int index) {
            if (isPageLoad == true && index == productList.length) {
              return new Container(
                height: 80,
                width: 80,
                child: Center(
                  child: SpinKitThreeBounce(
                    color: AppColor.appColor,
                    size: 30.0,
                  ),
                ),
              );
            }
            return InkWell(
              onTap: () {
                navigatePush(ProductDetailScreen(
                  productId: productList[index].id,
                ));
              },
              child: new Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      width: wp(35),
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(hp(0.56)),
                            bottomLeft: Radius.circular(hp(0.56))),
                        child: CachedNetworkImage(
                          imageUrl: productList[index].image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            ImageStrings.imgPlaceHolder,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      flex: 2,
                      child: Padding(
                          padding: EdgeInsets.all(hp(1.5)),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SubHeadText(
                                  maxLine: 2, text: productList[index].name),
                              SizedBox(
                                height: hp(1),
                              ),
                              productList[index].rating > 0
                                  ? new Padding(
                                padding: EdgeInsets.only(bottom: hp(1)),
                                child: new RatingBar(
                                  size: hp(2.28),
                                  rating: double.parse(productList[index]
                                      .rating
                                      .toString()),
                                  color: AppColor.appColor,
                                ),
                              )
                                  : Container(),
                              oldPriceText(index),
                              SizedBox(height: hp(1)),
                              price(productList[index]),
                            ],
                          )),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(hp(1)),
                      child: new GestureDetector(
                        onTap: () {
                          favoriteOrDetail(index, productList);
                          Fluttertoast.showToast(msg: "ontap");
                        },
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(hp(0.56)),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.appColor,
                                ),
                              ),
                              child: Icon(
                                productList[index].IsProductInWishList ? Icons.favorite : Icons.favorite_border,
                                color: AppColor.appColor,
                                size: 15.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  price(ProductListModel model) {
    String price;
    if (model.price != null && model.price.toString().isNotEmpty) {
      price = model.price.toString();
    }
    if (model.tierPriceModelList.length > 0) {
      price = "${Constants.getValueFromKey("Admin.System.QueuedEmails.Fields.From", resourceData)} ${model.tierPriceModelList.last.price.toString()}";
    }
    if (price != null) {
      return Body2Text(
        color: AppColor.appColor,
        text: price,
        maxLine: 1,
      );
    }
    return Container();
  }

  tabs() {
    return new PreferredSize(
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        height: 60.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isList = !isList;
                    isShow = false;
                  });
                },
                child: isList
                    ? Container(
                  child: Image.asset(
                    "images/gridview.png",
                    color: AppColor.appColor,
                    height: 22.0,
                    width: 22.0,
                  ),
                )
                    : Container(
                  child: Image.asset(
                    "images/listview.png",
                    color: AppColor.appColor,
                    height: 22.0,
                    width: 22.0,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey,
              height: 20.0,
              width: 1.0,
            ),
            new Expanded(
                child: InkWell(
                  onTap: () {
                    if(rangeSliders!=null){
                    setState(() {
                      isShow = !isShow;
                    }); }
                  },
                  child: Container(
                    child: Image.asset(
                      "images/filter_white.png",
                      color: AppColor.appColor,
                      height: 20.0,
                      width: 20.0,
                    ),
                  ),
                )),
            Container(
              color: Colors.grey,
              height: 20.0,
              width: 1.0,
            ),
            new Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isShow = false;
                    });
                    shortItemNavigationButton(context);
                  },
                  child: Icon(Icons.import_export,
                      color: AppColor.appColor, size: 30.0),
                )),
          ],
        ),
      ),
      preferredSize: new Size(56.0, 56.0),
    );
  }

  void favoriteOrDetail(int index, List<ProductListModel> arrayList) {
    arrayList[index].attributes.length == 0 &&
        (arrayList[index].isGiftCard != null &&
            !arrayList[index].isGiftCard)
        ? onTapFavorite(index, arrayList[index])
        : navigatePush(ProductDetailScreen(productId: arrayList[index].id));
  }

  void onTapFavorite(int index, ProductListModel productList) {
    if (productList.attributes.length == 0 &&
        (productList.isGiftCard != null && !productList.isGiftCard)) {
      if(!productList.IsProductInWishList) {
      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      callApiForAddToWishList(productList); }
      else {
        Fluttertoast.showToast(msg: "Already in wishlist");
      }
    }
  }

  void onClickProductListItem(ProductListModel productListModel) {
    navigatePush(ProductDetailScreen(productId: productListModel.id));
  }

  void filterPriceNavigationButton(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 80.0,
            child: Center(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[]..addAll(_buildRangeSliders())),
            ),
          );
        });
  }

  void shortItemNavigationButton(context) {
    var sizes = 45.0;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Wrap(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                new ListTile(
                    leading: Icon(Icons.import_export,
                        color: AppColor.appColor, size: 30.0),
                    title: new TitleText(
                      text: Constants.getValueFromKey("Admin.Orders.Fields.ShortBy", resourceData),
                      color: AppColor.appColor,
                    ),
                    onTap: null),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey("Admin.Orders.Fields.CreatedOn", resourceData)),
                    onTap: () async {
                      sortBy = "15";
                      page = 1;
                      isLoading = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey("nop.ProductListScreen.NameAscending", resourceData)),
                    onTap: () async {
                      sortBy = "5";
                      page = 1;
                      isLoading = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),

                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey("nop.ProductListScreen.NameDescending", resourceData)),
                    onTap: () async {
                      sortBy = "6";
                      page = 1;
                      isLoading = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey("Enums.Nop.Core.Domain.Catalog.ProductSortingEnum.Position", resourceData)),
                    onTap: () async {
                      sortBy = "0";
                      page = 1;
                      isLoading = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey("nop.ProductListScreen.PriceAscending", resourceData)),
                    onTap: () async {
                      sortBy = "10";
                      page = 1;
                      isLoading = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey("nop.ProductListScreen.PriceDescending", resourceData)),
                    onTap: () async {
                      sortBy = "11";
                      page = 1;
                      isLoading = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  void onClickSearchOption() {
    navigatePush(AutoCompleteSearchScreen());
  }

  void onClickCartOption() {
    navigatePush(AddCartScreen(isFromProductDetailScreen: false,));
  }

  oldPriceText(int index) {
    if (productList[index].oldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${productList[index].oldPrice}",
          style: new TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 12.0),
        ),
      );
    } else {
      return Container();
    }
  }

  discountTextForVerticalList(int index) {
    double oldPrice = productList[index].oldPrice;
    double newPrice = productList[index].price;
    int discount = 0;
    if (newPrice < oldPrice) {
      discount = 100 - ((oldPrice * 100) / newPrice).round();
    }
    if (discount > 0) {
      return new Container(
        decoration: BoxDecoration(
            color: AppColor.appColor,
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle),
        margin: EdgeInsets.only(top: 2.0, left: 3.0),
        padding: EdgeInsets.all(3.0),
        child: Body1Text(
          text: "-$discount%",
          color: AppColor.white,
          maxLine: 1,
        ),
      );
    } else {
      return new Container();
    }
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      try {
        await getSharedPrefHere();
        //if is come from brand list
        if (widget.isFromBrandList != null && widget.isFromBrandList) {
          await apiCall(1);
        } else if (widget.isFromTag != null && widget.isFromTag) {
          await apiCall(1);
        } else if (widget.isFromNewArrival != null && widget.isFromNewArrival) {
          await newProductList();
        } else if (widget.isFromFeatured != null && widget.isFromFeatured) {
          await getFeatureProductList();
        } else if (widget.isFromBestSeller != null && widget.isFromBestSeller) {
          await bestSellerList();
        } else if (widget.isFromSubCategory != null &&
            widget.isFromSubCategory) {
          await apiCall(1);
        }
      } catch (e) {
        print(e);
        isError = true;
        isLoading = false;
      }
      isLoading = false;
      if(this.mounted){
      setState(() {});}
    }
  }

  Future apiCall(int page) async {
    Map result;
    if (widget.isFromBrandList != null && widget.isFromBrandList && sortBy.isEmpty) {
      result = await GetBrandProductListBySubCategory.callApi("${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId="
          +widget.manufactureId.toString()+"&orderBy=0&page="+page.toString()+"&pageSize=11&MinPrice="
          +priceFrom.toString()+"&MaxPrice="
          +priceTo.toString()+"&customerId="
          +customerId.toString());

    }
    if (widget.isFromBrandList != null && widget.isFromBrandList && sortBy.isNotEmpty) {
      result = await GetBrandProductListBySubCategory.callApi("${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId="
          +widget.manufactureId.toString()+"&orderBy="
          +sortBy.toString()+"&page="+page.toString()+"&pageSize=11&MinPrice="
          +priceFrom.toString()+"&MaxPrice="
          +priceTo.toString()+"&customerId="
          +customerId.toString());
    }
    else if (widget.isFromSubCategory != null && widget.isFromSubCategory) {
      result = await GetProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?CategoryId=" +
              widget.manufactureId.toString() +
              "&orderBy=" +
              sortBy +
              "&page=" +
              page.toString() +
              "&pageSize=11&MinPrice=" +
              priceFrom.toString() +
              "&MaxPrice=" +
              priceTo.toString() + "&customerId="+customerId.toString());
    } else if (widget.isFromTag != null && widget.isFromTag) {
      result = await GetProductListByTagParser.callApiForTag(
          "${Config.strBaseURL}products/productsbytag?productTagId=" +
              widget.manufactureId.toString() +
              "&orderBy=0&page=" +
              page.toString() +
              "&pageSize=11&MinPrice=" +
              priceFrom.toString() +
              "&MaxPrice=" +
              priceTo.toString() +
          "&customerId="+customerId.toString());
    }
    if (result["errorCode"] == "0") {
      if (isLoading) {
        productList = result["value"];
      } else if (isPageLoad) {
        productList.addAll(result["value"]);
      }

      if (productList != null && productList.length > 0) {
        if (minPriceForRanger == null && maxPriceForRanger == null) {
          if (productList != null && productList.length > 0) {
            minPriceForRanger = productList[0].minimumPrice;
            maxPriceForRanger = productList[0].maximumPrice;
            currencyType = productList[0].currencyType;
            if (minPriceForRanger != null && maxPriceForRanger != null) {
              rangeSliders = rangeSliderDefinitions(
                  minPriceForRanger, maxPriceForRanger, currencyType);
            }
          }
        }
      }

      isLoading = false;
      isPageLoad = false;
      isError = false;
    } else {
      String error = result["msg"];
      print(error);
      isError = true;
    }
    isPageLoad = false;
    if(this.mounted){
    setState(() {});}
  }

  Future callApiForAddToWishList(ProductListModel newArrivalProductList) async {
    Map result = await AddProductIntoCartParser.callApi2(
        "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=" +
            customerId.toString() +
            "&productId=" +
            newArrivalProductList.id.toString() +
            "&shoppingCartTypeId=2&quantity=" +
            newArrivalProductList.minQuntity.toString() +
            "&attributeControlIds=0&rentalStartDate=null&rentalEndDate=null");

    if (result["errorCode"] == "0") {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey("nop.SubCategoryScreen.AddedWishList", resourceData),
      );
      setState(() {
        newArrivalProductList.IsProductInWishList = true;
      });
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey("nop.SubCategoryScreen.NotAddedWishList", resourceData)
      );
      String error = result["msg"];
      print(error);
    }
  }

  Future bestSellerList() async {
    Map result = await BestSellerProductParser.callApi(
        "${Config.strBaseURL}products/bestsellersproduct");
    if (result["errorCode"] == "0") {
      productList = result["value"];
    } else {
      String error = result["msg"];
      print(error);
      isError = true;
    }
  }

  Future getFeatureProductList() async {
    if (widget.isFromFeatured != null && widget.isFromFeatured && sortBy.isEmpty) {
      Map result = await FeatureProductParser.callApi(
          "${Config
              .strBaseURL}products/featuredproducts?page="+page.toString()+
              "&PageSize=10&customerId=" +
              customerId.toString());
      if (result["errorCode"] == "0") {
        productList = result["value"];
      } else {
        String error = result["msg"];
        print(error);
        isError = true;
      }
    }
    else if (widget.isFromFeatured != null && widget.isFromFeatured && sortBy.isNotEmpty) {
      Map result = await FeatureProductParser.callApi(
          "${Config
              .strBaseURL}products/featuredproducts?page="+page.toString()+
              "&PageSize=10&orderby="+sortBy+
              "&customerId=" +
              customerId.toString());
      if (result["errorCode"] == "0") {
        productList = result["value"];
      } else {
        String error = result["msg"];
        print(error);
        isError = true;
      }
    }
  }

  Future newProductList() async {
    if (widget.isFromNewArrival != null && widget.isFromNewArrival && sortBy.isEmpty) {
    Map result = await NewArrivalProductsParser.callApi(
        "${Config.strBaseURL}products/newarrivalproducts?page="+page.toString()+
            "&PageSize=10&Lid=&Cid=&customerId="+customerId.toString());
    if (result["errorCode"] == "0") {
      productList = result["value"];
    } else {
      String error = result["msg"];
      print(error);
      isError = true;
    } }
    else if(widget.isFromNewArrival != null && widget.isFromNewArrival && sortBy.isNotEmpty)
      {
        Map result = await NewArrivalProductsParser.callApi(
            "${Config.strBaseURL}products/newarrivalproducts?page="+page.toString()+
                "&PageSize=10&orderby="+sortBy+
                "&Lid=&Cid=&customerId="+customerId.toString());
        if (result["errorCode"] == "0") {
          productList = result["value"];
        } else {
          String error = result["msg"];
          print(error);
          isError = true;
        }

      }
    if (productList != null && productList.length > 0) {
      if (minPriceForRanger == null && maxPriceForRanger == null) {
        if (productList != null && productList.length > 0) {
          minPriceForRanger = productList[0].minimumPrice;
          maxPriceForRanger = productList[0].maximumPrice;
          currencyType = productList[0].currencyType;
          if (minPriceForRanger != null && maxPriceForRanger != null) {
            rangeSliders = rangeSliderDefinitions(
                minPriceForRanger, maxPriceForRanger, currencyType);
          }
        }
      }
    }
  }

  Future getProductList() async {
    Map result = await GetProductListBySubCategory.callApi(
        "${Config.strBaseURL}products?category_id=${widget.manufactureId}");
    if (result["errorCode"] == "0") {
      productList = result["value"];
    } else {
      String error = result["msg"];
      print(error);
      isError = true;
    }
  }

  Future getBrandProductList() async {
    Map result = await GetBrandProductListBySubCategory.callApi(
        "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
            widget.manufactureId.toString());
    if (result["errorCode"] == "0") {
      productList = result["value"];
    } else {
      String error = result["msg"];
      print(error);
      isError = true;
    }
  }

  Future getTagProductList() async {
    Map result = await GetProductListByTagParser.callApiForTag(
        "${Config.strBaseURL}products/productsbytag?productTagId=" +
            widget.manufactureId.toString());
    if (result["errorCode"] == "0") {
      productList = result["value"];
    } else {
      String error = result["msg"];
      print(error);
      isError = true;
    }
  }

  Future shortByNameAscending() async {
    Map result;
    if (widget.isFromBrandList != null && widget.isFromBrandList) {
      result = await GetBrandProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
              widget.manufactureId.toString() +
              "&orderBy=5&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromSubCategory != null && widget.isFromSubCategory) {
      result = await GetProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?CategoryId=" +
              widget.manufactureId.toString() +
              "&orderBy=5&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromTag != null && widget.isFromTag) {
      result = await GetProductListByTagParser.callApiForTag(
          "${Config.strBaseURL}products/productsbytag?productTagId=" +
              widget.manufactureId.toString() +
              "&orderBy=5&page=" +
              page.toString() +
              "&pageSize=11");
    }
    if (result["errorCode"] == "0") {
      productList = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
      String error = result["msg"];
      print(error);
      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  Future shortByNameDescending() async {
    Map result;
    if (widget.isFromBrandList != null && widget.isFromBrandList) {
      result = await GetBrandProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
              widget.manufactureId.toString() +
              "&orderBy=6&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromSubCategory != null && widget.isFromSubCategory) {
      result = await GetProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?CategoryId=" +
              widget.manufactureId.toString() +
              "&orderBy=6&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromTag != null && widget.isFromTag) {
      result = await GetProductListByTagParser.callApiForTag(
          "${Config.strBaseURL}products/productsbytag?productTagId=" +
              widget.manufactureId.toString() +
              "&orderBy=6&page=" +
              page.toString() +
              "&pageSize=11");
    }
    if (result["errorCode"] == "0") {
      productList = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
      String error = result["msg"];
      print(error);

      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  Future shortByPosition() async {
    Map result;
    if (widget.isFromBrandList != null && widget.isFromBrandList) {
      result = await GetBrandProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
              widget.manufactureId.toString() +
              "&orderBy=0&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromSubCategory != null && widget.isFromSubCategory) {
      result = await GetProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?CategoryId=" +
              widget.manufactureId.toString() +
              "&orderBy=0&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromTag != null && widget.isFromTag) {
      result = await GetProductListByTagParser.callApiForTag(
          "${Config.strBaseURL}products/productsbytag?productTagId=" +
              widget.manufactureId.toString() +
              "&orderBy=0&page=" +
              page.toString() +
              "&pageSize=11");
    }

    if (result["errorCode"] == "0") {
      productList = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
      String error = result["msg"];
      print(error);

      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  Future shortByPriceAscending() async {
    Map result;
    if (widget.isFromBrandList != null && widget.isFromBrandList) {
      result = await GetBrandProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
              widget.manufactureId.toString() +
              "&orderBy=10&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromSubCategory != null && widget.isFromSubCategory) {
      result = await GetProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?CategoryId=" +
              widget.manufactureId.toString() +
              "&orderBy=10&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromTag != null && widget.isFromTag) {
      result = await GetProductListByTagParser.callApiForTag(
          "${Config.strBaseURL}products/productsbytag?productTagId=" +
              widget.manufactureId.toString() +
              "&orderBy=10&page=" +
              page.toString() +
              "&pageSize=11");
    }

    if (result["errorCode"] == "0") {
      productList = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
      String error = result["msg"];
      print(error);

      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  Future shortByPriceDescending() async {
    Map result;
    if (widget.isFromBrandList != null && widget.isFromBrandList) {
      result = await GetBrandProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
              widget.manufactureId.toString() +
              "&orderBy=11&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromSubCategory != null && widget.isFromSubCategory) {
      result = await GetProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?CategoryId=" +
              widget.manufactureId.toString() +
              "&orderBy=11&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromTag != null && widget.isFromTag) {
      result = await GetProductListByTagParser.callApiForTag(
          "${Config.strBaseURL}products/productsbytag?productTagId=" +
              widget.manufactureId.toString() +
              "&orderBy=11&page=" +
              page.toString() +
              "&pageSize=11");
    }
    if (result["errorCode"] == "0") {
      productList = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
      String error = result["msg"];
      print(error);

      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  Future shortByCreated() async {
    Map result;
    if (widget.isFromBrandList != null && widget.isFromBrandList) {
      result = await GetBrandProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
              widget.manufactureId.toString() +
              "&orderBy=15&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromSubCategory != null && widget.isFromSubCategory) {
      result = await GetProductListBySubCategory.callApi(
          "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?CategoryId=" +
              widget.manufactureId.toString() +
              "&orderBy=15&page=" +
              page.toString() +
              "&pageSize=11");
    } else if (widget.isFromTag != null && widget.isFromTag) {
      result = await GetProductListByTagParser.callApiForTag(
          "${Config.strBaseURL}products/productsbytag?productTagId=" +
              widget.manufactureId.toString() +
              "&orderBy=15&page=" +
              page.toString() +
              "&pageSize=11");
    }

    if (result["errorCode"] == "0") {
      productList = result["value"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Navigator.pop(context);
      setState(() {});
      String error = result["msg"];
      print(error);

      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  List<Widget> _buildRangeSliders() {
    List<Widget> children = <Widget>[];
    for (int index = 0; index < rangeSliders.length; index++) {
      children
          .add(rangeSliders[index].build(context, (double lower, double upper) {
        // adapt the RangeSlider lowerValue and upperValue

        this.lower = lower;
        this.upper = upper;
        setState(() {
          rangeSliders[index].lowerValue = lower;
          rangeSliders[index].upperValue = upper;
        });
      }));
      // Add an extra padding at the bottom of each RangeSlider
      children.add(new SizedBox(height: 8.0));
    }

    return children;
  }

  List<RangeSliderData> rangeSliderDefinitions(
      minimumPrice, maximumPrice, String currencyType) {
    return <RangeSliderData>[
      RangeSliderData(
          min: minimumPrice,
          max: maximumPrice,
          lowerValue: minimumPrice,
          currency: currencyType,
          upperValue: maximumPrice,
          showValueIndicator: true,
          valueIndicatorMaxDecimals: 0,
          activeTrackColor: AppColor.appColor,
          inactiveTrackColor: Colors.black38,
          valueIndicatorColor: AppColor.appColor),
    ];
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    var connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isInternet = await Constants.isInternetAvailable();
      if (isLoading == null) {
        isLoading = isInternet;
      }
      setState(() {});
    });
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

  Future filterApi(int lowerValue, int upperValue) async {
    Map result = await GetBrandProductListBySubCategory.callApi(
        "${Config.strBaseURL}categories/getproductsbymanufacturerId?manufacturerId=" +
            widget.manufactureId.toString() +
            "&orderBy=0&page=1&pageSize=11&MinPrice=" +
            lowerValue.toString()+
            "&MaxPrice="+
            upperValue.toString());
    if (result["errorCode"] == "0") {
      productList = result["value"];
      if (productList != null && productList.length != 0) {
        rangeSliders = rangeSliderDefinitions(productList[0].minimumPrice,
            productList[0].maximumPrice, productList[0].currencyType);
      }
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      setState(() {});
    } else {
      String error = result["msg"];
      print(error);
      isError = true;
    }
  }
}
