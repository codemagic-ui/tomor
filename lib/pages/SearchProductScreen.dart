import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/AdvancedSearchAttributeModel.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/pages/AddCartScreen.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
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
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

class SearchProductScreen extends StatefulWidget {
  final BuildContext superContext;

  SearchProductScreen({this.superContext});

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  bool isInternet;
  bool isLoading = false;
  bool isError = false;
  bool isShow = false;
  bool isAdvanceSearchShow = false;
  bool isList = false;
  bool isOnTextChange = false;
  bool isOnTextSubmitted = false;
  bool isAppBar = false;
  List<RangeSliderData> rangeSliders;
  TextEditingController searchTextController = new TextEditingController();
  bool isExpanded = true;

  bool isPageLoad = false;
  int limit = 10;
  int page = 1;

  double lower, upper;

  List<ProductListModel> searchedList = new List<ProductListModel>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  int customerId;

  String data;
  SharedPreferences prefs;

  AdvancedSearchAttributeModel advancedSearchAttributeModel;

  bool isSubCategoryBoxChecked = false;
  bool isProductDescriptionChecked = false;

  TextEditingController priceRangeStart = new TextEditingController();
  TextEditingController priceRangeEnd = new TextEditingController();

  Function hp;
  Function wp;

  @override
  void initState() {
    internetConnection();
    searchTextController.text = data;
    callApiForGetCategory();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isPageLoad != null && isPageLoad) {
          callApiOnTextChange(data, page.toString());
        }
        if (isLoading) {
          return Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: AppColor.appColor,
                size: 25.0,
              ),
            ),
          );
        } else {
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
            size: 25.0,
          ),
        ),
      );
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
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: 18.0),
                    ),
                    onSubmitted: (value) {
                      if (value.length > 2) {
                        isOnTextSubmitted = true;
                        isOnTextChange = false;
                        search(value);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Enter minimum three word to search");
                      }
                    },
                    onChanged: (value) {
                      if (value.length > 2) {
                        isOnTextChange = true;
                        isOnTextSubmitted = false;
                        searchOnChanged(value);
                      }
                    },
                    style: TextStyle(fontSize: 18.0, color: AppColor.black),
                  ),
                ),
              ),
            ),
          ],
          bottom: isAppBar ? tabs() : null,
        ),
        body: Stack(
          children: <Widget>[
            isLoading ? LoadingScreen() : onTextSubmittedLayout(),
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
                          height: 150.0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                            text: "Price",
                                            color: AppColor.appColor),
                                      ),
                                      FlatBtn(
                                          onPressed: () async {
                                            Constants.progressDialog1(
                                                true, context);
                                            if (lower.round() != null &&
                                                upper.round() != null) {
                                              await filterApi(
                                                  lower.round(), upper.round());
                                            }
                                            setState(() {
                                              isShow = false;
                                            });
                                          },
                                          text: "Apply")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  )
                                ]..addAll(_buildRangeSliders())),
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
                    Body1Text(
                      text: "Home",
                      color: Colors.grey,
                    ),
                  ],
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  navigatePushAndRemoveUntil(HomeScreen(currentIndex: 1));
                },
                child: Column(
                  children: <Widget>[
                    Icon(Icons.shop, color: Colors.grey),
                    Body1Text(
                      text: "Brand",
                      color: Colors.grey,
                    ),
                  ],
                ),
              )),
              Expanded(
                child: new InkWell(
                  onTap: () {
                    onClickCartOption();
                  },
                  child: Column(
                    children: <Widget>[
                      new Center(
                        child: Constants.cartItemCount != null &&
                                Constants.cartItemCount > 0
                            ? new Stack(children: <Widget>[
                                Icon(Icons.add_shopping_cart),
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
                            : Icon(Icons.shopping_cart),
                      ),
                      Body1Text(
                        text: "Cart",
                        color: Colors.grey,
                      ),
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
                  children: <Widget>[
                    Icon(Icons.account_circle, color: Colors.grey),
                    Body1Text(
                      text: "Account",
                      color: Colors.grey,
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future filterApi(int lowerValue, int upperValue) async {
    String strJson = UserModel.searchApiPara(
        data,
        0.toString(),
        false,
        0.toString(),
        0.toString(),
        lowerValue.toString(),
        upperValue.toString(),
        false,
        false,
        false,
        0.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    await callApiForFilter(strJson);
  }

  Widget onTextSubmittedLayout() {
    if (isOnTextSubmitted) {
      if (searchedList.length != 0) {
        return ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            new Card(
                child: new ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                CheckboxListTile(
                    title: TitleText(text: "Advance Search"),
                    onChanged: (value) {
                      setState(() {
                        isAdvanceSearchShow = !isAdvanceSearchShow;
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
                              await onClickSearchButton();
                            },
                            text: "SEARCH",
                          ),
                          SizedBox(height: 10.0),
                        ],
                      )
                    : Container(),
              ],
            )),
            isList ? verticalList() : gridList()
          ],
        );
      } else {
        return noDataFoundLayout();
      }
    } else {
      return onTextChangeLayout();
    }
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
        childAspectRatio: (1 / 1.58),
        crossAxisCount: 2,
        padding: EdgeInsets.all(8.0),
        children: List.generate(
            isPageLoad ? searchedList.length + 1 : searchedList.length,
            (index) {
          if (isPageLoad == true && index == searchedList.length) {
            return Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: AppColor.appColor,
                  size: 25.0,
                ),
              ),
            );
          }
          return InkWell(
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
                      alignment: Alignment(0.9, -1.3),
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.only(top: hp(6)),
                            child: new GestureDetector(
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
                            )),
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
                                      rating: double.parse(searchedList[index]
                                          .rating
                                          .toString()),
                                      color: AppColor.appColor,
                                    ),
                                  )
                                : Container(),
                            oldPriceText(index),
                            SizedBox(height: hp(1)),
                            price(searchedList[index])
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
                  child: SpinKitThreeBounce(
                    color: AppColor.appColor,
                    size: 25.0,
                  ),
                ),
              );
            }
            return InkWell(
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
                            ],
                          )),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(hp(1)),
                      child: new GestureDetector(
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
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget onTextChangeLayout() {
    if (searchedList.length != 0) {
      return ListView(
        children: List<Widget>.generate(searchedList.length, (int index) {
          final ProductListModel model = searchedList[index];
          return new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(
                    top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                leading: CachedNetworkImage(
                  imageUrl: model.image.toString(),
                  placeholder: (context, url) => Image.asset(
                    ImageStrings.imgPlaceHolder,
                    height: 50.0,
                    width: 50.0,
                  ),
                  height: 50.0,
                  width: 50.0,
                ),
                title: new Body1Text(
                  text: model.name,
                ),
                subtitle: price(model),
                onTap: () {
                  navigatePush(ProductDetailScreen(
                    productId: model.id,
                  ));
                },
              ),
              new Container(
                height: 1.0,
                color: Colors.grey,
              )
            ],
          );
        }),
      );
    } else {
      return Container();
    }
  }

  Widget noDataFoundLayout() {
    return Center(
      child: Image.asset(
        ImageStrings.imgNoDataFound,
        height: 150.0,
      ),
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

  Widget category() {
    if (advancedSearchAttributeModel.availableCategoryList.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TitleText(text: "Category"),
        SizedBox(height: 10.0),
        new Container(
          padding: EdgeInsets.all(8.0),
          height: 60.0,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              isExpanded: true,
              hint: Text("Category"),
              value: advancedSearchAttributeModel.categoryCurrentValue,
              items: advancedSearchAttributeModel.dropDownItemsCategory,
              onChanged: (value) {
                setState(() {
                  advancedSearchAttributeModel.categoryCurrentValue = value;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10.0),
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
        TitleText(text: "Vendor"),
        SizedBox(height: 10.0),
        new Container(
          padding: EdgeInsets.all(8.0),
          height: 60.0,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              isExpanded: true,
              hint: Text("Vendor"),
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
                value: isSubCategoryBoxChecked,
                onChanged: (value) {
                  setState(() {
                    isSubCategoryBoxChecked = value;
                  });
                }),
            InkWell(
                onTap: () {
                  setState(() {
                    isSubCategoryBoxChecked = !isSubCategoryBoxChecked;
                  });
                },
                child: SubHeadText(text: "Automatically search sub categories"))
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget manufacturer() {
    if (advancedSearchAttributeModel.availableManufactureList.length == 0) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TitleText(text: "Manufacturer"),
        SizedBox(height: 10.0),
        new Container(
          padding: EdgeInsets.all(8.0),
          height: 60.0,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              isExpanded: true,
              hint: Text("Manufacturer"),
              value: advancedSearchAttributeModel.manufactureCurrentValue,
              items: advancedSearchAttributeModel.dropDownItemsManufacture,
              onChanged: (value) {
                setState(() {
                  advancedSearchAttributeModel.manufactureCurrentValue = value;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget priceRange() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(text: "Price range"),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceRangeStart,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceRangeEnd,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
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
                value: isProductDescriptionChecked,
                onChanged: (value) {
                  setState(() {
                    isProductDescriptionChecked = value;
                  });
                }),
            InkWell(
                onTap: () {
                  setState(() {
                    isProductDescriptionChecked = !isProductDescriptionChecked;
                  });
                },
                child: SubHeadText(text: "Search In product descriptions"))
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
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
                setState(() {
                  isShow = !isShow;
                });
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

  List<RangeSliderData> rangeSliderDefinitions(minimumPrice, maximumPrice,String currency) {
    return <RangeSliderData>[
      RangeSliderData(
          min: minimumPrice,
          currency: currency,
          max: maximumPrice,
          lowerValue: minimumPrice,
          upperValue: maximumPrice,
          showValueIndicator: true,
          valueIndicatorMaxDecimals: 0,
          activeTrackColor: AppColor.appColor,
          inactiveTrackColor: Colors.black38,
          valueIndicatorColor: AppColor.appColor),
    ];
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
                      text: 'Short By',
                      color: AppColor.appColor,
                    ),
                    onTap: () => {}),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Created on'),
                    onTap: () async => {
                      Constants.progressDialog1(true, context),
                      await shortByCreated()
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Name Ascending'),
                    onTap: () async => {
                      Constants.progressDialog1(true, context),
                      await shortByNameAscending()
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Name Descending'),
                    onTap: () async => {
                      Constants.progressDialog1(true, context),
                      await shortByNameDescending()
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Position'),
                    onTap: () async => {
                      Constants.progressDialog1(true, context),
                      await shortByPosition()
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Price Ascending'),
                    onTap: () async => {
                      Constants.progressDialog1(true, context),
                      await shortByPriceAscending()
                    },
                  ),
                ),
                Container(
                  height: sizes,
                  child: new ListTile(
                    title: new Text('Price Descending'),
                    onTap: () async => {
                      Constants.progressDialog1(true, context),
                      await shortByPriceDescending()
                    },
                  ),
                ),
              ],
            ),
          );
        });
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

  void search(String data) {
    this.data = data;
    if (data.length > 2) {
      callApiOnTextChange(data, page.toString());
    }
  }

  void searchOnChanged(String data) {
    this.data = data;
    if (data.length > 2) {
      callApiOnTextChangeAuto(data, page.toString());
    }
  }

  void onClickCartOption() {
    //todo redirect to cart Screen
    navigatePush(AddCartScreen(isFromProductDetailScreen: true));
  }

  void onTapFavorite(int index, ProductListModel productList) {
    if (productList.attributes.length == 0 &&
        (productList.isGiftCard != null && !productList.isGiftCard)) {
      //todo call api for add witshlist item
      Constants.progressDialog1(true, context);
      callApiForAddToWishList(productList);
    }
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

  void callApiOnTextChange(String data, String page) async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }
    if (isInternet) {
      print("TAG ===?Here your Page in Issue $page");
      String strJson = UserModel.searchApiPara(
          data,
          0.toString(),
          false,
          0.toString(),
          0.toString(),
          "",
          "",
          false,
          false,
          false,
          0.toString(),
          page.toString(),
          customerId.toString(),
          11.toString());
      await callApi(strJson);
      isLoading = false;
      isPageLoad = false;
      setState(() {});
    }
  }

  void callApiOnTextChangeAuto(String data, String page) async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }
    if (isInternet) {
      print("TAG ===?Here your Page in Issue $page");
      String strJson = UserModel.searchApiPara(
          data,
          0.toString(),
          false,
          0.toString(),
          0.toString(),
          "",
          "",
          false,
          false,
          false,
          0.toString(),
          page.toString(),
          customerId.toString(),
          11.toString());
      await callApiAuto(strJson);
      isLoading = false;
      isPageLoad = false;
      setState(() {});
    }
  }

  price(ProductListModel model) {
    String price;
    if (model.price != null && model.price.toString().isNotEmpty) {
      price = model.price.toString();
    }
    if (model.tierPriceModelList.length > 0) {
      price = "From ${model.tierPriceModelList.last.price.toString()}";
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

  Future callApiForAddToWishList(ProductListModel newArrivalProductList) async {
    await getSharedPref();
    if (customerId != null) {
      String url =
          "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=$customerId&productId=${newArrivalProductList.id}&shoppingCartTypeId=2&quantity=${newArrivalProductList.minQuntity}&attributeControlIds=0&rentalStartDate=null&rentalEndDate=null";
      Map result = await AddProductIntoCartParser.callApi2(url);
      if (result["errorCode"] == "0") {
        Constants.progressDialog1(false, context);
        Fluttertoast.showToast(
          msg: "Added to wishlist",
        );
        setState(() {
          newArrivalProductList.IsProductInWishList = true;
        });
      } else {
        Constants.progressDialog1(false, context);
        Fluttertoast.showToast(
          msg: "Item is Not Added in to wishlist",
        );
        String error = result["msg"];
        print(error);
      }
    } else {
      Fluttertoast.showToast(msg: "Somethings went wront try again later");
    }
  }

  Future getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
  }

  Future onClickSearchButton() async {
    if (searchTextController.text != null &&
        searchTextController.text.length > 2) {
      Constants.progressDialog1(true, context);
      await callApiForAdvanceSearch();
    } else {
      Fluttertoast.showToast(msg: "Search term minimum length is 3 characters");
    }
  }

  Future callApiForAdvanceSearch() async {
    String strJson = UserModel.searchApiPara(
        searchTextController.text.toString(),
        advancedSearchAttributeModel != null &&
                advancedSearchAttributeModel.categoryCurrentValue != null
            ? advancedSearchAttributeModel.categoryCurrentValue.value
            : 0.toString(),
        isSubCategoryBoxChecked,
        advancedSearchAttributeModel != null &&
                advancedSearchAttributeModel.manufactureCurrentValue != null
            ? advancedSearchAttributeModel.manufactureCurrentValue.value
            : 0.toString(),
        0.toString(),
        priceRangeStart.text.toString(),
        priceRangeEnd.text.toString(),
        isProductDescriptionChecked,
        true,
        false,
        0.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);

    if (result["errorCode"] == "0") {
      Constants.progressDialog1(false, context);
      searchedList = result["value"];
      setState(() {});
    } else {
      isLoading = false;
      String error = result["msg"];
      print(error);

      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  Future shortByNameAscending() async {
    String strJson = UserModel.searchApiPara(
        data,
        0.toString(),
        false,
        0.toString(),
        0.toString(),
        "",
        "",
        false,
        false,
        false,
        5.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);

    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      Constants.progressDialog1(false, context);
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog1(false, context);
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
    String strJson = UserModel.searchApiPara(
        data,
        0.toString(),
        false,
        0.toString(),
        0.toString(),
        "",
        "",
        false,
        false,
        false,
        6.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);
    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      Constants.progressDialog1(false, context);
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog1(false, context);
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
    String strJson = UserModel.searchApiPara(
        data,
        0.toString(),
        false,
        0.toString(),
        0.toString(),
        "",
        "",
        false,
        false,
        false,
        0.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);

    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      Constants.progressDialog1(false, context);
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog1(false, context);
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
    String strJson = UserModel.searchApiPara(
        data,
        0.toString(),
        false,
        0.toString(),
        0.toString(),
        "",
        "",
        false,
        false,
        false,
        10.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);

    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      Constants.progressDialog1(false, context );
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog1(false, context );
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
    String strJson = UserModel.searchApiPara(
        data,
        0.toString(),
        false,
        0.toString(),
        0.toString(),
        "",
        "",
        false,
        false,
        false,
        11.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);
    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      Constants.progressDialog1(false, context);
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog1(false, context);
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
    String strJson = UserModel.searchApiPara(
        data,
        0.toString(),
        false,
        0.toString(),
        0.toString(),
        "",
        "",
        false,
        false,
        false,
        15.toString(),
        page.toString(),
        customerId.toString(),
        11.toString());
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);

    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      Constants.progressDialog1(false, context);
      Navigator.pop(context);
      setState(() {});
    } else {
      Constants.progressDialog1(false, context);
      Navigator.pop(context);
      setState(() {});
      String error = result["msg"];
      print(error);

      isError = true;
    }
    isPageLoad = false;
    setState(() {});
  }

  Future callApi(String strJson) async {
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);
    if (result["errorCode"] == "0") {
      searchedList=result["value"];
      if (searchedList != null && searchedList.length != 0) {
        isAppBar = true;
        rangeSliders = rangeSliderDefinitions(
            searchedList[0].minimumPrice, searchedList[0].maximumPrice,searchedList[0].currencyType);
      }
    } else {
      String error = result["msg"];
      print("error in search secreen $error");
      isError = true;
    }
  }

  Future callApiForFilter(String strJson) async {
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);
    if (result["errorCode"] == "0") {
      searchedList = result["value"];
      if (searchedList != null && searchedList.length != 0) {
        isAppBar = true;
        rangeSliders = rangeSliderDefinitions(
            searchedList[0].minimumPrice, searchedList[0].maximumPrice,searchedList[0].currencyType);
      }
      Constants.progressDialog1(false, context);
      setState(() {});
    } else {
      Constants.progressDialog1(false, context);
      String error = result["msg"];
      print("error in search secreen $error");
      isError = true;
    }
  }

  Future callApiAuto(String strJson) async {
    Map result = await SearchProductParser.searchCallApi(
        "${Config.strBaseURL}products/advancedsearch", strJson);
    if (result["errorCode"] == "0") {
      searchedList = result["value"];
    } else {
      String error = result["msg"];
      print("error in search secreen $error");
      isError = true;
    }
  }

  Future callApiForGetCategory() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      isLoading = true;
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
      isLoading = false;
      setState(() {});
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    new Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isInternet = await Constants.isInternetAvailable();
      setState(() {});
    });
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
