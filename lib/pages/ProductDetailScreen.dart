import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/models/attributes/CheckBoxAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/ColorSquareAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/DatePickerAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/DropDownAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/FileChooserAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/ImageSquareAttribute.dart';
import 'package:i_am_a_student/models/attributes/RadioButtonAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/TextFormFieldAttributeModel.dart';
import 'package:i_am_a_student/models/productDetail/AttributeModel.dart';
import 'package:i_am_a_student/models/productDetail/ProductDetailModel.dart';
import 'package:i_am_a_student/pages/AddCartScreen.dart';
import 'package:i_am_a_student/pages/AddReviewScreen.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/FullImageScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductItem.dart';
import 'package:i_am_a_student/pages/ProductListScreen.dart';
import 'package:i_am_a_student/pages/SearchScreens/AutoCompleteSearchScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/CheckConditionalAttributeParser.dart';
import 'package:i_am_a_student/parser/CustomerAlsoBoughtProducts.dart';
import 'package:i_am_a_student/parser/GetProductDetailParser.dart';
import 'package:i_am_a_student/parser/RelatedProductListParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:i_am_a_student/utils/productDetailTextS.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'WishListScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final productId;
  ProductDetailScreen({@required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isError = false;
  bool isErrorInRelatedProducts = false;
  bool isInternet;
  bool isLoading;
  bool isButtonEnable = true;

  static const platform = const MethodChannel('htmlView');

  ProductDetailModel productDetailModel;

  List<ProductListModel> relatedProductsList = new List<ProductListModel>();
  List<ProductListModel> customerAlsoBoughtListProductsList =
      new List<ProductListModel>();

  int customerId;

  TextEditingController customerEnterPriceController =
      new TextEditingController();

  TextEditingController dateControllerForStartRentalDate =
      new TextEditingController();
  TextEditingController dateControllerForEndRentalDate = new TextEditingController();
  TextEditingController recipientNameController = new TextEditingController();
  TextEditingController yourNameController = new TextEditingController();
  TextEditingController recipientEmailController = new TextEditingController();
  TextEditingController yourMessageController = new TextEditingController();
  TextEditingController yourEmailController = new TextEditingController();

  SharedPreferences prefs;

  DateTime startDate;
  DateTime endDate;
  String priceOfRent;

  bool isExpandedDescription = false;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  List<String> hideAttributeIds = new List<String>();

  Map resourceData;

  Widget recipientNameFormField;
  Widget yourNameFormField;
  Widget yourEmailFormField;

  Widget recipientEmailFormField;

  Widget messageFormField;


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
      return NoInternetScreen(onPressedRetyButton: () {
        internetConnection();
      });
    }
    return new Scaffold(
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
          ? prefix0.TextDirection.rtl
          : prefix0.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
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
            new InkWell(
              onTap: () {
                onClickShareOption();
              },
              child: new Container(
                child: new Icon(
                  Icons.share,
                ),
                padding: EdgeInsets.only(right: 15.0),
              ),
            ),
          ],
        ),
        body: productLayout(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: bottomNavigation2(),
        ),
        floatingActionButton: floatingButton(),
      ),
    );
  }

  Widget productLayout() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return new SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              maxWidth: viewportConstraints.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Card(
                elevation: 0.0,
                margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
                child: new Container(
                  padding: EdgeInsets.only(
                      top: 15.0,
                      left: 15.0,
                      right: 15.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      productDetailModel.imageList.length != 0
                          ? largeImageLayout()
                          : new Container(),
                      SizedBox(
                        height: 5.0,
                      ),
                      freeDelivery(),
                      TitleText(
                          text: productDetailModel.productTitle, maxLine: 4),
                      SizedBox(height: 10.0),
                      new Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                productDetailModel.approvedRatingSum != null
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                10.0),
                                        child: RatingBar(
                                          rating: double.parse(
                                              productDetailModel
                                                  .approvedRatingSum
                                                  .toString()),
                                          color: AppColor.appColor,
                                          size: 20.0,
                                        ),
                                      )
                                    : Container(),
                                productDetailModel.manufacturesList != null &&
                                        productDetailModel
                                                .manufacturesList.length !=
                                            0
                                    ? manufacturer()
                                    : new Container(),
                                productDetailModel.sku != null &&
                                        productDetailModel.sku.isNotEmpty
                                    ? skuText("${Constants.getValueFromKey("PDFInvoice.SKU", resourceData)} : ${productDetailModel.sku}")
                                    : new Container(),
                              ],
                            ),
                          ),
                          favoriteBtn(),
                        ],
                      ),
                      productDetailModel.hasDownloadSample != null &&
                              productDetailModel.hasDownloadSample
                          ? downloadSample()
                          : new Container(),
                      availabilityText(),
                      shortDescription(),
                    ],
                  ),
                ),
              ),
              giftCardFields(productDetailModel),
              rentalPrice(),
              customerEnterPrice(),
              reviewCard(),
              groupProductItem(),
              stockAndQuantityCard(),
              fullDescriptionCard(),
              attributeCard(),
              productSpecification(),
              productTags(),
              SizedBox(
                height: 10.0,
              ),
              customerAlsoBoughtThoseProducts(),
              SizedBox(
                height: 10.0,
              ),
              relatedProducts(),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget favoriteBtn() {
    if (productDetailModel.productType ==
        Constants.typeOfGroupProductDetailPage) {
      return Container();
    }
    return new Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              onClickAddToWishList();
            },
            child: new Container(
              height: 45.0,
              width: 45.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.appColor),
              child: Center(child: Icon(productDetailModel.IsProductInWishList ? Icons.favorite_border : Icons.favorite, color: AppColor.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigation2() {
    if (productDetailModel.productType ==
        Constants.typeOfGroupProductDetailPage) {
      return null;
    }

    Widget oldPrice;
    Widget price;

    if (productDetailModel.oldPrice != null) {
      oldPrice = oldPriceText("${productDetailModel.oldPrice.toString()}");
    } else {
      oldPrice = Container();
    }
    if (productDetailModel.price != null) {
      if (productDetailModel.isRental) {
        if (priceOfRent == null) {
          price = HeadlineText(
            text: "${productDetailModel.price}",
            color: AppColor.appColor,
          );
        } else {
          price = HeadlineText(
            text: "$priceOfRent",
            color: AppColor.appColor,
          );
        }
      } else {
        price = HeadlineText(
          text: "${productDetailModel.price}",
          color: AppColor.appColor,
        );
      }
    } else {
      price = Container();
    }



    if (productDetailModel.isDisableCartButton != null &&
        productDetailModel.isDisableCartButton) {
      isButtonEnable = false;
    }

    if (productDetailModel.attributes.length > 0 ||
        (productDetailModel.isGiftCard != null &&
            productDetailModel.isGiftCard)) {
      isButtonEnable = false;
    }

    if (productDetailModel.quantityByUser == null) {
      productDetailModel.quantityByUser =
          productDetailModel.minimumOrderQuantityCount;
    }

    return new Container(
        alignment: Alignment.bottomCenter,
        height: 65.0,
        padding: EdgeInsets.only(left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  oldPrice,
                  price,
                ],
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      color: AppColor.appColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  height: 50,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new InkWell(
                        onTap: productDetailModel.minimumOrderQuantityCount ==
                                productDetailModel.quantityByUser
                            ? null
                            : () {
                                setState(() {
                                  productDetailModel.quantityByUser--;
                                });
                              },
                        child: new Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.0,
                                  color: productDetailModel
                                              .minimumOrderQuantityCount ==
                                          productDetailModel.quantityByUser
                                      ? Colors.grey
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(0.0)),
                          child: Icon(Icons.remove,
                              size: 15.0,
                              color: productDetailModel
                                          .minimumOrderQuantityCount ==
                                      productDetailModel.quantityByUser
                                  ? Colors.grey
                                  : Colors.white),
                        ),
                      ),
                      new SizedBox(
                        width: 15.0,
                      ),
                      new TitleText(
                          text:productDetailModel.quantityByUser.toString(),
                          color: Colors.white),
                      new SizedBox(
                        width: 15.0,
                      ),
                      new InkWell(
                        onTap: productDetailModel.maximumOrderQuantityCount ==
                                productDetailModel.quantityByUser
                            ? null
                            : () {
                                setState(() {
                                  productDetailModel.quantityByUser++;
                                });
                              },
                        child: new Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.0,
                                color: productDetailModel
                                            .maximumOrderQuantityCount ==
                                        productDetailModel.quantityByUser
                                    ? Colors.grey
                                    : Colors.white),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Icon(Icons.add,
                              size: 15.0,
                              color: productDetailModel
                                          .maximumOrderQuantityCount ==
                                      productDetailModel.quantityByUser
                                  ? Colors.grey
                                  : Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));

  }

  Widget floatingButton() {
    if (productDetailModel.productType ==
        Constants.typeOfGroupProductDetailPage) {
      return null;
    }

    return new InkWell(
      onTap: () {
        onClickAddToCart();
      },
      child: AvatarGlow(
        startDelay: Duration(milliseconds: 1000),
        glowColor: AppColor.appColor,
        endRadius: 40.0,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        child: Material(
          elevation: 8.0,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: AppColor.white,
            child: Icon(
              Icons.add_shopping_cart,
              color: AppColor.appColor,
              size: 20.0,
            ),
            radius: 25.0,
          ),
        ),
      ),
    );
  }

  Widget largeImageLayout() {
    if (productDetailModel.imageList.length > 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: (){
                navigatePush(FullImageScreen(productDetailModel.imageList, "",
                    productDetailModel.currentImageIndex));
              },
              child: Container(
                height: 255.0,
                child: new CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: productDetailModel.currentImageIndex != null
                        ? productDetailModel
                            .imageList[productDetailModel.currentImageIndex]
                            .largeImage
                        : productDetailModel.imageList[0].largeImage,
                    placeholder: (context, url) => new Image.asset(ImageStrings.imgPlaceHolder)),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Container(width: 70.0, child: imageList()),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget imageList() {
    int currentImageIndex;
    bool showMore = false;

    if (productDetailModel.imageList.length != 0) {
      if (productDetailModel.imageList.length > 4) {
        showMore = true;
      }
      if (productDetailModel.currentImageIndex == null) {
        productDetailModel.currentImageIndex = 0;
      } else {
        currentImageIndex = productDetailModel.currentImageIndex;
      }
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: showMore ? 4 : productDetailModel.imageList.length,
        itemBuilder: (BuildContext context, int index) {
          if (showMore && index == 3) {
            return Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: new Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 0.1),
                ),
                child: new Padding(
                  padding: EdgeInsets.all(1.5),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: productDetailModel.imageList[index].url,
                        fit: BoxFit.cover,
                        placeholder:(context, url) =>  Image.asset(
                          ImageStrings.imgPlaceHolder,
                          height: 60.0,
                          width: 60.0,
                        ),
                      ),
                      new Container(
                        color: Colors.black38,
                        child: Center(
                          child: Body1Text(
                            text:
                                "+${productDetailModel.imageList.length - 4}",
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                setState(() {
                  productDetailModel.currentImageIndex = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 0.5,
                        color: currentImageIndex != null &&
                                currentImageIndex == index
                            ? AppColor.appColor
                            : AppColor.black.withAlpha(50)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.5),
                    child: CachedNetworkImage(
                      imageUrl: productDetailModel.imageList[index].url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        ImageStrings.imgPlaceHolder,
                        height: 60.0,
                        width: 60.0,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    } else {
      return Container();
    }
  }

  Widget skuText(String text) {
    if (productDetailModel.productType ==
        Constants.typeOfGroupProductDetailPage) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SmallText(text: text),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget manufacturer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SubTitleText(
              text:"${Constants.getValueFromKey("Admin.Catalog.Products.List.SearchManufacturer", resourceData)}:",
              maxLine: 2,
            ),
            SizedBox(
              width: 10.0,
            ),
            Wrap(
              children: List<Widget>.generate(
                  productDetailModel.manufacturesList.length, (int index) {
                if (index == (productDetailModel.manufacturesList.length - 1)) {
                  return Body1Text(
                    text: "${productDetailModel.manufacturesList[index].name}.",
                    color: AppColor.appColor,
                  );
                } else {
                  return Body1Text(
                    text:"${productDetailModel.manufacturesList[index].name},",
                    color: AppColor.appColor,
                  );
                }
              }),
            )
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget downloadSample() {
    if (!productDetailModel.hasDownloadSample) {
      return Container();
    }
    if (productDetailModel.downLoadSampleUrl == null ||
        productDetailModel.downLoadSampleUrl.toString().isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RaisedBtn(
          text:Constants.getValueFromKey("Products.DownloadSample", resourceData).toUpperCase(),
          onPressed: () async {
            await downloadFile(
                productDetailModel.downLoadSampleUrl, "abc.txt");
          },
          elevation: 0.0,
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget priceText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                HeadlineText(
                    text: "${productDetailModel.price}",
                    color: AppColor.appColor),
                SizedBox(
                  width: 5.0,
                ),
                productDetailModel.oldPrice != 0
                    ? oldPriceText("${productDetailModel.oldPrice}")
                    : Container(),
              ],
            ),
            freeDelivery(),
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget oldPriceText(String price) {
    return new RichText(
      maxLines: 1,
      text: new TextSpan(
        text: price,
        style: new TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
            fontSize: 16.0),
      ),
    );
  }

  Widget freeDelivery() {
    if (productDetailModel.isFreeShipping != null &&
        productDetailModel.isFreeShipping) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 100.0,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.green,
                borderRadius: BorderRadius.circular(4.0)),
            padding:
                EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0, bottom: 6.0),
            child: Center(
                child: SmallText(
              text: Constants.getValueFromKey("nop.ProductDetailScreen.freeDelivery", resourceData),
              color: AppColor.white,
            )),
          ),
          SizedBox(height: 10.0),
        ],
      );
    } else {
      return Container();
    }
  }


  Widget reviewCard() {
    if (!productDetailModel.isAllowForReview) {
      if (productDetailModel.approvedTotalReviews == 0 &&
          productDetailModel.approvedRatingSum == 0) {
        return Container();
      }
    }
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                      top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Body1Text(
                        text: "${productDetailModel.approvedRatingSum}",
                        color: AppColor.white,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Icon(
                        Icons.star,
                        size: 14.0,
                        color: AppColor.white,
                      )
                    ],
                  ),
                ),
                new SizedBox(
                  width: 10.0,
                ),
                new Body2Text(text: "Based on"),
                new InkWell(
                  onTap: () {
                    if (productDetailModel.isAllowForReview) {
                      navigatePush(AddReviewScreen(
                        productId: productDetailModel.productId.toString(),
                        productImage:
                            productDetailModel.imageList[0].largeImage,
                        getProductDetailModel: productDetailModel,
                      ));
                    }
                  },
                  child: Body2Text(
                    text: "${productDetailModel.approvedTotalReviews} Reviews",
                    color: AppColor.appColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 1.0,
              color: Colors.grey[300],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SubTitleText(text: "Write your own review"),
                      SizedBox(
                        height: 5.0,
                      ),
                      Body1Text(text: "Tell evoryone about it!"),
                    ],
                  ),
                ),
                FlatBtn(
                    onPressed: productDetailModel.isAllowForReview
                        ? () {
                            navigatePush(AddReviewScreen(
                              productId:
                                  productDetailModel.productId.toString(),
                              productImage:
                                  productDetailModel.imageList[0].largeImage,
                              getProductDetailModel: productDetailModel,
                            ));
                          }
                        : null,
                    text: "Add Review".toUpperCase())
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget availabilityText() {
    if (productDetailModel.productType ==
        Constants.typeOfGroupProductDetailPage) {
      return Container();
    }
    Color textColor;
    String availabilityText = "";

    if (productDetailModel.isDisplayStockAvailability) {
      if (productDetailModel.isDisplayAvailabilityStockQuantityCount) {
        if (productDetailModel.stockQuantity < 1) {
          availabilityText = "Out Of Stock";
          textColor = Colors.red;
        } else {
          availabilityText =
              "${productDetailModel.stockQuantity} Products available in stock";
        }
      } else if (productDetailModel.stockQuantity > 0) {
        availabilityText = "Product available in stock";
      }
    }

    return availabilityText.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Body1Text(
              text: availabilityText,
              color: textColor,
            ),
          )
        : Container();
  }

  Widget stockAndQuantityCard() {
    if (productDetailModel.productType ==
        Constants.typeOfGroupProductDetailPage) {
      return Container();
    }
    if (productDetailModel.hasTierPrice != null &&
        !productDetailModel.hasTierPrice) {
      return Container();
    }
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: tierPriceWidget(),
      ),
    );
  }

  Widget tierPriceWidget() {
    if (productDetailModel.tierPriceModelList.length == 0) {
      return Container();
    }
    return Container(
      height: 100.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (productDetailModel.tierPriceModelList.length + 1),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: 100.0,
                  minWidth: 10.0,
                ),
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                  left: BorderSide(color: Colors.grey[200]),
                  bottom: BorderSide(color: Colors.grey[200]),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200])),
                              color: AppColor.grey),
                          child: Center(child: Body1Text(text: "Quantity"))),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Body1Text(text: "Price"))),
                    ),
                  ],
                ),
              );
            } else if (index == productDetailModel.tierPriceModelList.length) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: 100.0,
                  minWidth: 10.0,
                ),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey[200])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200])),
                              color: AppColor.grey),
                          child: Center(
                              child: Body1Text(
                                  text: "${productDetailModel.tierPriceModelList[index - 1].quantity.toString()}+"))),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Body1Text(
                            text: productDetailModel
                                .tierPriceModelList[index - 1].price
                                .toString(),
                            maxLine: 2,
                            color: AppColor.errorColor,
                          ))),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: 100.0,
                  minWidth: 10.0,
                ),
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                  left: BorderSide(color: Colors.grey[200]),
                  bottom: BorderSide(color: Colors.grey[200]),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200])),
                              color: AppColor.grey),
                          child: Center(
                              child: Body1Text(
                                  text:
                                      "${productDetailModel.tierPriceModelList[index - 1].quantity.toString()}+"))),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Body1Text(
                            text: productDetailModel
                                .tierPriceModelList[index - 1].price
                                .toString(),
                            maxLine: 2,
                            color: AppColor.errorColor,
                          ))),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget fullDescriptionCard() {
    String descriptionText = "";
    int maximumLine = 5;
    if (productDetailModel.longDescription == null ||
        productDetailModel.longDescription.isEmpty) {
      return Container();
    } else {
      descriptionText = productDetailModel.longDescription;
    }

    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: SubTitleText(
                  text: "Discription",
                )),
                productDetailModel.longDescription != null &&
                        productDetailModel.longDescription.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          isExpandedDescription = !isExpandedDescription;
                          setState(() {});
                        },
                        icon: Icon(
                          isExpandedDescription
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: AppColor.appColor,
                        ))
                    : Container()
              ],
            ),
            Body1Text(
              text: "$descriptionText",
              align: TextAlign.justify,
              maxLine: isExpandedDescription ? null : maximumLine,
            )
          ],
        ),
      ),
    );
  }

  Widget shortDescription() {
    String descriptionText = "";
    if (productDetailModel.shortDescription == null ||
        productDetailModel.shortDescription.isEmpty) {
      return Container();
    } else {
      descriptionText = productDetailModel.shortDescription;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Html(
        data: descriptionText,
        onLinkTap: (url) async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }

  Widget attributeCard() {
    if (productDetailModel.attributes.length == 0) {
      return Container();
    }
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(
                productDetailModel.attributes.length, (int index) {
              if (hideAttributeIds.contains(
                  productDetailModel.attributes[index].mapId.toString())) {
                return Container();
              }
              switch (
                  productDetailModel.attributes[index].attributeControlTypeId) {
                case 1:
                  return dropDownList(productDetailModel.attributes[index]);
                  break;
                case 2:
                  return radioList(productDetailModel.attributes[index]);
                  break;
                case 3:
                  return checkBoxList(productDetailModel.attributes[index]);
                  break;
                case 4:
                  return textFormField(productDetailModel.attributes[index]);
                  break;
                case 10:
                  return multiTextFormField(
                      productDetailModel.attributes[index]);
                  break;
                case 40:
                  return colorSquare(productDetailModel.attributes[index]);
                  break;
                case 45:
                  return imageSquare(productDetailModel.attributes[index]);
                  break;
                case 50:
                  return readOnlyCheckBoxList(
                      productDetailModel.attributes[index]);
                  break;
                case 20:
                  return datePicker(productDetailModel.attributes[index]);
                  break;
                case 30:
                  return filePicker(productDetailModel.attributes[index]);
                  break;
                default:
                  return Container();
                  break;
              }
            })),
      ),
    );
  }

  Widget dropDownList(AttributeModel attributeModel) {
    DropDownAttributeModel model = attributeModel.dropDownAttributeModel;
    attributeModel.currentValue = model.currentValue;

    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),

      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        attributeModel.attributeName != null &&
                attributeModel.attributeName.toString().isNotEmpty
            ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
            : Container(),
        SizedBox(
          height: 5.0,
        ),
        new DropdownButton(
          hint: Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: Text(
              attributeModel.labelText != null &&
                      attributeModel.labelText.isNotEmpty
                  ? attributeModel.labelText
                  : Constants.getValueFromKey("Admin.Common.Select", resourceData),
            ),
          ),
          isExpanded: true,
          iconSize: 35.0,
          value: model.currentValue,
          items: model.dropDownItems,
          onChanged: (value) async {
            model.currentValue = value;
            attributeModel.error = null;
            attributeModel.currentValue = value;
            String request = makeRequestStringForConditionalAttribute();
            Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
            await callApiForConditionalAttribute(request);
            Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
            if(this.mounted){
              setState(() {});}
          },
          isDense: true,
        ),
        errorText(attributeModel),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget radioList(AttributeModel attributeModel) {
    RadioButtonAttributeModel model = attributeModel.radioButtonAttributeModel;
    attributeModel.currentValue = model.currentValue;
    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        attributeModel.attributeName != null &&
                attributeModel.attributeName.toString().isNotEmpty
            ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
            : Container(),
        SizedBox(
          height: 5.0,
        ),
        new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(model.values.length, (int index) {
              return new Row(
                children: <Widget>[
                  Radio(
                    value: model.values[index],
                    groupValue: model.currentValue,
                    onChanged: (value) async {
                      model.currentValue = value;
                      attributeModel.error = null;
                      String request =
                          makeRequestStringForConditionalAttribute();
                      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                      await callApiForConditionalAttribute(request);
                      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                      if(this.mounted){
                        setState(() {});}
                    },
                  ),
                  InkWell(
                      onTap: () async {
                        model.currentValue = model.values[index];
                        attributeModel.error = null;
                        String request =
                            makeRequestStringForConditionalAttribute();
                        Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                        await callApiForConditionalAttribute(request);
                        Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                        if(this.mounted){
                          setState(() {});}
                      },
                      child: Container(
                        width: 250.0,
                        height: 40.0,
                        alignment: Alignment.centerLeft,
                        child: Body1Text(
                            text: model.values[index].name, maxLine: 1),
                      ))
                ],
              );
            })),
        errorText(attributeModel),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget checkBoxList(AttributeModel attributeModel) {
    CheckBoxAttributeModel model = attributeModel.checkBoxAttributeModel;

    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),
      ],
    );

    for (int i = 0; i < model.values.length; i++) {
      if (attributeModel.currentValueList.length != 0) {
        if (attributeModel.currentValueList
            .contains(attributeModel.values[i])) {
          if (!model.values[i].isPreSelected) {
            attributeModel.currentValueList.remove(model.values[i]);
          }
        } else {
          if (model.values[i].isPreSelected) {
            attributeModel.currentValueList.add(model.values[i]);
          }
        }
      } else {
        if (model.values[i].isPreSelected) {
          attributeModel.currentValueList.add(model.values[i]);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        attributeModel.attributeName != null &&
                attributeModel.attributeName.toString().isNotEmpty
            ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
            : Container(),
        SizedBox(
          height: 5.0,
        ),
        new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(model.values.length, (int index) {
              return new Row(
                children: <Widget>[
                  new Checkbox(
                    value: model.values[index].isPreSelected,
                    onChanged: (value) async {
                      model.values[index].isPreSelected = value;
                      attributeModel.error = null;
                      String request =
                          makeRequestStringForConditionalAttribute();
                      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                      await callApiForConditionalAttribute(request);
                      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                      if(this.mounted){
                        setState(() {});}
                    },
                  ),
                  InkWell(
                      onTap: () async {
                        model.values[index].isPreSelected =
                            !model.values[index].isPreSelected;
                        attributeModel.error = null;
                        String request =
                            makeRequestStringForConditionalAttribute();
                        Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                        await callApiForConditionalAttribute(request);
                        Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                        if(this.mounted){
                          setState(() {});}
                      },
                      child: Container(
                        width: 250.0,
                        height: 40.0,
                        alignment: Alignment.centerLeft,
                        child: Body1Text(
                            text: model.values[index].name, maxLine: 1),
                      ))
                ],
              );
            })),
        errorText(attributeModel),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget textFormField(AttributeModel attributeModel) {
    TextFormFieldAttributeModel model = attributeModel.textFormFieldAttributeModel;
    if (attributeModel.textEditingController.text.isEmpty &&
        model.value != null &&
        model.value.isNotEmpty) {
      attributeModel.textEditingController.text = model.value;
    }
    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),
      ],
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          attributeModel.attributeName != null &&
                  attributeModel.attributeName.toString().isNotEmpty
              ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
              : Container(),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.done,
            controller: attributeModel.textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: model.hint,
            ),
            onFieldSubmitted: (value) async {
              FocusScope.of(context).requestFocus(new FocusNode());
              if (attributeModel.textEditingController.text.isNotEmpty) {
                attributeModel.error = null;
                String request = makeRequestStringForConditionalAttribute();
                Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                await callApiForConditionalAttribute(request);
                Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                if(this.mounted){
                  setState(() {});}              }
            },
          ),
          errorText(attributeModel),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget multiTextFormField(AttributeModel attributeModel) {
    TextFormFieldAttributeModel model =
        attributeModel.textFormFieldAttributeModel;
    if (attributeModel.textEditingController.text.isEmpty &&
        model.value != null &&
        model.value.isNotEmpty) {
      attributeModel.textEditingController.text = model.value;
    }
    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),
      ],
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          attributeModel.attributeName != null &&
                  attributeModel.attributeName.toString().isNotEmpty
              ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
              : Container(),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: attributeModel.textEditingController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: model.hint,
            ),
            onFieldSubmitted: (value) async {
              FocusScope.of(context).requestFocus(new FocusNode());
              if (attributeModel.textEditingController.text.isNotEmpty) {
                attributeModel.error = null;
                String request = makeRequestStringForConditionalAttribute();
                Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                await callApiForConditionalAttribute(request);
                Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                setState(() {});
              }
            },
          ),
          errorText(attributeModel),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget colorSquare(AttributeModel attributeModel) {
    ColorSquareAttributeModel model = attributeModel.colorSquareAttributeModel;
    if (model.selectedColorBox != null) {
      attributeModel.currentValue =
          attributeModel.values[model.selectedColorBox];
    }

    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),

      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        attributeModel.attributeName != null &&
                attributeModel.attributeName.toString().isNotEmpty
            ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
            : Container(),
        SizedBox(
          height: 10.0,
        ),
        new Container(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.values.length,
            itemBuilder: (BuildContext context, int index) {
              Color color = Colors.grey[100];
              if (model.values[index].color != null) {
                String strColor = model.values[index].color
                    .substring(1, model.values[index].color.length);
                String colorInInt = "0xFF$strColor";
                color = Color(int.parse(colorInInt));
              }

              if (model.selectedColorBox != null &&
                  model.selectedColorBox == index) {
                if (model.values[index].productImageId != null) {
                  for (int i = 0;
                      i < productDetailModel.imageList.length;
                      i++) {
                    if (model.values[index].productImageId ==
                        productDetailModel.imageList[i].imageId) {
                      productDetailModel.currentImageIndex = i;
                    }
                  }
                }
              }

              return new GestureDetector(
                onTap: () async {
                  model.selectedColorBox = index;
                  attributeModel.error = null;
                  if (model.values[index].productImageId != null) {
                    for (int i = 0;
                        i < productDetailModel.imageList.length;
                        i++) {
                      if (model.values[index].productImageId ==
                          productDetailModel.imageList[i].imageId) {
                        setState(() {
                          productDetailModel.currentImageIndex = i;
                        });
                      }
                    }
                  }
                  String request = makeRequestStringForConditionalAttribute();
                  Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                  await callApiForConditionalAttribute(request);
                  Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                  if(this.mounted){
                    setState(() {});}
                },
                child: new Container(
                  width: 52.0,
                  margin: EdgeInsets.only(right: 15.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 0.5,
                        color: model.selectedColorBox != null &&
                                model.selectedColorBox == index
                            ? color
                            : AppColor.black.withAlpha(50)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.5),
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      color: color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        errorText(attributeModel),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget imageSquare(AttributeModel attributeModel) {
    ImageSquareAttribute model = attributeModel.imageSquareAttribute;
    if (model.selectedImageBox != null) {
      attributeModel.currentValue =
          attributeModel.values[model.selectedImageBox];
    }

    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        attributeModel.attributeName != null &&
                attributeModel.attributeName.toString().isNotEmpty
            ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
            : Container(),
        SizedBox(
          height: 10.0,
        ),
        new Container(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.values.length,
            itemBuilder: (BuildContext context, int index) {
              if (model.selectedImageBox != null &&
                  model.selectedImageBox == index) {
                if (model.values[index].productImageId != null) {
                  for (int i = 0;
                      i < productDetailModel.imageList.length;
                      i++) {
                    if (model.values[index].productImageId ==
                        productDetailModel.imageList[i].imageId) {
                      productDetailModel.currentImageIndex = i;
                    }
                  }
                }
              }

              return new GestureDetector(
                onTap: () async {
                  model.selectedImageBox = index;
                  attributeModel.error = null;
                  if (model.values[index].productImageId != null) {
                    for (int i = 0;
                        i < productDetailModel.imageList.length;
                        i++) {
                      if (model.values[index].productImageId ==
                          productDetailModel.imageList[i].imageId) {
                        setState(() {
                          productDetailModel.currentImageIndex = i;
                        });
                      }
                    }
                  }
                  String request = makeRequestStringForConditionalAttribute();
                  Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                  await callApiForConditionalAttribute(request);
                  Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                  if(this.mounted){
                    setState(() {});}
                },
                child: new Container(
                  width: 60.0,
                  margin: EdgeInsets.only(right: 15.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 0.5,
                        color: model.selectedImageBox != null &&
                                model.selectedImageBox == index
                            ? AppColor.appColor
                            : AppColor.black.withAlpha(50)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.5),
                    child: model.values[index].imageUrl != null &&
                            model.values[index].imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: model.values[index].imageUrl,
                            placeholder: (context, url) => Image.asset(
                              ImageStrings.imgPlaceHolder,
                              height: 60.0,
                              width: 60.0,
                            ),
                          )
                        : Image.asset(
                            ImageStrings.imgPlaceHolder,
                            height: 60.0,
                            width: 60.0,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        errorText(attributeModel),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget readOnlyCheckBoxList(AttributeModel attributeModel) {
    CheckBoxAttributeModel model = attributeModel.checkBoxAttributeModel;

    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),

      ],
    );

    for (int i = 0; i < model.values.length; i++) {
      if (model.values[i].isPreSelected) {
        attributeModel.currentValueList.add(model.values[i]);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        attributeModel.attributeName != null &&
                attributeModel.attributeName.toString().isNotEmpty
            ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
            : Container(),
        SizedBox(
          height: 5.0,
        ),
        new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(model.values.length, (int index) {
              return new Row(
                children: <Widget>[
                  new Checkbox(
                    value: model.values[index].isPreSelected,
                    onChanged: null,
                  ),
                  InkWell(
                      onTap: null,
                      child: Container(
                        width: 250.0,
                        height: 40.0,
                        alignment: Alignment.centerLeft,
                        child: Body1Text(
                            text: model.values[index].name, maxLine: 1),
                      ))
                ],
              );
            })),
        errorText(attributeModel),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget datePicker(AttributeModel attributeModel) {
    DatePickerAttributeModel model = attributeModel.datePickerAttributeModel;
    attributeModel.textEditingController.text = model.value;

    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),

      ],
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          attributeModel.attributeName != null &&
                  attributeModel.attributeName.toString().isNotEmpty
              ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
              : Container(),
          SizedBox(
            height: 10.0,
          ),
          new InkWell(
            onTap: () {
              selectDate(model, attributeModel);
            },
            child: TextFormField(
              enabled: false,
              controller: attributeModel.textEditingController,
              onEditingComplete: () async {
                String request = makeRequestStringForConditionalAttribute();
                Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                await callApiForConditionalAttribute(request);
                Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
                if(this.mounted){
                setState(() {});}
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: model.hint,
                suffixIcon: Icon(Icons.date_range),
              ),
            ),
          ),
          errorText(attributeModel),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget filePicker(AttributeModel attributeModel) {
    FileChooserAttributeModel model = attributeModel.fileChooserAttributeModel;

    Widget notRequiredTitle = SubTitleText(
      text: attributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: attributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),

      ],
    );

    var dateController = TextEditingController();
    dateController.text = model.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        attributeModel.attributeName != null &&
                attributeModel.attributeName.toString().isNotEmpty
            ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
            : Container(),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            model.path != null && model.path.isNotEmpty
                ? Flexible(child: Body1Text(text: model.path))
                : Container(),
            model.path != null && model.path.isNotEmpty
                ? SizedBox(
                    width: 8.0,
                  )
                : Container(),
            RaisedBtn(
              onPressed: () async {
                await chooseFile(model);
              },
              text: Constants.getValueFromKey("Admin.Download.UploadFile", resourceData),
              elevation: 0.0,
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Future chooseFile(FileChooserAttributeModel model) async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath != null && filePath.isNotEmpty) {
        File file = new File(filePath);
        List<int> imageBytes = file.readAsBytesSync();
        String base64EncodedString = base64Encode(imageBytes);
        setState(() {
          model.path = filePath;
          model.value = base64EncodedString;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget productSpecification() {
    if (productDetailModel.specificationList.length == 0) {
      return Container();
    }
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
          padding:
              EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SubTitleText(text: Constants.getValueFromKey("Products.Specs", resourceData)),
              SizedBox(
                height: 5.0,
              ),
              Column(
                  children: List<Widget>.generate(
                      productDetailModel.specificationList.length, (int index) {
                if (productDetailModel.specificationList[index].name != null &&
                    productDetailModel.specificationList[index].value != null) {
                  return new Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Body1Text(
                                text: productDetailModel
                                    .specificationList[index].name),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Body1Text(
                                text: productDetailModel
                                    .specificationList[index].value),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }))
            ],
          )),
    );
  }

  Widget productTags() {
    if (productDetailModel.productTagList.length == 0) {
      return Container();
    }
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SubTitleText(text: Constants.getValueFromKey("nop.ProductDetailScreen.productTag", resourceData)),
            SizedBox(
              height: 5.0,
            ),
            new Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                productDetailModel.productTagList.length,
                (int index) {
                  return InkWell(
                    onTap: () {
                      navigatePush(ProductListScreen(
                          categoryName: productDetailModel
                              .productTagList[index].tagName
                              .toString(),
                          manufactureId: productDetailModel.tagIds[index],
                          isFromTag: true));
                    },
                    child: Chip(
                      label: Body1Text(
                        text:
                            "#${productDetailModel.productTagList[index].tagName}",
                        color: AppColor.appColor,
                      ),
                      backgroundColor: AppColor.grey,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget customerAlsoBoughtThoseProducts() {
    if (customerAlsoBoughtListProductsList != null &&
        customerAlsoBoughtListProductsList.length != 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(
                left: 15.0,
                bottom: 15.0),
            child: TitleText(text: Constants.getValueFromKey("nop.ProductDetailScreen.boughtProduct", resourceData)),
          ),
          new Container(
            height: 255.0,
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: customerAlsoBoughtListProductsList.length,
                padding: EdgeInsets.only(
                  left: 15.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  ProductListModel model =
                      customerAlsoBoughtListProductsList[index];
                  return ProductItem(
                    model: model,
                    onTapFav: () {
                      onTapFavorite(index, model);
                    },
                    onTapProductItem: () {
                      navigatePush(ProductDetailScreen(productId: model.id));
                    },
                  );
                }),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget relatedProducts() {
    if (relatedProductsList != null && relatedProductsList.length != 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(
                left: 15.0,
                bottom: 15.0),
            child: TitleText(text: Constants.getValueFromKey("Admin.Configuration.Settings.ProductEditor.RelatedProducts", resourceData)),
          ),
          new Container(
            height: 255.0,
            child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedProductsList.length,
                padding: EdgeInsets.only(left: 15.0),
                itemBuilder: (BuildContext context, int index) {
                  ProductListModel model = relatedProductsList[index];
                  return ProductItem(
                    model: model,
                    onTapFav: () {
                      onTapFavorite(index, model);
                    },
                    onTapProductItem: () {
                      navigatePush(ProductDetailScreen(productId: model.id));
                    },
                  );
                }),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget ratingBarInRelatedProduct(ProductListModel model) {
    return new RatingBar(
      size: 15.0,
      rating: double.parse(model.rating.toString()),
      color: AppColor.appColor,
    );
  }

  Widget price() {
    if (productDetailModel.productType ==
        Constants.typeOfGroupProductDetailPage) {
      return Container();
    }
    if (productDetailModel.price != null && productDetailModel.price != 0) {
      return priceText();
    } else {
      return new Container();
    }
  }

  Widget groupProductItem() {
    if (productDetailModel.productType !=
        Constants.typeOfGroupProductDetailPage) {
      return Container();
    } else if (productDetailModel.associatedProducts.length == 0) {
      return Container();
    }
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(
              productDetailModel.associatedProducts.length, (int index) {
            ProductDetailModel model =
                productDetailModel.associatedProducts[index];
            return GestureDetector(
              onTap: () {
                onClickProductListItem(model);
              },
              child: Container(
                height: 143,
                margin: EdgeInsets.only(top: index != 0 ? 10.0 : 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(right: 10.0),
                      width: 150.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(0.0),
                          image: DecorationImage(
                            image: model.imageList != null &&
                                    model.imageList.length != 0
                                ? CachedNetworkImageProvider(
                                    model.imageList[0].url)
                                : AssetImage(ImageStrings.imgPlaceHolder),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Expanded(
                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          model.productTitle != null &&
                                  model.productTitle.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 5.0),
                                  child: TitleText(
                                    text: model.productTitle,
                                    maxLine: 3,
                                  ),
                                )
                              : Container(),
                          model.sku != null && model.sku.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 5.0),
                                  child: Body1Text(
                                    text: Constants.getValueFromKey("nop.ProductDetailScreen.skuCustomer", resourceData),
                                    maxLine: 1,
                                  ),
                                )
                              : Container(),
                          availAbilityForGroupProductItem(model),
                          priceForGroupProductItem(model),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget giftCardFields(ProductDetailModel model) {
    if (model.isGiftCard != null && !model.isGiftCard) {
      return Container();
    }

    recipientNameFormField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            SubTitleText(
              text: Constants.getValueFromKey("Admin.GiftCards.Fields.RecipientName", resourceData),
            ),
            SizedBox(
              width: 5.0,
            ),
            SubTitleText(
              text: "*",
              color: Colors.red,
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: Constants.getValueFromKey("Admin.GiftCards.Fields.RecipientName", resourceData),
          ),
          controller: recipientNameController,
          validator: (value) {
            if (value.isEmpty) {
              return Constants.getValueFromKey(
                  "Admin.GiftCards.Fields.RecipientName.Required", resourceData);
            }
          },
          autofocus: true,
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );

    recipientEmailFormField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            SubTitleText(
              text: Constants.getValueFromKey("Products.GiftCard.RecipientEmail", resourceData),
            ),
            SizedBox(
              width: 5.0,
            ),
            SubTitleText(
              text: "*",
              color: Colors.red,
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: Constants.getValueFromKey("Products.GiftCard.RecipientEmail", resourceData),
          ),
          controller: recipientEmailController,
          validator: (value) {
            return Validator.validateFormField(
                value,
                Constants.getValueFromKey(
                    "Account.Login.Fields.Email.Required", resourceData),
                Constants.getValueFromKey(
                    "Admin.Common.WrongEmail", resourceData),
                Constants.EMAIL_VALIDATION);
          },
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );

    yourNameFormField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            SubTitleText(
              text: Constants.getValueFromKey("Products.GiftCard.SenderName", resourceData),
            ),
            SizedBox(
              width: 5.0,
            ),
            SubTitleText(
              text: "*",
              color: Colors.red,
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: Constants.getValueFromKey("Products.GiftCard.SenderName", resourceData),
          ),
          controller: yourNameController,
            validator: (value) {
              if (value.isEmpty) {
                return Constants.getValueFromKey(
                    "Products.GiftCard.SenderName.Required", resourceData);
              }
            }
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );

    yourEmailFormField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            SubTitleText(
              text: Constants.getValueFromKey("Products.GiftCard.SenderEmail", resourceData),
            ),
            SizedBox(
              width: 5.0,
            ),
            SubTitleText(
              text: "*",
              color: Colors.red,
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: Constants.getValueFromKey("Products.GiftCard.SenderEmail", resourceData),
          ),
          controller: yourEmailController,
          validator: (value) {
            return Validator.validateFormField(
                value,
                Constants.getValueFromKey(
                    "Account.Login.Fields.Email.Required", resourceData),
                Constants.getValueFromKey(
                    "Admin.Common.WrongEmail", resourceData),
                Constants.EMAIL_VALIDATION);
          },

        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );

    messageFormField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey("Products.GiftCard.Message", resourceData),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: Constants.getValueFromKey("Products.GiftCard.Message", resourceData),
          ),
          controller: yourMessageController,
          validator: (value) {
            if (value.isEmpty) {
              return Constants.getValueFromKey(
                  "Products.GiftCard.Message.Required", resourceData);
            }
          },
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );

    Widget virtualGiftForm = Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Form(
        //key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            recipientNameFormField,
            SizedBox(
              height: 10.0,
            ),
            recipientEmailFormField,
            SizedBox(
              height: 10.0,
            ),
            yourNameFormField,
            SizedBox(
              height: 10.0,
            ),
            yourEmailFormField,
            SizedBox(
              height: 10.0,
            ),
            messageFormField,
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );

    Widget physicalGiftForm = Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            recipientNameFormField,
            SizedBox(
              height: 10.0,
            ),
            yourNameFormField,
            SizedBox(
              height: 10.0,
            ),
            messageFormField,
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );

    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: model.giftCardType == "Virtual"
            ? virtualGiftForm
            : physicalGiftForm,
      ),
    );
  }

  Widget availAbilityForGroupProductItem(ProductDetailModel model) {
    Color textColor;
    String availabilityText = "";

    if (model.isDisplayStockAvailability) {
      if (model.isDisplayAvailabilityStockQuantityCount) {
        if (model.stockQuantity < 1) {
          availabilityText = Constants.getValueFromKey("ShoppingCart.OutOfStock", resourceData);
          textColor = Colors.red;
        } else {
          availabilityText =
              "${productDetailModel.stockQuantity} "+ Constants.getValueFromKey("nop.ProductDetailScreen.productsStock", resourceData);
        }
      } else if (model.stockQuantity > 0) {
        availabilityText = Constants.getValueFromKey("nop.ProductDetailScreen.productsStock", resourceData);
      }
    } else {
      return Container();
    }

    if (availabilityText.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Body1Text(
          text: availabilityText,
          color: textColor,
          maxLine: 1,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget priceForGroupProductItem(ProductDetailModel model) {
    Widget price = Container();
    Widget oldPrice = Container();
    if (model.price != null && model.price.toString().isNotEmpty) {
      price = HeadlineText(
        text: "${model.price}",
        color: AppColor.appColor,
      );
    }
    if (model.oldPrice != null) {
      Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: oldPrice = oldPriceText(model.oldPrice.toString()),
      );
    }
    return Row(
      children: <Widget>[
        price,
        oldPrice,
      ],
    );
  }

  Widget customerEnterPrice() {
    if (productDetailModel.isCustomerEnterPrice == null ||
        !productDetailModel.isCustomerEnterPrice) {
      return Container();
    }

    Widget subText;

    if (productDetailModel.minimumCustomerEnterPrice != null &&
        productDetailModel.minimumCustomerEnterPrice.toString().isNotEmpty) {
      subText = Body1Text(
          text:
              "${Constants.getValueFromKey("nop.ProductDetailScreen.pricefrom", resourceData)}  ${productDetailModel.minimumCustomerEnterPrice}");
    }
    if (productDetailModel.maximumCustomerEnterPrice != null &&
        productDetailModel.maximumCustomerEnterPrice.toString().isNotEmpty) {
      if (subText != null) {
        subText = Body1Text(
            text:
                "${Constants.getValueFromKey("nop.ProductDetailScreen.pricefrom", resourceData)}  ${productDetailModel.minimumCustomerEnterPrice} ${Constants.getValueFromKey("PrivateMessages.Sent.ToColumn", resourceData)}  ${productDetailModel.maximumCustomerEnterPrice}");
      } else {
        subText = Body1Text(
            text:
                "${Constants.getValueFromKey("nop.ProductDetailScreen.pricefrom", resourceData)}  0 ${Constants.getValueFromKey("PrivateMessages.Sent.ToColumn", resourceData)}  ${productDetailModel.maximumCustomerEnterPrice}");
      }
    }
    if (subText == null) {
      subText = Container();
    }

    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SubTitleText(text: Constants.getValueFromKey("Products.Compare.Price", resourceData)),
            SizedBox(
              height: 5.0,
            ),
            Theme(
              data: ThemeData(primaryColor: AppColor.appColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: customerEnterPriceController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: Constants.getValueFromKey("Products.EnterProductPrice", resourceData),
                    ),
                    onFieldSubmitted: (value) {
                      productDetailModel.customerEnteredPriceValue = value;
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  subText,
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget rentalPrice() {
    if (productDetailModel.isRental == null || !productDetailModel.isRental) {
      return Container();
    }

    if (productDetailModel.rentStartDateByUser != null &&
        productDetailModel.rentStartDateByUser.isNotEmpty) {
      dateControllerForStartRentalDate.text =
          productDetailModel.rentStartDateByUser;
    }
    if (productDetailModel.rentEndDateByUser != null &&
        productDetailModel.rentEndDateByUser.isNotEmpty) {
      dateControllerForEndRentalDate.text =
          productDetailModel.rentEndDateByUser;
    }

    Widget subText = Body1Text(text: "${Constants.getValueFromKey("Products.Price.RentalPrice", resourceData)}: \$30.00 ${Constants.getValueFromKey("nop.ProductDetailScreen.perDay", resourceData)}");
    if (productDetailModel.price != null &&
        productDetailModel.price.toString().isNotEmpty) {
      subText = Body1Text(text: "${Constants.getValueFromKey("Products.Price.RentalPrice", resourceData)}:  ${productDetailModel.price}");
    }
    if (productDetailModel.rentalPriceLength != null) {
      subText = Body1Text(
          text:
              "${Constants.getValueFromKey("Products.Price.RentalPrice", resourceData)}:  ${productDetailModel.price} ${Constants.getValueFromKey("nop.ProductDetailscreen.per", resourceData)} ${productDetailModel.rentalPriceLength}");
    }

    if (productDetailModel.rentalType != null) {
      subText = Body1Text(
          text:
              "${Constants.getValueFromKey("Products.Price.RentalPrice", resourceData)}:  ${productDetailModel.price} ${Constants.getValueFromKey("nop.ProductDetailscreen.per", resourceData)} ${productDetailModel.rentalPriceLength} ${productDetailModel.rentalType}");
    }

    if (subText == null) {
      subText = Container();
    }

    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SubTitleText(text: Constants.getValueFromKey("ShoppingCart.Rent", resourceData)),
            SizedBox(
              height: 5.0,
            ),
            Theme(
              data: ThemeData(primaryColor: AppColor.appColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new InkWell(
                          onTap: () {
                            selectDateForRental(true);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: dateControllerForStartRentalDate,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: Constants.getValueFromKey("Products.RentalStartDate", resourceData),
                              suffixIcon: Icon(Icons.date_range),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: new InkWell(
                          onTap:
                          dateControllerForStartRentalDate.text.isNotEmpty
                              ? () {
                            selectDateForRental(false);
                          }
                              : null,
                          child: TextFormField(
                            enabled: false,
                            controller: dateControllerForEndRentalDate,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: Constants.getValueFromKey("Products.RentalEndDate", resourceData),
                              suffixIcon: Icon(Icons.date_range),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  subText,
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget errorText(AttributeModel attributeModel) {
    Widget errorText = Container();
    if (attributeModel.error != null && attributeModel.error.isNotEmpty) {
      errorText = Container(
          padding: EdgeInsets.only(top: 5.0),
          child: SmallText(
            text: attributeModel.error,
            color: AppColor.errorColor,
          ));
    }
    return errorText;
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      await getPreferences();
      await getProductDetail();
      String requestString = makeRequestStringForConditionalAttribute();
      await callApiForConditionalAttribute(requestString);
      await getAssociatedProductList();
      await getRelatedProductList();
      await getCustomerAlsoBoughtProductList();
      if (customerEnterPriceController.text.isEmpty) {
        if (productDetailModel.customerEnteredPriceValue != null &&
            productDetailModel.customerEnteredPriceValue.isNotEmpty) {
          customerEnterPriceController.text =
              productDetailModel.customerEnteredPriceValue;
        }
      }

      if (productDetailModel.longDescription != null) {
        productDetailModel.longDescription =
            await goInNative(productDetailModel.longDescription);
      }
      if (productDetailModel.shortDescription != null) {
        productDetailModel.shortDescription =
            await goInNative(productDetailModel.shortDescription);
      }
      isLoading = false;
      if(this.mounted) {
        setState(() {});
      }
    }
  }

  Future selectDate(
      DatePickerAttributeModel model, AttributeModel attributeModel) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(DateTime.now().year),
      lastDate: new DateTime(DateTime.now().year + 2),
    );

    if (picked != null) {
      String pickedDate = DateFormat('MM/dd/yyyy').format(picked);
      setState(() {
        model.value = pickedDate;
        attributeModel.textEditingController.text = pickedDate;
        attributeModel.error = null;
      });
    }
  }

  Future selectDateForRental(bool isForStart) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: !isForStart && endDate != null
          ? endDate
          : startDate != null ? startDate : new DateTime.now(),
      firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: new DateTime(DateTime.now().year + 2),
    );


      String pickedDate = DateFormat('MM/dd/yyyy').format(picked);
        if (isForStart) {
          startDate = picked;
          productDetailModel.rentStartDateByUser = pickedDate;
          setState(() {
          });
        }
        if(!isForStart){
          endDate = picked;
          productDetailModel.rentEndDateByUser = pickedDate;
          setState(() {
          });
          int day = calculateDifferenceInDay(startDate, endDate);
          int month = calculateDifferenceInMonth(startDate, endDate);
          int year = calculateDifferenceInYear(startDate, endDate);
          int week = calculateDifferenceInWeek(startDate, endDate);
          switch (productDetailModel.rentalType) {
            case "Days":
              if (day > 0) {
                priceOfRent = productDetailModel.price;
              }
              break;
          }
          if(this.mounted){
            setState(() {});}
        }
  }

  //region date calculation
  int calculateDifferenceInDay(DateTime start, DateTime end) {
    final dif = end.difference(start).inDays;
    return dif + 1;
  }

  int calculateDifferenceInMonth(DateTime start, DateTime end) {
    final dif = end.difference(start).inDays;
    return (dif / 30).ceil();
  }

  int calculateDifferenceInYear(DateTime start, DateTime end) {
    final dif = end.difference(start).inDays;
    return (dif / 365).ceil();
  }

  int calculateDifferenceInWeek(DateTime start, DateTime end) {
    final dif = end.difference(start).inDays + 1;
    return (dif / 7).ceil();
  }

  //endregion

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

  Future callApiForAddToWishListForProduct(
      ProductListModel favProductListModel) async {
      String giftAttribute = makeRequestStringForGiftcardAttribute();
    Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    String url = "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=$customerId&productId=${favProductListModel.id}&shoppingCartTypeId=2&quantity=${favProductListModel.minQuntity}&attributeControlIds=0&giftcardattribute=$giftAttribute&rentalStartDate=${startDate!=null?startDate.toIso8601String():null}&rentalEndDate=${endDate!=null?endDate.toIso8601String():null}";
    Map result = await AddProductIntoCartParser.callApi2(url);
    if (result["errorCode"] == "0") {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey("nop.SubCategoryScreen.AddedWishList", resourceData),
      );
      setState(() {
        favProductListModel.IsProductInWishList = true;
      });
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey("nop.SubCategoryScreen.NotAddedWishList", resourceData),
      );
    }
  }

  Future callApiForAddToWishList(ProductDetailModel productDetailModel) async {
    Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    String attributeValueString = makeRequestStringForConditionalAttribute();
    String giftAttribute = makeRequestStringForGiftcardAttribute();
    if (attributeValueString.isEmpty) {
      attributeValueString = "0";
    }
    String url = "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=$customerId&productId=${productDetailModel.productId}&shoppingCartTypeId=2&quantity=${productDetailModel.minimumOrderQuantityCount}&attributeControlIds=$attributeValueString&giftcardattribute=$giftAttribute&rentalStartDate=${productDetailModel.rentStartDateByUser}&rentalEndDate=${productDetailModel.rentEndDateByUser}";
    Map result = await AddProductIntoCartParser.callApi2(url);
    if (result["errorCode"] == "0") {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      String msg = result["value"];
      setState(() {
        productDetailModel.IsProductInWishList = true;
      });
    //  navigatePush(WishListScreen());
      Fluttertoast.showToast(
        msg: msg,
      );
    } else {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      String error = result["value"];
   //   Fluttertoast.showToast(msg: error);
    }
  }

   String makeRequestStringForGiftcardAttribute() {
     if(recipientEmailController.text.toString().isNotEmpty && yourEmailController.text.toString().isNotEmpty) {
       String urlBuild= "giftcard_" + productDetailModel.productId.toString() + ".RecipientName,%20" + recipientNameController.text.toString() + "%0A" +
           "giftcard_" + productDetailModel.productId.toString() + ".RecipientEmail,%20" + recipientEmailController.text.toString() + "%0A" +
           "giftcard_" + productDetailModel.productId.toString() + ".SenderName,%20" + yourNameController.text.toString() + "%0A" +
           "giftcard_" + productDetailModel.productId.toString() + ".SenderEmail,%20" + yourEmailController.text.toString() + "%0A" +
           "giftcard_" + productDetailModel.productId.toString() + ".Message,%20" + yourMessageController.text.toString();
       String params=Uri.decodeComponent(urlBuild);
       return params;
     }
     else if(recipientNameController.text.toString().isNotEmpty && yourNameController.text.toString().isNotEmpty && yourMessageController.text.toString().isNotEmpty && recipientEmailController.text.toString().isEmpty){
       String urlBuild="giftcard_" + productDetailModel.productId.toString() + ".RecipientName,%20" + recipientNameController.text.toString() + "%0A" +
           "giftcard_" + productDetailModel.productId.toString() + ".SenderName,%20" + yourNameController.text.toString() + "%0A" +
           "giftcard_" + productDetailModel.productId.toString() + ".Message,%20" + yourMessageController.text.toString();
       String params=Uri.decodeComponent(urlBuild);
       return params;
     }
  }

  Future<File> downloadFile(String url, String filename) async {
    var request = await new HttpClient().getUrl(Uri.parse("http://$url"));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getExternalStorageDirectory()).path;
    await getApplicationDocumentsDirectory();
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future getProductDetail() async {
    Map result = await GetProductDetailParser.callApi(
        "${Config.strBaseURL}products/${widget.productId}?customerId="+customerId.toString());
    if (result["errorCode"] == "0") {
      productDetailModel = result["value"];
      makeRequestStringForConditionalAttribute();
    } else {
      isError = true;
    }
  }

  Future getRelatedProductList() async {
    Map result = await RelatedProductListParser.callApi(
        "${Config.strBaseURL}products/relatedproductslist?productId=${widget.productId}&customerId="
    +customerId.toString());
    if (result["errorCode"] == "0") {
      relatedProductsList = result["value"];
      if(true){
      }
    } else {
      isErrorInRelatedProducts = true;
    }
  }

  Future getCustomerAlsoBoughtProductList() async {
    Map result = await CustomerAlsoBoughtProducts.callApi(
        "${Config.strBaseURL}products/productsalsopurchasedlist?productId=${widget.productId}&customerId="+customerId.toString());
    if (result["errorCode"] == "0") {
      customerAlsoBoughtListProductsList = result["value"];
    } else {

      isErrorInRelatedProducts = true;
    }
  }

  Future getAssociatedProductList() async {
    if (productDetailModel.productType != null) {
      if (productDetailModel.productType ==
          Constants.typeOfGroupProductDetailPage) {
        if (productDetailModel.associatedProductIds != null) {
          for (int i = 0;
              i < productDetailModel.associatedProductIds.length;
              i++) {
            Map result = await GetProductDetailParser.callApi(
                "${Config.strBaseURL}products/${productDetailModel.associatedProductIds[i]}customerId="+customerId.toString());
            if (result["errorCode"] == "0") {
              productDetailModel.associatedProducts.add(result["value"]);
            } else {

              isError = true;
            }
          }
        }
      }
    }
  }

  Future callApiForAddToCart(String attributeStr) async {
    if (attributeStr.length == 0) {
      attributeStr = "0";
    }
    var giftAttribute = makeRequestStringForGiftcardAttribute();
    String url =
        "${Config.strBaseURL}shopping_cart_items/addproducttoshoppingcart?customerId=$customerId&productId=${productDetailModel.productId}&shoppingCartTypeId=1&quantity=${productDetailModel.quantityByUser}&attributeControlIds=$attributeStr&rentalStartDate=${productDetailModel.rentStartDateByUser}&giftcardattribute=$giftAttribute&rentalEndDate=${productDetailModel.rentEndDateByUser}";
    Map result = await AddProductIntoCartParser.callApi2(url);
    if (result["errorCode"] == "0") {
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      navigatePush(AddCartScreen(
        isFromProductDetailScreen: true,
      ));
    } else {
      String error = result["msg"];
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      errorDialog(error);
    }
  }

  Future getShoppingCartItemNumber() async {
    Map result = await AddProductIntoCartParser.callApiForGetCartItemTotal(
        "${Config.strBaseURL}shopping_cart_items/" + customerId.toString());
    if (result["errorCode"] == "0") {
      Constants.cartItemCount = result["value"];
    } else {

      isError = true;
    }
  }

  Future callApiForConditionalAttribute(String attributeRequestString) async {
    final result = await CheckConditionalAttributeParser.callApi(Config
            .strBaseURL +
        "shopping_cart_items/productdetailsattributechange?customerId=${customerId.toString()}&productId=${productDetailModel.productId.toString()}&validateAttributeConditions=true&loadPicture=true&attributeControlIds=$attributeRequestString");
    if (result["errorCode"] == 0) {
      hideAttributeIds = new List<String>();
      hideAttributeIds.addAll(result["value"]);
    } else {
   //   Fluttertoast.showToast(msg: result["value"]);
    }
  }

  Future getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future goInNative(String htmlText) async {
    var map = {"t": htmlText};
    final result = await platform.invokeMethod('HtmlToString', map);
    print(result);

    if (result != null) {
      return result.toString();
    }
  }

  String makeRequestStringForConditionalAttribute() {
    String buildUrl = "";
    if (productDetailModel.attributes.length > 0) {
      //for single value attributes
      for (int i = 0; i < productDetailModel.attributes.length; i++) {
        if (productDetailModel.attributes[i].attributeControlTypeId == 1 ||
            productDetailModel.attributes[i].attributeControlTypeId == 2 ||
            productDetailModel.attributes[i].attributeControlTypeId == 40 ||
            productDetailModel.attributes[i].attributeControlTypeId == 45) {
          String currentValue = "0";
          if (!hideAttributeIds
              .contains(productDetailModel.attributes[i].mapId.toString())) {
            if (productDetailModel.attributes[i].currentValue != null) {
              currentValue =
                  productDetailModel.attributes[i].currentValue.id.toString();
            }
          }
          buildUrl += "product_attribute_" +
              productDetailModel.productId.toString() +
              "_" +
              productDetailModel.attributes[i].attributeId.toString() +
              "_" +
              productDetailModel.attributes[i].mapId.toString() +
              "_" +
              currentValue +
              ",";
        }
        //for multiple value attributes
        if (productDetailModel.attributes[i].attributeControlTypeId == 3 ||
            productDetailModel.attributes[i].attributeControlTypeId == 50) {
          String values = "0";
          if (!hideAttributeIds.contains(productDetailModel.attributes[i].mapId.toString())) {
            for (int j = 0;
                j < productDetailModel.attributes[i].currentValueList.length;
                j++) {
              if (j ==
                  productDetailModel.attributes[i].currentValueList.length -
                      1) {
                values += productDetailModel
                    .attributes[i].currentValueList[j].id
                    .toString();
              } else {
                values += productDetailModel
                        .attributes[i].currentValueList[j].id
                        .toString() +
                    ":";
              }
            }
          }
          buildUrl += "product_attribute_" +
              productDetailModel.productId.toString() +
              "_" +
              productDetailModel.attributes[i].attributeId.toString() +
              "_" +
              productDetailModel.attributes[i].mapId.toString() +
              "_" +
              values +
              ",";
        }
        //for string value attribute
        if (productDetailModel.attributes[i].attributeControlTypeId == 4 ||
            productDetailModel.attributes[i].attributeControlTypeId == 10 ||
            productDetailModel.attributes[i].attributeControlTypeId == 20) {
          String currentValue = "";
          if (!hideAttributeIds
              .contains(productDetailModel.attributes[i].mapId.toString())) {
            if (productDetailModel.attributes[i].textEditingController !=
                null) {
              currentValue = productDetailModel
                  .attributes[i].textEditingController.text
                  .toString();
            }
          }
          buildUrl += "product_attribute_" +
              productDetailModel.productId.toString() +
              "_" +
              productDetailModel.attributes[i].attributeId.toString() +
              "_" +
              productDetailModel.attributes[i].mapId.toString() +
              "_" +
              currentValue +
              ",";
        }
      }
    }
    print(buildUrl);
    return buildUrl;
   }

  void onClickSearchOption() {
    navigatePush(AutoCompleteSearchScreen());
  }

  void onClickCartOption() {
    navigatePush(AddCartScreen(isFromProductDetailScreen: true));
  }

  void onClickImageListItem(int index) {}

  void onClickAddToCart() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      bool error = conditionForAttribute();
      if (error) {
        setState(() {});
      } else {
        String attributeString = makeRequestStringForConditionalAttribute();
        await getShoppingCartItemNumber();
        if(productDetailModel.isGiftCard){
       /* if (formKey.currentState.validate()) {*/
          Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
          await callApiForAddToCart(attributeString);
         // }
        }
        else{
          Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
        await callApiForAddToCart(attributeString);
      }}
      setState(() {});

    } else {
      Fluttertoast.showToast(msg: Constants.getValueFromKey("nop.LoginScreen.NoInternet", resourceData));
    }
  }

  void onClickAddToCompare() {}

  void onClickAddToWishList() async {
    bool error = conditionForAttribute();
    if (error) {
      if(this.mounted){
        setState(() {});}
    } else {
        if(productDetailModel.isGiftCard) {
          if(!productDetailModel.IsProductInWishList){
     /*       if (formKey.currentState.validate()) {*/
            callApiForAddToWishList(productDetailModel);

          }
          else{
            Fluttertoast.showToast(msg: "Already in wishlist");
          }
        }
      else{
          callApiForAddToWishList(productDetailModel);
      }
    }
    if(this.mounted){
      setState(() {});}
  }

  void onTapFavorite(int index, ProductListModel favProductListModel) {

      if(!favProductListModel.IsProductInWishList){
        if (favProductListModel.attributes.length == 0 &&
            (favProductListModel.isGiftCard != null &&
                !favProductListModel.isGiftCard)) {
      callApiForAddToWishListForProduct(favProductListModel);}
        else{
          navigatePush(ProductDetailScreen(productId: favProductListModel.id));
        }
    }else{
        Fluttertoast.showToast(msg: "Already in wishlist");
      }
  }

  void onClickProductListItem(ProductDetailModel model) {
    navigatePush(ProductDetailScreen(productId: model.productId));
  }

  void onClickLargeImage() {}

  void onClickViewAllImage() {}

  void errorDialog(String reason) {
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
                              Constants.getValueFromKey("nop.ProductDetailScreen.FailAddCart", resourceData),
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
                              Constants.getValueFromKey("nop.ProductDetailScreen.somthingWrong", resourceData),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                            new Text(
                              "${Constants.getValueFromKey("nop.ProductDetailScreen.Reason", resourceData)} $reason",
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.center,
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(top: 17.0)),
                            new FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: new Text(Constants.getValueFromKey("Common.OK", resourceData)),
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

  bool conditionForAttribute() {
    List<bool> errorList = new List<bool>();
    for (int i = 0; i < productDetailModel.attributes.length; i++) {
      if (!hideAttributeIds
          .contains(productDetailModel.attributes[i].mapId.toString())) {
        if (productDetailModel.attributes[i].isRequired != null &&
            productDetailModel.attributes[i].isRequired) {
          AttributeModel attributeModel = productDetailModel.attributes[i];
          switch (attributeModel.attributeControlTypeId) {
            case 1:
              bool isError = conditionForValueModel(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 2:
              bool isError = conditionForValueModel(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 3:
              bool isError = conditionForValueModelList(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 4:
              bool isError = conditionForValueString(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 10:
              bool isError = conditionForValueString(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 40:
              bool isError = conditionForValueModel(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 45:
              bool isError = conditionForValueModel(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 20:
              bool isError = conditionForValueString(attributeModel);
              if (isError) {
                errorList.add(isError);
              }
              break;
            case 30:
              //todo remaing
              break;
          }
        }
      }
    }
    if (errorList.length > 0) {
      return true;
    }
    return false;
  }

  bool conditionForValueModel(AttributeModel attributeModel) {
    if (attributeModel.currentValue == null) {
      if (attributeModel.labelText != null) {
        attributeModel.error = attributeModel.labelText;
      } else {
        attributeModel.error = Constants.getValueFromKey("Admin.Common.Select", resourceData) + attributeModel.attributeName;
      }

      return true;
    }
    return false;
  }

  bool conditionForValueModelList(AttributeModel attributeModel) {
    if (attributeModel.currentValueList == null ||
        attributeModel.currentValueList.length == 0) {
      if (attributeModel.labelText != null) {
        attributeModel.error = attributeModel.labelText;
      } else {
        attributeModel.error = Constants.getValueFromKey("Admin.Common.Select", resourceData) + attributeModel.attributeName;
      }
      return true;
    }
    return false;
  }

  bool conditionForValueString(AttributeModel attributeModel) {
    if (attributeModel.textEditingController.text.isEmpty) {
      if (attributeModel.labelText != null) {
        attributeModel.error = attributeModel.labelText;
      } else {
        attributeModel.error = Constants.getValueFromKey("Admin.Common.Select", resourceData) + attributeModel.attributeName;
      }
      return true;
    }
    return false;
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
