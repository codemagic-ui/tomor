import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/AdvancedSearchAttributeModel.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/pages/AddCartScreen.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/LoadingScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductDetailScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/GetAdvanceSearchAttributeParser.dart';
import 'package:i_am_a_student/parser/SearchProductParser.dart';
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
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchText;

  SearchResultScreen({@required this.searchText});

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool isInternet;

  bool isPageLoad = false;

  bool isLoading;

  bool isError = false;

  int page = 1;

  String sortBy = "0";

  String priceFrom, priceTo;

  String categoryId = "0";

  bool isSearchInSubCategory = false;

  bool isSearchInDescription = false;

  bool isSearchInAdvance = false;

  String manufactureId = "0";

  String vendorId = "0";

  TextEditingController searchTextController = new TextEditingController();

  List<ProductListModel> searchedList = new List<ProductListModel>();

  bool isShowFilter = false;

  bool isAdvanceSearchShow = false;

  bool isVerticalList = false;

  Function hp;

  Function wp;

  double lower, upper;

  bool isErrorInCategory = false;

  List<RangeSliderData> rangeSliders;

  int customerId;

  SharedPreferences prefs;

  AdvancedSearchAttributeModel advancedSearchAttributeModel;

  var minPriceForRanger, maxPriceForRanger, currencyType = "";

  Map resourceData;

  @override
  void initState() {
    internetConnection();
    searchTextController.text = widget.searchText;
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: layout(),
    );
  }

  Widget layout() {
    if (isInternet != null && isInternet) {
      if (isLoading != null && isLoading) {
        callApi(); }
      else if (isLoading != null && !isLoading) {
        if (isPageLoad) {
          callApi();
        }
      else{
        return layoutMain();
      }
        return layoutMain();
      }
      return layoutMain();
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () async {
          isInternet = await Constants.isInternetAvailable();
          setState(() {});
        },
      );
    } else {
      return layoutMain();
    }
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
        appBar: AppBar(
          actions: <Widget>[
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 4,
              child: Center(
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColor.appColor,
                  ),
                  child: TextField(
                    autofocus: true,
                    controller: searchTextController,
                    textInputAction: TextInputAction.search,
                    decoration: new InputDecoration.collapsed(
                      hintText: Constants.getValueFromKey(
                          "Common.Search", resourceData),
                      hintStyle: TextStyle(fontSize: 18.0),
                    ),
                    onSubmitted: (value) {
                      if (value.length > 2) {
                        isLoading = true;
                        isSearchInAdvance = false;
                        page = 1;
                        sortBy = "0";
                        priceTo = null;
                        priceFrom = null;
                        setState(() {});
                      } else {
                        Fluttertoast.showToast(
                            msg: Constants.getValueFromKey(
                                "nop.autocompletesearch.searchlenght",
                                resourceData));
                      }
                    },
                    /*onChanged: (value) {
                      if (value.length > 2) {
                        isLoading = true;
                        page = 1;
                        sortBy = "0";
                        priceTo = null;
                        priceFrom = null;
                        setState(() {});
                      }
                    },*/
                    style: TextStyle(fontSize: 18.0, color: AppColor.black),
                  ),
                ),
              ),
            ),
          ],
          bottom: tabs(),
        ),
        body: !isLoading
            ? new Stack(
                children: <Widget>[
                  isLoading ? LoadingScreen() : resultLayout(),
                  isShowFilter
                      ? new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (minPriceForRanger != null &&
                                          maxPriceForRanger != null) {
                                        isShowFilter = !isShowFilter;
                                      }
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
                                height: 150.0,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  text: Constants.getValueFromKey(
                                                      "Messages.Order.Product(s).Price",
                                                      resourceData),
                                                  color: AppColor.appColor),
                                            ),
                                            FlatBtn(
                                                onPressed: () async {
                                                  if (lower.round() != null &&
                                                      upper.round() != null) {
                                                    priceFrom = lower
                                                        .round()
                                                        .toString();
                                                    priceTo = upper
                                                        .round()
                                                        .toString();
                                                  }
                                                  isShowFilter = false;
                                                  page = 1;
                                                  isLoading = true;
                                                  isSearchInAdvance = true;
                                                  setState(() {});
                                                },
                                                text: Constants.getValueFromKey(
                                                    "nop.searchresultscreen.apply",
                                                    resourceData))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        )
                                      ]..addAll(_buildRangeSliders())),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              )
            : new Scaffold(
                body: Center(
                  child: SpinKitThreeBounce(
                    color: AppColor.appColor,
                    size: 30.0,
                  ),
                ),
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
              Expanded(
                  child: InkWell(
                onTap: () {
                  navigatePushAndRemoveUntil(HomeScreen(currentIndex: 0));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.home, color: Colors.grey),
//                    Body1Text(
//                      text:
//                          Constants.getValueFromKey("Admin.Home", resourceData),
//                      color: Colors.grey,
//                    ),
                  ],
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  navigatePushAndRemoveUntil(HomeScreen(currentIndex: 1));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shop, color: Colors.grey),
//                    Body1Text(
//                      text: Constants.getValueFromKey(
//                          "nop.HomeScreen.brand", resourceData),
//                      color: Colors.grey,
//                    ),
                  ],
                ),
              )),
              Expanded(
                child: new InkWell(
                  onTap: () {
                    onClickCartOption();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Center(
                        child: Constants.cartItemCount != null &&
                                Constants.cartItemCount > 0
                            ? new Stack(children: <Widget>[
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.grey,
                                ),
                                new Positioned(
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
                            : Icon(Icons.shopping_cart,color: Colors.grey),
                      ),
//                      Body1Text(
//                        text: Constants.getValueFromKey(
//                            "nop.HomeScreen.cart", resourceData),
//                        color: Colors.grey,
//                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  navigatePushAndRemoveUntil(HomeScreen(currentIndex: 3));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.account_circle, color: Colors.grey),
//                    Body1Text(
//                      text: Constants.getValueFromKey(
//                          "PageTitle.Account", resourceData),
//                      color: Colors.grey,
//                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultLayout() {
    return LazyLoadScrollView(
      onEndOfPage: () {
        if (!isPageLoad) {
          page = page + 1;
          isPageLoad = true;
          setState(() {});
        }
      },
      scrollOffset: 50,
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          new Card(
              child: new ListView(
            shrinkWrap: true,
            primary: false,
            children: <Widget>[
              CheckboxListTile(
                  title: TitleText(
                      text: Constants.getValueFromKey(
                          "nop.SearchScreen.advanceSearch", resourceData)),
                  onChanged: (value) {
                    setState(() {
                      isAdvanceSearchShow = !isAdvanceSearchShow;
                      if (isAdvanceSearchShow == false) {
                        if (searchTextController.text != null &&
                            searchTextController.text.length > 2) {
                          isLoading = true;
                          isSearchInAdvance = false;
                          isSearchInSubCategory = false;
                          isSearchInDescription = false;
                          page = 1;
                          categoryId = "0";
                          sortBy = "0";
                          manufactureId = "0";
                          vendorId = "0";
                          setState(() {});
                        }
                      }
                    });
                  },
                  value: isAdvanceSearchShow),
              isAdvanceSearchShow
                  ? new ListView(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        category(),
                        checkBoxForSubCategory(),
                        manufacturer(),
                        vendor(),
                        checkBoxForProductDescription(),
                        RaisedBtn(
                          onPressed: () async {
                            page = 1;
                            isLoading = true;
                            priceFrom = null;
                            priceTo = null;
                            sortBy = "0";
                            isSearchInAdvance = true;
                            setState(() {});
                          },
                          text: Constants.getValueFromKey(
                              "PageTitle.Search", resourceData),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    )
                  : Container(),
            ],
          )),
          searchedList.length != 0
              ? isVerticalList ? verticalList() : gridList()
              : noDataFoundLayout(),
        ],
      ),
    );
  }

  Widget noDataFoundLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 150,
        ),
        Center(
          child: Image.asset(
            ImageStrings.imgNoDataFound,
            height: 150,
          ),
        ),
      ],
    );
  }

  Widget gridList() {
    return new GridView.count(
      shrinkWrap: true,
      primary: false,
      childAspectRatio: (1 / 1.6),
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      children: List.generate(
          isPageLoad ? searchedList.length + 1 : searchedList.length, (index) {
        if (isPageLoad == true && index == searchedList.length) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Container(
          child: InkWell(
            onTap: () {
              navigatePush(ProductDetailScreen(
                productId: searchedList[index].id,
              ));
            },
            child: new Card(
              child: Column(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(hp(0.56)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(wp(1)),
                              topLeft: Radius.circular(wp(1))),
                          child: CachedNetworkImage(
                            imageUrl: searchedList[index].image,
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
                      alignment: Alignment(Constants.checkRTL != null && Constants.checkRTL
                          ? -0.9
                          : 0.9, -1.3),
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Body1Text(
                                maxLine: 2, text: searchedList[index].name),
                            SizedBox(
                              height: hp(0.56),
                            ),
                            searchedList[index].rating.toString() != null
                                ? new Padding(
                                    padding: EdgeInsets.only(bottom: hp(0.56)),
                                    child: new RatingBar(
                                      size: hp(2.25),
                                      rating: double.parse(
                                          searchedList[index].rating.toString()),
                                      color: AppColor.appColor,
                                    ),
                                  )
                                : Container(),
                            oldPriceText(index),
                            SizedBox(height: hp(1)),
                            price(searchedList[index])
                          ],
                        ),
                        new Padding(
                            padding: EdgeInsets.only(top: hp(6)),
                            child: InkWell(
                              child: new GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  favoriteOrDetail(index, searchedList);
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
                                    searchedList[index].IsProductInWishList?Icons.favorite:Icons.favorite_border,
                                    color: AppColor.appColor,
                                    size: 15.0,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget verticalList() {
    return new ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: isPageLoad ? searchedList.length + 1 : searchedList.length,
        padding: EdgeInsets.all(wp(1)),
        itemBuilder: (BuildContext context, int index) {
          if (isPageLoad == true && index == searchedList.length) {
            return new Container(
              height: 80,
              width: 80,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Container(
            child: InkWell(
              onTap: () {
                navigatePush(ProductDetailScreen(
                  productId: searchedList[index].id,
                ));
              },
              child: new Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
//                    padding: EdgeInsets.all(5.0),
                      width: wp(35),
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(hp(0.56)),
                            bottomLeft: Radius.circular(hp(0.56))),
                        child: CachedNetworkImage(
                          imageUrl: searchedList[index].image,
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
                                  maxLine: 2, text: searchedList[index].name),
                              SizedBox(
                                height: hp(1),
                              ),
                              searchedList[index].rating > 0
                                  ? new Padding(
                                      padding: EdgeInsets.only(bottom: hp(1)),
                                      child: new RatingBar(
                                        size: hp(2.28),
                                        rating: double.parse(searchedList[index]
                                            .rating
                                            .toString()),
                                        color: AppColor.appColor,
                                      ),
                                    )
                                  : Container(),
                              oldPriceText(index),
                              SizedBox(height: hp(1)),
                              price(searchedList[index]),
//                            discountTextForVerticalList(index)
                            ],
                          )),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(hp(1)),
                      child: InkWell(
                        child: new GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            favoriteOrDetail(index, searchedList);
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
                                  searchedList[index].IsProductInWishList?Icons.favorite:Icons.favorite_border,
                                  color: AppColor.appColor,
                                  size: 15.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<Widget> _buildRangeSliders() {
    List<Widget> children = <Widget>[];
    if (rangeSliders != null) {
      for (int index = 0; index < rangeSliders.length; index++) {
        children.add(
            rangeSliders[index].build(context, (double lower, double upper) {
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
    }
    return children;
  }

  List<RangeSliderData> rangeSliderDefinitions(
      minimumPrice, maximumPrice, currencyType) {
    return <RangeSliderData>[
      RangeSliderData(
          min: minimumPrice,
          max: maximumPrice,
          currency: currencyType,
          lowerValue: minimumPrice,
          upperValue: maximumPrice,
          showValueIndicator: true,
          valueIndicatorMaxDecimals: 0,
          activeTrackColor: AppColor.appColor,
          inactiveTrackColor: Colors.black38,
          valueIndicatorColor: AppColor.appColor),
    ];
  }

  Widget category() {
    if (advancedSearchAttributeModel != null &&
        advancedSearchAttributeModel.availableCategoryList != null &&
        advancedSearchAttributeModel.availableCategoryList.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TitleText(
            text: Constants.getValueFromKey("Search.Category", resourceData)),
        SizedBox(height: 10.0),
        new Container(
          padding: EdgeInsets.all(8.0),
          height: 60.0,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              isExpanded: true,
              hint: Text(
                  Constants.getValueFromKey("Search.Category", resourceData)),
              value: advancedSearchAttributeModel.categoryCurrentValue,
              items: advancedSearchAttributeModel.dropDownItemsCategory,
              onChanged: (value) {
                setState(() {
                  advancedSearchAttributeModel.categoryCurrentValue = value;
                  categoryId = advancedSearchAttributeModel
                      .categoryCurrentValue.value
                      .toString();
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget checkBoxForSubCategory() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
                value: isSearchInSubCategory,
                onChanged: (value) {
                  setState(() {
                    isSearchInSubCategory = value;
                  });
                }),
            InkWell(
                onTap: () {
                  setState(() {
                    isSearchInSubCategory = !isSearchInSubCategory;
                  });
                },
                child: SubHeadText(
                    text: Constants.getValueFromKey(
                        "Search.IncludeSubCategories", resourceData)))
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget manufacturer() {
    if (advancedSearchAttributeModel != null &&
        advancedSearchAttributeModel.availableManufactureList != null &&
        advancedSearchAttributeModel.availableManufactureList.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TitleText(
            text:
                Constants.getValueFromKey("Search.Manufacturer", resourceData)),
        SizedBox(height: 10),
        new Container(
          padding: EdgeInsets.all(8),
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              isExpanded: true,
              hint: Text(Constants.getValueFromKey(
                  "Search.Manufacturer", resourceData)),
              value: advancedSearchAttributeModel.manufactureCurrentValue,
              items: advancedSearchAttributeModel.dropDownItemsManufacture,
              onChanged: (value) {
                setState(() {
                  advancedSearchAttributeModel.manufactureCurrentValue = value;
                  manufactureId = advancedSearchAttributeModel
                      .manufactureCurrentValue.value
                      .toString();
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget vendor() {
    if (advancedSearchAttributeModel.availableVendorList.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TitleText(
            text: Constants.getValueFromKey("Search.Vendor", resourceData)),
        SizedBox(height: 10),
        new Container(
          padding: EdgeInsets.all(8),
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              isExpanded: true,
              hint: Text(
                  Constants.getValueFromKey("Search.Vendor", resourceData)),
              value: advancedSearchAttributeModel.vendorCurrentValue,
              items: advancedSearchAttributeModel.dropDownItemsVendor,
              onChanged: (value) {
                setState(() {
                  advancedSearchAttributeModel.vendorCurrentValue = value;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget checkBoxForProductDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
                value: isSearchInDescription,
                onChanged: (value) {
                  setState(() {
                    isSearchInDescription = value;
                  });
                }),
            InkWell(
                onTap: () {
                  setState(() {
                    isSearchInDescription = !isSearchInDescription;
                  });
                },
                child: SubHeadText(
                    text: Constants.getValueFromKey(
                        "Search.SearchInDescriptions", resourceData)))
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget oldPriceText(int index) {
    if (searchedList[index].oldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${searchedList[index].oldPrice}",
          style: new TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 12.0),
        ),
      );
    }
    return Container();
  }

  Widget price(ProductListModel model) {
    String price;
    if (model.price != null && model.price.toString().isNotEmpty) {
      price = model.price.toString();
    }
    if (model.tierPriceModelList.length > 0) {
      price =
          "${Constants.getValueFromKey("Admin.System.QueuedEmails.Fields.From", resourceData)}${model.tierPriceModelList.last.price.toString()}";
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

  Widget tabs() {
    return new PreferredSize(
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        height: 60,
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isVerticalList = !isVerticalList;
                    isShowFilter = false;
                  });
                },
                child: isVerticalList
                    ? Container(
                        child: Image.asset(
                          "images/gridview.png",
                          color: AppColor.appColor,
                          height: 22,
                          width: 22,
                        ),
                      )
                    : Container(
                        child: Image.asset(
                          "images/listview.png",
                          color: AppColor.appColor,
                          height: 22,
                          width: 22,
                        ),
                      ),
              ),
            ),
            Container(
              color: Colors.grey,
              height: 20,
              width: 1.0,
            ),
            new Expanded(
                child: InkWell(
              onTap: () {
                setState(() {
                  if (minPriceForRanger != null && maxPriceForRanger != null) {
                    isShowFilter = !isShowFilter;
                  }
                });
              },
              child: Container(
                child: Image.asset(
                  "images/filter_white.png",
                  color: AppColor.appColor,
                  height: 20,
                  width: 20,
                ),
              ),
            )),
            Container(
              color: Colors.grey,
              height: 20,
              width: 1.0,
            ),
            new Expanded(
                child: InkWell(
              onTap: () {
                setState(() {
                  isShowFilter = false;
                });
                sortItemNavigationButton(context);
              },
              child:
                  Icon(Icons.import_export, color: AppColor.appColor, size: 30),
            )),
          ],
        ),
      ),
      preferredSize: new Size(56.0, 56.0),
    );
  }

  callApi() async {
    await getSharedPref();
    FocusScope.of(context).requestFocus(new FocusNode());

    if (advancedSearchAttributeModel == null) {
      await callApiForGetCategory();
    }
    String strJson = "";
    if (searchTextController.text.length > 2) {
      strJson = makeRequestJson(searchTextController.text.toString());
      Map result = await SearchProductParser.searchCallApi(
          "${Config.strBaseURL}products/advancedsearch", strJson);
      if (result["errorCode"] == "0") {
        if (isLoading) {
          searchedList = result["value"];
        } else if (isPageLoad) {
          searchedList.addAll(result["value"]);
        }

        if (minPriceForRanger == null && maxPriceForRanger == null) {
          if (searchedList != null && searchedList.length > 0) {
            minPriceForRanger = searchedList[0].minimumPrice;
            maxPriceForRanger = searchedList[0].maximumPrice;
            currencyType = searchedList[0].currencyType;
            if (minPriceForRanger != null && maxPriceForRanger != null) {
              rangeSliders = rangeSliderDefinitions(
                  minPriceForRanger, maxPriceForRanger, currencyType);
            }
          }
        }

        isLoading = false;
        isPageLoad = false;
        isError = false;
      } else {
        isError = true;
        String error = result["msg"];
        print("error in search secreen $error");
      }
    }
    if(mounted){
    setState(() {});}
  }

  String makeRequestJson(String searchText) {
    String strJson = "";
    strJson = UserModel.searchApiPara(
        searchText,
        categoryId,
        isSearchInSubCategory,
        manufactureId,
        vendorId,
        priceFrom,
        priceTo,
        isSearchInDescription,
        isSearchInAdvance,
        false,
        sortBy,
        page.toString(),
        customerId.toString(),
        25.toString());
    return strJson;
  }

  void onClickCartOption() {
    navigatePush(AddCartScreen(
      isFromProductDetailScreen: false,
    ));
  }

  void favoriteOrDetail(int index, List<ProductListModel> arrayList) {
    arrayList[index].attributes.length == 0 &&
            (arrayList[index].isGiftCard != null &&
                !arrayList[index].isGiftCard)
        ? onTapFavorite(index, arrayList[index])
        : navigatePush(
            ProductDetailScreen(productId: arrayList[index].id),
          );

  }

  void onTapFavorite(int index, ProductListModel productList) {
   /* if (productList.attributes.length == 0 &&
        (productList.isGiftCard != null && !productList.isGiftCard)) {
      Constants.progressDialog(true, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      callApiForAddToWishList(productList);
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    }
*/
   if(!productList.IsProductInWishList){
      if (productList.attributes.length == 0 &&
          (productList.isGiftCard != null &&
              !productList.isGiftCard)) {
        Constants.progressDialog(true, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
        callApiForAddToWishList(productList);
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));}
      else{
        navigatePush(ProductDetailScreen(productId: productList.id));
      }
    }else{
      Fluttertoast.showToast(msg: "Already in wishlist");
    }
  }

  void sortItemNavigationButton(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Wrap(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                new ListTile(
                    leading: Icon(Icons.import_export,
                        color: AppColor.appColor, size: 30),
                    title: new TitleText(
                      text: Constants.getValueFromKey(
                          "nop.SearchResultScreen.shortBy", resourceData),
                      color: AppColor.appColor,
                    ),
                    onTap: null),
                Container(
                  height: 45,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey(
                        "Admin.Customers.Customers.ActivityLog.CreatedOn",
                        resourceData)),
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
                  height: 45,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey(
                        "nop.SearchReslutScreen.nameAscending", resourceData)),
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
                  height: 45,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey(
                        "nop.SearchReslutScreen.nameDescending", resourceData)),
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
                  height: 45,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey(
                        "Enums.Nop.Core.Domain.Catalog.ProductSortingEnum.Position",
                        resourceData)),
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
                  height: 45,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey(
                        "nop.SearchReslutScreen.priceAscending", resourceData)),
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
                  height: 45,
                  child: new ListTile(
                    title: new Text(Constants.getValueFromKey(
                        "nop.SearchReslutScreen.priceDescending",
                        resourceData)),
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

  Future callApiForAddToWishList(ProductListModel newArrivalProductList) async {
    await getSharedPref();
    if (customerId != null) {
      String url =
          "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=$customerId&productId=${newArrivalProductList.id}"
          "&shoppingCartTypeId=2"
          "&quantity=${newArrivalProductList.minQuntity}&attributeControlIds=0"
          "&rentalStartDate=null&rentalEndDate=null";
     /// "${Config.strBaseURL}getproducttoshoppingcart/$customerId, ${newArrivalProductList.id}, 2, ${newArrivalProductList.minQuntity}, 0, null, null"
      Map result = await AddProductIntoCartParser.callApi2(url);
      if (result["errorCode"] == "0") {
        Fluttertoast.showToast(
            msg: result["value"].toString());/*Constants.getValueFromKey(
                "nop.SearchReslutScreen.addedToWishlist", resourceData));*/
        setState(() {
          newArrivalProductList.IsProductInWishList = true;
        });
      } else {

        /*String error = result["value"].toString();
        Fluttertoast.showToast(msg: error);*/
        navigatePush(ProductDetailScreen(productId: newArrivalProductList.id));
      //  print(error);
        //errorDialog(error);
      }
    } else {
      Fluttertoast.showToast(
          msg: Constants.getValueFromKey(
              "nop.SearchReslutScreen.errorToast", resourceData));
    }
  }

  Future callApiForGetCategory() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      //region api call
      Map result = await GetAdvanceSearchAttributeParser.callApi(
          "${Config.strBaseURL}products/advancedserarchlist");
      if (result["errorCode"] == "0") {
        advancedSearchAttributeModel = result["value"];
      } else {
        String error = result["msg"];
        print("error in advance search secreen $error");
        isError = true;
      }
      //endregion
    }
  }

  Future getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePush(Widget page) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePushAndRemoveUntil(Widget page) async {
    await Navigator.pushAndRemoveUntil(
        context,
        AnimationPageRoute(page: page, context: context),
        (Route<dynamic> route) => false);
  }
}
