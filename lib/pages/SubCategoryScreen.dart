import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/CategoryListModel.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/pages/AddCartScreen.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductDetailScreen.dart';
import 'package:i_am_a_student/pages/ProductListScreen.dart';
import 'package:i_am_a_student/pages/SearchScreens/AutoCompleteSearchScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/GetProductListByCategory.dart';
import 'package:i_am_a_student/parser/GetSubCategoryListParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

class SubCategoryScreen extends StatefulWidget {
  final int parentCategoryId;
  final String title;
  final String description;

  SubCategoryScreen(
      {@required this.parentCategoryId,
      @required this.title,
      @required this.description});

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

   bool isInternet;

   bool isErrorInSubCategory = false;

   bool isErrorInRelatedProduct = false;

   bool isLoading;

   bool isError = false;

   double itemWidth;

   double itemHeight;

   List<CategoryListModel> subCategoryList = new List<CategoryListModel>();

   List<ProductListModel> relateProductList = new List<ProductListModel>();

   int productListItemPosition = 0;

   SharedPreferences prefs;

   int customerId;

   Function hp;

   Function wp;

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

  Widget buildLayout() {
    var size = MediaQuery.of(context).size;
    itemHeight = size.height / 5.5;
    itemWidth = size.width / 4.5;

    if (isInternet != null && isInternet) {
      if (!isErrorInSubCategory) {
        if (isLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
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
          if(this.mounted){
          setState(() {});}
        },
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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
        appBar: AppBar(
          title: new Text(widget.title),
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
        body: subCategoryList.length != 0 || relateProductList.length != 0
            ? listOfCategory()
            : noDataFoundScreen(),
      ),
    );
  }

  Widget listOfCategory() {
    return new ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: 8.0,
              right: 15.0,
              left: 15.0),
          child: subCategoryList.length != null && subCategoryList.length != 0
              ? categories("", subCategoryList)
              : Container(),
        ),
        typeTwoList("abc")
      ],
    );
  }

  Widget noDataFoundScreen() {
    return Container(
      child: Center(
        child: Image.asset(
          "images/notdatafound.png",
          height: 150,
          width: 150,
        ),
      ),
    );
  }

  Widget categories(String title, List<CategoryListModel> list) {
    if (list != null && list.length != 0) {
      return Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            widget.description != null
                ? productDescription(title)
                : Container(),
            new GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: 3,
              children: List.generate(list.length, (index) {
                return InkWell(
                  onTap: () {
                    onClickCategoryItem(index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 0.5)),
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(),
                            image: DecorationImage(
                              image: list[index]
                                      .categoryImageURl
                                      .toString()
                                      .isNotEmpty
                                  ? CachedNetworkImageProvider(
                                      list[index].categoryImageURl)
                                  : AssetImage(ImageStrings.imgPlaceHolder),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 5.0)),
                      Flexible(
                          child: SmallText(
                        text: list[index].categoryName,
                        maxLine: 2,
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

  Widget productDescription(String title) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TitleRowForDescription(
          title: Constants.getValueFromKey("nop.SubCategoryScreen.ProductDescription", resourceData),
          resourceData: resourceData,
          onPressViewAll: () {
            onClickViewMoreAll();
          },
        ),
        Container(
          height: 50.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Html(
                  data: widget.description,
                  padding: EdgeInsets.all(8.0),
                  onLinkTap: (url) async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        title.isNotEmpty ? TitleRow(title: title) : Container(),
      ],
    );
  }

  Widget typeTwoList(String title) {
    if (!isErrorInRelatedProduct && relateProductList.length != 0) {
      return new GridView.count(
        shrinkWrap: true,
        primary: false,
        childAspectRatio: (1 / 1.45),
        crossAxisCount: 2,
        padding: EdgeInsets.all(8.0),
        children: List.generate(relateProductList.length, (index) {
          return InkWell(
            onTap: () {
              navigatePush(ProductDetailScreen(
                productId: relateProductList[index].id,
              ));
            },
            child: new Card(
              child: Column(
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.height/4.5,
                    width: MediaQuery.of(context).size.width/1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(wp(1)),
                          topLeft: Radius.circular(wp(1))),
                      child: CachedNetworkImage(
                        imageUrl: relateProductList[index].image,
                        placeholder: (context, url) => Image.asset(
                          ImageStrings.imgPlaceHolder,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: hp(0.11)),
                  new Container(
                    margin: EdgeInsets.only(
                      left: wp(1),
                    ),
                    child: new Stack(
                      alignment: Alignment(0.9, -1.3),
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.only(top: hp(6.50)),
                            child: new GestureDetector(
                              onTap: () {
                                favoriteOrDetail(index, relateProductList);
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
                                  relateProductList[index].IsProductInWishList?Icons.favorite:Icons.favorite_border,
                                  color: AppColor.appColor,
                                  size: 15.0,
                                ),
                              ),
                            )),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Body1Text(
                                maxLine: 2,
                                text: relateProductList[index].name),
                            SizedBox(
                              height: hp(0.56),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(bottom: hp(0.56)),
                              child: new RatingBar(
                                size: hp(2.25),
                                rating: double.parse(
                                    relateProductList[index].rating.toString()),
                                color: AppColor.appColor,
                              ),
                            ),
                            oldPriceText(index),
                            SizedBox(height: hp(1)),
                            price(relateProductList[index])
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
      );
    } else {
      return Container();
    }
  }

  Widget price(ProductListModel model) {
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

  Widget oldPriceText(int index) {
    if (relateProductList[index].oldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${relateProductList[index].oldPrice}",
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

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      await getCategoryList();
      if (!isErrorInSubCategory) {
        await getSharedPrefHere();
        await getRelatedProduct();
      }
      isLoading = false;
      if(this.mounted){
      setState(() {});}
    }
  }

  Future getSharedPrefHere() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future callApiForAddToWishList(ProductListModel newArrivalProductList) async {
    String url =
        "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=$customerId&productId=${newArrivalProductList.id}&shoppingCartTypeId=2&quantity=${newArrivalProductList.minQuntity}&attributeControlIds=0&rentalStartDate=null&rentalEndDate=null";
    Map result = await AddProductIntoCartParser.callApi2(url);
    if (result["errorCode"] == "0") {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey("nop.SubCategoryScreen.AddedWishList", resourceData) ,
      );
      setState(() {
        newArrivalProductList.IsProductInWishList = true;
      });
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey("nop.SubCategoryScreen.NotAddedWishList", resourceData),
      );
    }
  }

  Future getCategoryList() async {
    Map result = await GetSubCategoryListParser.callApi(
        "${Config.strBaseURL}categories", widget.parentCategoryId);
    if (result["errorCode"] == "0") {
      subCategoryList = result["value"];
    } else {
      isErrorInSubCategory = true;
    }
  }

  Future getRelatedProduct() async {
    Map result = await GetProductListByCategoryParser.callApi(
        "${Config.strBaseURL}categories/IncludeProductsFromSubcategories?customerId=$customerId&CategoryId="+widget.parentCategoryId.toString());
    if (result["errorCode"] == "0") {
      relateProductList = result["value"];
    } else {
      isErrorInRelatedProduct = true;
    }
  }


   void onClickCategoryItem(int index) {
     navigatePush(ProductListScreen(
       manufactureId: subCategoryList[index].categoryId.toString(),
       categoryName: subCategoryList[index].categoryName,
       isFromSubCategory: true,
     ));
   }

  void onClickViewMoreAll() {}

  void onTapFavorite(int index, ProductListModel relateProductList) {
    if (relateProductList.attributes.length == 0 &&
        (relateProductList.isGiftCard != null &&
            !relateProductList.isGiftCard)) {
      //todo call api for add wishlist item
      if(!relateProductList.IsProductInWishList){
      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      callApiForAddToWishList(relateProductList);}
    else{
      Fluttertoast.showToast(msg: "Already in wishlist");
    }
  }}

  void favoriteOrDetail(int index, List<ProductListModel> arrayList) {
    arrayList[index].attributes.length == 0 &&
            (arrayList[index].isGiftCard != null &&
                !arrayList[index].isGiftCard)
        ? onTapFavorite(index, arrayList[index])
        : navigatePush(ProductDetailScreen(productId: arrayList[index].id));
  }

  void onClickSearchOption() {
    navigatePush(AutoCompleteSearchScreen());
  }

  void onClickCartOption() {
    navigatePush(AddCartScreen(isFromProductDetailScreen: true));
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    if(this.mounted){
    setState(() {});}
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

class TitleRowForDescription extends StatefulWidget {
  final String title;
  final GestureTapCallback onPressViewAll;
  final Color color;
  final Map resourceData;

  TitleRowForDescription({this.title, this.onPressViewAll, this.color, this.resourceData});

  @override
  _TitleRowForDescriptionState createState() => _TitleRowForDescriptionState();
}

class _TitleRowForDescriptionState extends State<TitleRowForDescription> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: TitleText(text: widget.title)),
        widget.onPressViewAll != null
            ? widget.color != null
                ? FlatBtn(
                    onPressed: widget.onPressViewAll,
                    text: Constants.getValueFromKey("Admin.SalesReport.Incomplete.View", widget.resourceData).toUpperCase(),
                    color: widget.color,
                  )
                : FlatBtn(onPressed: widget.onPressViewAll, text: Constants.getValueFromKey("nop.SubCategoryScreen.ReadMore", widget.resourceData))
            : Container(),
      ],
    );
  }
}
