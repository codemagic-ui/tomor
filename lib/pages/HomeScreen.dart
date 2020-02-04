import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/CategoryListModel.dart';
import 'package:i_am_a_student/models/ImageSliderModel.dart';
import 'package:i_am_a_student/models/NewsListModel.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/pages/AddCartScreen.dart';
import 'package:i_am_a_student/pages/BrandListScreen.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/LoadingScreen.dart';
import 'package:i_am_a_student/pages/MyAccount.dart';
import 'package:i_am_a_student/pages/NewArrivalAllScreen.dart';
import 'package:i_am_a_student/pages/NewsDetailScreen.dart';
import 'package:i_am_a_student/pages/NewsListScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductDetailScreen.dart';
import 'package:i_am_a_student/pages/ProductItem.dart';
import 'package:i_am_a_student/pages/SearchScreens/AutoCompleteSearchScreen.dart';
import 'package:i_am_a_student/pages/SubCategoryScreen.dart';
import 'package:i_am_a_student/pages/WishListScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/BestSellerProductParser.dart';
import 'package:i_am_a_student/parser/FetureProductParser.dart';
import 'package:i_am_a_student/parser/GetCategoryListParser.dart';
import 'package:i_am_a_student/parser/GetImageSliderParser.dart';
import 'package:i_am_a_student/parser/NewArrivalProductsParser.dart';
import 'package:i_am_a_student/parser/NewsListParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageSlider.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/LanguageStrings.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FeaturedAllScreen.dart';
import 'ProductListScreen.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final int currentIndex;

  HomeScreen({Key key, this.name, this.currentIndex}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with RefreshListener, SingleTickerProviderStateMixin {
  bool isError = false;
  bool isInternet;
  bool isLoading;
  int selectedPoll = -1;

  ImageSliderModel mSliderImages;

  List<CategoryListModel> categoryList = new List<CategoryListModel>();
  List<NewsListModel> newsArrayList = new List<NewsListModel>();
  static List<ProductListModel> newArrivalProductList = new List<ProductListModel>();
  static List<ProductListModel> bestSellerProductList = new List<ProductListModel>();
  static List<ProductListModel> featureProductList = new List<ProductListModel>();

  int currentIndex = 0;

  bool isBack = false;
  bool isShowMore = false;

  SharedPreferences prefs;

  Map resourceData;

  int customerId;
  String appLogo;
  static RefreshListener listener;
  TabController pageViewController;

  @override
  void initState() {
    internetConnection();
    if (widget.currentIndex != null) {
      currentIndex = widget.currentIndex;
    }
    pageViewController = TabController(vsync: this, length: 4);
    pageViewController.index = currentIndex;
    pageViewController.addListener(() {
      setState(() {
        currentIndex = pageViewController.index;
      });
    });

    SystemChrome.setEnabledSystemUIOverlays([]);
    listener = this;
    super.initState();
  }

  Future getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    appLogo = prefs.getString(Constants.logo);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
    Constants.checkRTL = prefs.getBool(Constants.prefRTL);
  }

  @override
  Widget build(BuildContext context) {
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
          return handleBackPress();
        });
  }

  Widget layout() {
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isLoading != null && isLoading) {
          callApi();
          return LoadingScreen();
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
      child: SafeArea(
        child: Scaffold(
          primary: true,
          appBar: appBar(),
          body: pageChooser(),
          bottomNavigationBar: bottomItemTab(),
        ),
      ),
    );
  }

  AppBar appBar() {
    if (currentIndex == 0) {
      return new AppBar(
        automaticallyImplyLeading: false,
        title:  Padding(
          padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
          child: SizedBox(
           child: Image.asset("images/logo.png" ,fit: BoxFit.contain, width: 150,),
      ),
        ),

        actions: <Widget>[
          new Padding(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                navigatePush(AutoCompleteSearchScreen());
              },
              child: Icon(
                Icons.search,
                color: AppColor.black,
                size: 25.0,
              ),
            ),
          ),
        ],
      );
    } else if (currentIndex == 1) {
      return new AppBar(
        leading: null,
        title: Text(Constants.getValueFromKey(
            "nop.HomeScreen.appBarBrand", resourceData)),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                navigatePush(AutoCompleteSearchScreen());
              },
              child: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          )
        ],
      );
    } else {
      return null;
    }
  }

  Widget bottomItemTab() {
    return Container(
      child: DefaultTabController(
        length: 4,
        child: new Scaffold(
          appBar: appBar(),
          bottomNavigationBar: menu(),
          body: TabBarView(
            controller:  pageViewController,
            children: [
              Container(
                child: homePageLayout(),
              ),
              Container(
                child: new BrandListScreen(),
              ),
              Container(
                child: AddCartScreen(isFromProductDetailScreen: false),
              ),
              Container(
                child: MyAccount(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: TabBar(
        labelColor: AppColor.appColor,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.transparent,
        controller: pageViewController,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        tabs: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Tab(
              icon: Icon(Icons.home), text: "Home",
            ),
          ),
          Tab(
            icon: Icon(Icons.shop), text: "Shop",
          ),
          Tab(
            icon: Constants.cartItemCount != null && Constants.cartItemCount > 0
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
                          style: TextStyle(fontSize: 8.0),
                        ),
                      ),
                    )
                  ])
                : Icon(Icons.shopping_cart), text: "Cart",
          ),
          Tab(
            icon: Icon(Icons.account_circle), text: "Profile",
          ),
        ],
      ),
    );
  }

  Widget homePageLayout() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(),
        child: ListView(
          shrinkWrap: false,
          children: <Widget>[
            imageSlider(),

            categories(4, categoryList),

            newArrivalProduct(Constants.getValueFromKey(
                "nop.HomeScreen.newArrivalLabel", resourceData)),

            featureProduct(
                Constants.getValueFromKey("Homepage.Products", resourceData)),

            bestSellerProduct(Constants.getValueFromKey(
                "nop.HomeScreen.bestSellerLabel", resourceData)),

            newsList(Constants.getValueFromKey(
                "Admin.ContentManagement.News", resourceData)),

            SizedBox(height: 8.0),
          ],
        ),
      );
    });
  }

  Widget imageSlider() {
    if (mSliderImages != null) {
      if (mSliderImages.mPicture1UrlList != null &&
          mSliderImages.mPicture1UrlList.length != 0) {
        List<CachedNetworkImageProvider> imageList =
            new List<CachedNetworkImageProvider>();
        for (int i = 0; i < mSliderImages.mPicture1UrlList.length; i++) {
          imageList.add(CachedNetworkImageProvider(
              mSliderImages.mPicture1UrlList[i].toString()));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height:
                180.0 * MediaQuery.of(context).size.width / 423.5294196844927,
            child: ImageSlider(
              onClickItem: () {},
              boxFit: BoxFit.cover,
              autoplay: true,
              image: imageList,
              indicatorBgPadding: 10.0,
              dotSize: 5.0,
              dotSpacing: 20.0,
              dotBgColor: Colors.transparent,
              dotColor: Colors.black,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(seconds: 2),
              autoplayDuration: Duration(seconds: 4),
              overlayShadow: true,
              overlayShadowColors: Colors.white.withOpacity(0.0),
              overlayShadowSize: 1.0,
              borderRadius: true,
              moveIndicatorFromBottom: 10.0,
              radius: Radius.circular(5.0),
            ),
          ),
        );
      } else {
        return Container();
      }
    }
    return Container();
  }

  Widget categories(int rowCount, List<CategoryListModel> list) {
    if (list != null && list.length != 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: rowCount,
              padding: EdgeInsets.only(top: 5.0),
              crossAxisSpacing: 10.0,
              childAspectRatio: (1/1),
              children: List.generate(list.length, (index) {
                return InkWell(
                  onTap: () {
                    onClickCategoryItem(index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3.0,
                              ),
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: list[index].categoryImageURl != null &&
                                  list[index]
                                      .categoryImageURl
                                      .toString()
                                      .isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: list[index].categoryImageURl,
                                  placeholder: (context, url) => Image.asset(
                                    ImageStrings.imgAppIcon,
                                    color: Colors.grey,
                                    height: 50.0,
                                  ),
                                  height: 50.0,
                                )
                              : Image.asset(
                                  ImageStrings.imgAppIcon,
                                  height: 50.0,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Flexible(
                          child: SmallText(
                        text: list[index].categoryName,
                        maxLine: 1,
                        align: TextAlign.center,
                      )),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget newArrivalProduct(String title) {
    return newArrivalProductList != null && newArrivalProductList.length > 0
        ? Container(
            color: Colors.grey[100],
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 15),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          child: TitleText(
                        text: title,
                      )),
                      FlatBtn(

                        text: Constants.getValueFromKey(
                            "Manufacturers.ViewAll", resourceData),
                        color: AppColor.appColor,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewArrivalAllScreen()));},

                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 250.0,
                  child: ListView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: newArrivalProductList.length,
                      padding: EdgeInsets.only(left: 15.0),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItem(
                          model: newArrivalProductList[index],
                          onTapFav: () {
                            favoriteOrDetail(index, newArrivalProductList);
                          },
                          onTapProductItem: () {
                            navigatePush(ProductDetailScreen(
                                productId: newArrivalProductList[index].id));
                          },
                        );
                      }),
                )
              ],
            ),
          )
        : Container();
  }

  Widget featureProduct(String title) {
    return featureProductList.length != null && featureProductList.length != 0
        ? new Container(
            padding: EdgeInsets.only(bottom: 15.0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageStrings.imgBg), fit: BoxFit.fill)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          child: TitleText(
                        text: title,
                        color: AppColor.white,
                      )),
                      FlatBtn(
                    //todo on click view all
                        text: Constants.getValueFromKey(
                            "Manufacturers.ViewAll", resourceData),
                        color: Colors.white,
                        onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => FeaturedAllScreen()));},
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 255.0,
                  child: ListView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: featureProductList.length,
                      padding: EdgeInsets.only(left: 15.0),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductItem(
                          model: featureProductList[index],
                          onTapFav: () {
                            favoriteOrDetail(index, featureProductList);
                          },
                          onTapProductItem: () {
                            navigatePush(ProductDetailScreen(
                                productId: featureProductList[index].id));
                          },
                        );
                      }),
                )
              ],
            ),
          )
        : Container();
  }

  Widget bestSellerProduct(String title) {
    return bestSellerProductList != null && bestSellerProductList.length > 0
        ? Container(
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: TitleText(
                          text: title,
                          maxLine: 1,
                        ),
                      ),
                      FlatBtn(
                        text: "" /*Constants.getValueFromKey(
                            "Manufacturers.ViewAll", resourceData),
                              onPressed: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context) => BestSellerViewAll()));},*/
                             ),
                    ],
                  ),
                ),
                new Container(
                  height: 165,
                  child: ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: bestSellerProductList.length,
                    padding:
                        EdgeInsets.only(left: 15.0, right: 10.0, bottom: 15.0),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductItemBestSeller(
                        resourceData: resourceData,
                        model: bestSellerProductList[index],
                        onTapProductItem: () {
                          navigatePush(ProductDetailScreen(
                              productId: bestSellerProductList[index].id));
                        },
                        onTapFav: () {
                          favoriteOrDetail(index, bestSellerProductList);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  Widget newsList(String newsTitle) {
    return newsArrayList != null && newsArrayList.length > 0
        ? Container(
            color: Colors.grey[100],
            child: Column(
              children: <Widget>[
                TitleRow(
                  title: newsTitle,
                  onPressViewAll: () {
                    onClickNewsViewAll();
                  },
                ),
                new Container(
                  height: 150.0,
                  child: ListView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: newsArrayList.length,
                      padding: EdgeInsets.only(
                        left: 15.0,
                        right: 10.0,
                        bottom: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            navigatePush(NewsDetailScreen(
                              mNewsListModel: newsArrayList[index],
                            ));
                          },
                          child: new Card(
                            child: Container(
                              width: 200.0,
                              margin: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Body2Text(
                                    text: newsArrayList[index].strNewsTitle,
                                    align: TextAlign.justify,
                                    maxLine: 1,
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Body1Text(
                                    text:
                                        "${formatDate(DateTime.parse(newsArrayList[index].strNewsDate), [
                                      dd,
                                      '-',
                                      mm,
                                      '-',
                                      yyyy
                                    ])}",
                                    color: AppColor.appColor,
                                    maxLine: 1,
                                    align: TextAlign.justify,
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Flexible(
                                      child: CaptionText(
                                    text: newsArrayList[index]
                                        .strNewsShortDescription,
                                    maxLine: 5,
                                    align: TextAlign.justify,
                                  ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          )
        : Container();
  }

  Widget radioButton() {
    return Container(
      height: 30.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Radio(
                groupValue: selectedPoll,
                value: 1,
                onChanged: _handleRadioValueChange1,
              ),
              Text(Constants.getValueFromKey(
                  "Reviews.Fields.Rating.Excellent", resourceData))
            ],
          ),
          new Row(
            children: <Widget>[
              new Radio(
                groupValue: selectedPoll,
                value: 2,
                onChanged: _handleRadioValueChange1,
              ),
              Text(Constants.getValueFromKey(
                  "Reviews.Fields.Rating.Good", resourceData))
            ],
          ),
          new Row(
            children: <Widget>[
              new Radio(
                groupValue: selectedPoll,
                value: 3,
                onChanged: _handleRadioValueChange1,
              ),
              Text(Constants.getValueFromKey(
                  "Reviews.Fields.Rating.Bad", resourceData))
            ],
          ),
          new Row(
            children: <Widget>[
              new Radio(
                groupValue: selectedPoll,
                value: 4,
                onChanged: _handleRadioValueChange1,
              ),
              Text(LanguageStrings.veryBadToast)
            ],
          ),
        ],
      ),
    );
  }

  pageChooser() {
    switch (currentIndex) {
      case 0:
        return homePageLayout();
        break;
      case 1:
        return BrandListScreen();
        break;
      case 2:
        return AddCartScreen();
        break;
      case 3:
        return MyAccount();
        break;
    }
  }

  Widget communityPoll() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Body2Text(text: "Community poll"),
          SizedBox(
            height: 3.0,
          ),
          Body1Text(text: "Do you like nopCommerce?"),
          SizedBox(
            height: 3.0,
          ),
          radioButton(),
          SizedBox(
            height: 3.0,
          ),
          RaisedBtn(
            onPressed: () {},
            text: "VOTE",
          )
        ],
      ),
    );
  }

  void favoriteOrDetail(int index, List<ProductListModel> arrayList) {
    arrayList[index].attributes.length == 0 &&
            (arrayList[index].isGiftCard != null &&
                !arrayList[index].isGiftCard)
        ? onTapFavorite(index, arrayList[index])
        : navigatePush(ProductDetailScreen(productId: arrayList[index].id));
  }

  void onTapFavorite(int index, ProductListModel favorateProductList) {
    if (favorateProductList.attributes.length == 0 &&
        (favorateProductList.isGiftCard != null &&
            !favorateProductList.isGiftCard)) {
      //todo call api for add witshlist item

      if(!favorateProductList.IsProductInWishList){
        Constants.progressDialog(true, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      callApiForAddToWishList(favorateProductList);}
      else{
        Fluttertoast.showToast(msg: "Already in wishlist");
      }
    }
  }

  void errorDialog(String reason) {
    Constants.progressDialog(false, context,
        Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            children: <Widget>[
              new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      color: Colors.red,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Padding(
                                padding: new EdgeInsets.only(top: 30.0)),
                            new Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 60.0,
                            ),
                            new Padding(padding: new EdgeInsets.only(top: 5.0)),
                            new Text(
                              "Fail To Add In Wishlist",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                          ]),
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height / 4,
                      padding: new EdgeInsets.fromLTRB(17.0, 17.0, 17.0, 17.0),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Somthings went wrong try again later.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                            new Text(
                              "Reason $reason",
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.center,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                            new FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: new Text("OK"),
                              textColor: AppColor.appColor,
                            )
                          ]),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      await getSharedPreferences();
      await getShoppingCartItemNumber();
      await getSliderImage();
      await getCategoryList();
      await getFeatureProductList();
      await newsListParser();
      await newProductList();
      await bestSellerList();

      isLoading = false;

      if (this.mounted) {
        setState(() {});
      }
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
      Fluttertoast.showToast(
        msg: msg,
      );
      setState(() {
        newArrivalProductList.IsProductInWishList = true;
      });
    } else {
      String msg = result["value"];
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: msg,
      );
    }
  }

  Future getSliderImage() async {
    Map result = await GetImageSliderParser.callApi(
        "${Config.strBaseURL}orders/nivosliderimage");
    if (result["errorCode"] == "0") {
      mSliderImages = result["value"];
    } else {
    }
  }

  Future getCategoryList() async {
    Map result =
        await GetCategoryListParser.callApi("${Config.strBaseURL}categories");
    if (result["errorCode"] == "0") {
      categoryList = result["value"];
    } else {
    }
  }

  Future getFeatureProductList() async {
    Map result = await FeatureProductParser.callApi(
        "${Config.strBaseURL}products/featuredproducts?customerId="+customerId.toString());
    if (result["errorCode"] == "0") {
      featureProductList = result["value"];
    } else {    }
  }

  Future newProductList() async {
    Map result = await NewArrivalProductsParser.callApi(
        "${Config.strBaseURL}products/newarrivalproducts?customerId="+customerId.toString());
    if (result["errorCode"] == "0") {
      newArrivalProductList = result["value"];
    } else {    }
  }

  Future bestSellerList() async {
    Map result = await BestSellerProductParser.callApi(
        "${Config.strBaseURL}products/bestsellersproduct?customerId="+customerId.toString());
    if (result["errorCode"] == "0") {
      bestSellerProductList = result["value"];
    } else {}
  }

  Future getShoppingCartItemNumber() async {
    Map result = await AddProductIntoCartParser.callApiForGetCartItemTotal(
        "${Config.strBaseURL}shopping_cart_items/" + customerId.toString());
    if (result["errorCode"] == "0") {
      if (this.mounted) {
        Constants.cartItemCount = result["value"];
      }
    } else {  }
  }

  Future newsListParser() async {
    try {
      Map result = await NewsListParser.callApi("${Config.strBaseURL}newsapi");
      if (result["errorCode"] == "0") {
        newsArrayList = result["value"];
      } else {}

    } catch (e) {
      print(e);
    }
  }

  handleBackPress() {
    if (isBack) {
      exit(0);
    } else {
      isBack = true;
      Fluttertoast.showToast(
          msg: Constants.getValueFromKey(
              "nop.HomeScreen.backPress", resourceData));
    }

    Timer(Duration(seconds: 3), () => isBack = false);
  }

  void onClickNewsViewAll() {
    navigatePush(NewsListScreen());
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      selectedPoll = value;

      switch (selectedPoll) {
        case 1:
          Fluttertoast.showToast(
              msg: 'Excellent', toastLength: Toast.LENGTH_SHORT);
          break;
        case 2:
          Fluttertoast.showToast(msg: 'Good', toastLength: Toast.LENGTH_SHORT);
          break;
        case 3:
          Fluttertoast.showToast(msg: 'Poor', toastLength: Toast.LENGTH_SHORT);
          break;
        case 4:
          Fluttertoast.showToast(
              msg: 'Very bad', toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  void onClickCategoryItem(int index) {
    int categoryId = int.parse(categoryList[index].categoryId.toString());
    String categoryName = categoryList[index].categoryName.toString();
    navigatePush(SubCategoryScreen(
      parentCategoryId: categoryId,
      title: categoryName,
      description: categoryList[index].categoryDescription,
    ));
  }

  @override
  void onRefresh() {
    setState(() {
      Constants.cartItemCount = Constants.cartItemCount;
    });
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

class TitleRow extends StatefulWidget {
  final String title;
  final GestureTapCallback onPressViewAll;
  final Color color;

  TitleRow({this.title, this.onPressViewAll, this.color});

  @override
  _TitleRowState createState() => _TitleRowState();
}

class _TitleRowState extends State<TitleRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(child: TitleText(text: widget.title)),
          widget.onPressViewAll != null
              ? widget.color != null
                  ? FlatBtn(
                      onPressed: widget.onPressViewAll,
                      text: LanguageStrings.viewLabel,
                      color: widget.color,
                    )
                  : FlatBtn(
                      onPressed: widget.onPressViewAll,
                      text: LanguageStrings.viewLabel)
              : Container(),
        ],
      ),
    );
  }
}
