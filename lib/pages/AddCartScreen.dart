import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/AddressModel/CountryDropDownModel.dart';
import 'package:i_am_a_student/models/AddressModel/CountryModel.dart';
import 'package:i_am_a_student/models/AddressModel/StateDropDownModel.dart';
import 'package:i_am_a_student/models/AddressModel/StateModel.dart';
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/models/CouponCodeModel.dart';
import 'package:i_am_a_student/models/ShippingCartAttributeModel.dart';
import 'package:i_am_a_student/models/ShoppingModel/CheckoutAttributesModel.dart';
import 'package:i_am_a_student/models/ShoppingModel/EstimateShippingMethod.dart';
import 'package:i_am_a_student/models/ShoppingModel/GiftCodeCard.dart';
import 'package:i_am_a_student/models/ShoppingModel/ShoppingCartAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/CheckBoxAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/ColorSquareAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/DatePickerAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/DropDownAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/FileChooserAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/ImageSquareAttribute.dart';
import 'package:i_am_a_student/models/attributes/RadioButtonAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/TextFormFieldAttributeModel.dart';
import 'package:i_am_a_student/models/productDetail/AttributeModel.dart';
import 'package:i_am_a_student/pages/AddressScreenForCheckOut.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductDetailScreen.dart';
import 'package:i_am_a_student/pages/SearchScreens/AutoCompleteSearchScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/CartProductListParser.dart';
import 'package:i_am_a_student/parser/CartProductPriceParser.dart';
import 'package:i_am_a_student/parser/CustomerAddressListParser.dart';
import 'package:i_am_a_student/parser/GetCheckOutAttributeParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/LanguageStrings.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';

import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCartScreen extends StatefulWidget {
  final bool isFromProductDetailScreen;

  AddCartScreen({this.isFromProductDetailScreen});

  @override
  _AddCartScreenState createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {
  List<CartProductListModel> cartItemList = new List<CartProductListModel>();

  List<CouponCodeModel> mCouponCodeModelList = new List<CouponCodeModel>();

  TextEditingController discountCodeController = new TextEditingController();

  TextEditingController giftCardController = new TextEditingController();

  TextEditingController zipCodeController = new TextEditingController();

  List<GiftCodeCard> mGiftCodeCardList = new List<GiftCodeCard>();

  bool isError = false;

  bool isErrorInCheckoutAttribute = false;

  bool isInternet;

  bool isLoading;

  bool ifPressApply = false;

  var subscription;

  bool giftValue = false;

  CartProductListModel mCartProductListModel;

  ShoppingCartAttributeModel mShoppingCartAttributeModel;

  ShippingCartAttributeModel mShippingCartAttributeModel;

  bool isExpandedEstimation = false;

  SharedPreferences prefs;

  int customerId;

  List<CountryModel> countryModelList = new List<CountryModel>();

  List<StateModel> stateModelList = new List<StateModel>();

  List<CouponCodeModel> addCouponList = new List<CouponCodeModel>();

  List<EstimateShippingMethod> estimateShippingList =
      new List<EstimateShippingMethod>();

  CountryDropDownModel countryDropDownModel;

  StateDropDownModel stateDropDownModel;

  CountryModel countryModel;

  StateModel mStateModel;

  Function hp;

  Function wp;

  CheckoutAttributesModel checkoutAttributesModel =
      new CheckoutAttributesModel();

  List<String> hideAttributeIds = new List<String>();

  Map resourceData;

  int giftwrapstatus;

  var isApplied = false;

  @override
  void initState() {
    internetConnection();
    callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isLoading != null && !isLoading) {
          return layoutMain();
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
      } else {
        return ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () {},
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
  }

  Widget layoutMain() {
    hp = Screen(MediaQuery.of(context).size).hp;
    wp = Screen(MediaQuery.of(context).size).wp;
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? prefix0.TextDirection.rtl
          : prefix0.TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(Constants.getValueFromKey(
              "Checkout.Progress.Cart", resourceData)),
          leading: null,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: InkWell(
                  onTap: () {
                    navigatePush(AutoCompleteSearchScreen());
                  },
                  child: Icon(Icons.search)),
            )
          ],
        ),
        body: cartItemList != null && cartItemList.length != 0
            ? gridListItem()
            : new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    "images/emptycart.png",
                    width: 200,
                    height: 200,
                    color: AppColor.appColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TitleText(
                    text: Constants.getValueFromKey(
                        "nop.AddCartScreen.noIteamLabel", resourceData),
                    align: TextAlign.center,
                    maxLine: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Constants.getValueFromKey(
                        "nop.AddCartScreen.notFoundlabel.cart".toLowerCase(),
                        resourceData),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline.copyWith(
                        fontWeight: FontWeight.bold, color: AppColor.appColor),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 70.0, right: 70),
                    child: RaisedBtn(
                        onPressed: () {
                          navigatePushReplacement(HomeScreen());
                        },
                        text: Constants.getValueFromKey(
                            "ShoppingCart.ContinueShopping", resourceData)),
                  )
                ],
              ),
        bottomNavigationBar: cartItemList != null && cartItemList.length != 0
            ? new Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 0.5, color: Colors.grey.withAlpha(100)))),
                height: 65,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Body1Text(
                            text: Constants.getValueFromKey(
                                "ShoppingCart.ItemTotal", resourceData),
                            align: TextAlign.start,
                          ),
                          HeadlineText(
                            text: mCartProductListModel.itemTotal != null
                                ? mCartProductListModel.itemTotal.toString()
                                : "\$0",
                            color: AppColor.appColor,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: RaisedBtn(
                        onPressed: mCartProductListModel != null &&
                                mCartProductListModel != null
                            ? () {
                                onClickSubmitBtn();
                              }
                            : null,
                        text: Constants.getValueFromKey(
                                "PageTitle.Checkout", resourceData)
                            .toUpperCase(),
                        elevation: 0.0,
                      ),
                    )
                  ],
                ),
              )
            : null,
      ),
    );
  }

  Widget gridListItem() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: new Container(
            height: hp(41),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: cartItemList.length,
                itemBuilder: (BuildContext context, index) {
                  return Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: new InkWell(
                          onTap: () {
                            navigatePush(ProductDetailScreen(
                                productId: cartItemList[index].cartItemId));
                          },
                          child: new Container(
                            width: wp(58.56),
                            margin: EdgeInsets.only(right: 10),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  new Expanded(
                                    flex: 7,
                                    child: (cartItemList[index]
                                                .addCartProductList
                                                .length !=
                                            0)
                                        ? new Container(
                                            height: 160,
                                            padding: EdgeInsets.all(2.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4),
                                                  topRight: Radius.circular(4)),
                                              child: CachedNetworkImage(
                                                imageUrl: cartItemList[index]
                                                    .addCartProductList[0]
                                                    .src
                                                    .toString(),
                                                placeholder: (context, url) =>
                                                    FlutterLogo(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 160,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4),
                                                  topRight: Radius.circular(4)),
                                              child: Image.asset(ImageStrings.noimage,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                  ),
                                  new Expanded(
                                    flex: 5,
                                    child: new Container(
                                      margin: EdgeInsets.only(
                                        top: 8,
                                        left: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Body1Text(
                                            text: cartItemList[index]
                                                .cartItemName
                                                .toString(),
                                            maxLine: 2,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new RatingBar(
                                                      size: 15,
                                                      rating: double.parse(
                                                          cartItemList[index]
                                                              .cartItemRating
                                                              .toString()),
                                                      color: AppColor.appColor,
                                                    ),
                                                    SizedBox(height: 3),
                                                    oldPriceText(index),
                                                    SizedBox(height: 3.0),
                                                    new Body1Text(
                                                        text:
                                                            cartItemList[index]
                                                                .cartItemPrice
                                                                .toString()),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    cartItemList[index].order_minimum_quantity !=
                                                    cartItemList[index].quantityByUser
                                                        ? new IconButton(
                                                            icon: new Icon(Icons.indeterminate_check_box),
                                                            onPressed:
                                                                () async {
                                                              Constants.progressDialog(
                                                                  true,
                                                                  context,
                                                                  Constants.getValueFromKey(
                                                                      "nop.ProgressDilog.title",
                                                                      resourceData));
                                                              await decreaseQuantity(
                                                                  cartItemList[
                                                                      index]);
                                                              minus(
                                                                  cartItemList[
                                                                      index]);
                                                            })
                                                        : new IconButton(
                                                            onPressed: null,
                                                            icon: new Icon(Icons
                                                                .indeterminate_check_box)),
                                                    Center(
                                                      child: new Body2Text(
                                                          color:
                                                              AppColor.appColor,
                                                          align:
                                                              TextAlign.center,
                                                          text: cartItemList[
                                                                  index]
                                                              .quantityByUser
                                                              .toString()),
                                                    ),
                                                    new IconButton(
                                                      icon: new Icon(
                                                          Icons.add_box),
                                                      onPressed: () async {
                                                        Constants.progressDialog(
                                                            true,
                                                            context,
                                                            Constants.getValueFromKey(
                                                                "nop.ProgressDilog.title",
                                                                resourceData));
                                                        await increaseQuantity(
                                                            cartItemList[
                                                                index]
                                                        );
                                                        /*add(cartItemList[
                                                            index]);*/
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: wp(51),
//                        bottom: hp(33),
//                        top: ,
                        child: new IconButton(
                          icon: Icon(Icons.cancel),
                          color: AppColor.appColor,
                          iconSize: 28,
                          onPressed: () {
                            _showDialog(index);
                          },
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
        attributeCard(),
        discountAndGift(),
        mShippingCartAttributeModel != null ? estimateShipping() : Container(),
        new Padding(
          padding: EdgeInsets.only(right: 8, left: 8),
          child: new Card(
              child: Column(
            children: <Widget>[
              mCartProductListModel.itemSubTotal != null
                  ? new Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Body1Text(
                                  text: Constants.getValueFromKey(
                                      "ShoppingCart.Totals.SubTotal",
                                      resourceData))),
                          Body2Text(
                              text: mCartProductListModel.itemSubTotal
                                  .toString()),
                        ],
                      ),
                    )
                  : Container(),
              mCartProductListModel.itemSubTotalDiscount != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Body1Text(
                                  text: Constants.getValueFromKey(
                                      "Admin.Orders.Fields.Edit.OrderSubTotalDiscount",
                                      resourceData))),
                          Body2Text(
                              text: mCartProductListModel.itemSubTotalDiscount
                                  .toString()),
                        ],
                      ),
                    )
                  : Container(),
              mCartProductListModel.itemShipping != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Body1Text(
                                  text: Constants.getValueFromKey(
                                      "Admin.Orders.Report.Shipping",
                                      resourceData))),
                          Body2Text(
                              text: mCartProductListModel.itemShipping
                                  .toString()),
                        ],
                      ),
                    )
                  : Container(),
              mCartProductListModel.itemTax != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Body1Text(
                                  text: Constants.getValueFromKey(
                                      "Admin.Orders.Report.Tax",
                                      resourceData))),
                          Body2Text(
                              text: mCartProductListModel.itemTax.toString()),
                        ],
                      ),
                    )
                  : Container(),
              mCartProductListModel.itemOrderTotalDiscount != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Body1Text(
                                  text: Constants.getValueFromKey(
                                      "Admin.Orders.Fields.OrderTotalDiscount",
                                      resourceData))),
                          Body2Text(
                              text: mCartProductListModel.itemOrderTotalDiscount
                                  .toString()),
                        ],
                      ),
                    )
                  : Container(),
              mGiftCodeCardList != null && mGiftCodeCardList.length != 0
                  ? new ListView(
                      shrinkWrap: true,
                      children: new List<Widget>.generate(
                          mGiftCodeCardList.length, (index) {
                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                      onTap: () async {
                                        Constants.progressDialog(
                                            true,
                                            context,
                                            Constants.getValueFromKey(
                                                "nop.ProgressDilog.title",
                                                resourceData));
                                        await removeGiftCoupon(
                                            mGiftCodeCardList[index]
                                                .mCouponCode
                                                .toString());
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: AppColor.appColor,
                                      )),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: new Body1Text(
                                      align: TextAlign.start,
                                      color: Colors.green,
                                      text: LanguageStrings.giftCardText +
                                          ":" +
                                          mGiftCodeCardList[index]
                                              .mCouponCode
                                              .toString(),
                                    ),
                                  ),
                                  new Body2Text(
                                    align: TextAlign.start,
                                    text: mGiftCodeCardList[index]
                                        .mAmount
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    )
                  : Container(),
              mCartProductListModel.itemTotal != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Body1Text(
                                  text: Constants.getValueFromKey(
                                      "Admin.CurrentCarts.Total",
                                      resourceData))),
                          TitleText(
                              text: mCartProductListModel.itemTotal.toString(),
                              color: AppColor.appColor),
                        ],
                      ),
                    )
                  : Container(),
              mCartProductListModel.itemEarnPoints != null &&
                      mCartProductListModel.itemEarnPoints > 0
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Body1Text(
                                  text: Constants.getValueFromKey(
                                      "ShoppingCart.Totals.RewardPoints.WillEarn",
                                      resourceData))),
                          Body2Text(
                            text: mCartProductListModel.itemEarnPoints
                                    .toString() +
                                " " +
                                Constants.getValueFromKey(
                                    "Admin.Customers.Customers.RewardPoints.Fields.Points",
                                    resourceData),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          )),
        ),
      ],
    );
  }

  Widget oldPriceText(int index) {
    if (cartItemList[index].cartItemOldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${cartItemList[index].cartItemOldPrice}",
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

  Widget discountAndGift() {
    return mShoppingCartAttributeModel.isShowGiftCardBox &&
            mShoppingCartAttributeModel.isShowDiscountBox
        ? new Padding(
            padding: EdgeInsets.only(right: 8, left: 8.0),
            child: new Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new ExpansionTile(
                    initiallyExpanded: false,
                    leading: Icon(
                      Icons.monetization_on,
                      color: AppColor.appColor,
                    ),
                    title: Body2Text(
                        text: Constants.getValueFromKey(
                            "ShoppingCart.DiscountCouponCode", resourceData),
                        color: AppColor.appColor),
                    children: <Widget>[
                      mShoppingCartAttributeModel.isShowDiscountBox
                          ? new Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: new Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Theme(
                                              data: ThemeData(
                                                  primaryColor:
                                                      AppColor.appColor),
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all()),
                                                height: 50.0,
                                                child: Center(
                                                  child: new TextFormField(
                                                    controller:
                                                        discountCodeController,
                                                    decoration:
                                                        new InputDecoration
                                                            .collapsed(
//                                                      border:
//                                                          OutlineInputBorder(),
                                                      hintText: Constants
                                                          .getValueFromKey(
                                                              "ShoppingCart.DiscountCouponCode.Tooltip",
                                                              resourceData),
                                                      hintStyle: new TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  new RaisedButton(
                                      padding: EdgeInsets.all(15.0),
                                      child: Body1Text(
                                        text: Constants.getValueFromKey(
                                                "ShoppingCart.DiscountCouponCode.Button",
                                                resourceData)
                                            .toUpperCase(),
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (discountCodeController.text !=
                                                null &&
                                            discountCodeController.text != "") {
                                          Constants.progressDialog(
                                              true,
                                              context,
                                              Constants.getValueFromKey(
                                                  "nop.ProgressDilog.title",
                                                  resourceData));
                                          ifPressApply = true;
                                          await applyDiscountCoupon(
                                              discountCodeController.text
                                                  .toString());
                                          setState(() {});
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: Constants.getValueFromKey(
                                                  "ShoppingCart.DiscountCouponCode.WrongDiscount",
                                                  resourceData));
                                        }
                                      })
                                ],
                              ),
                            )
                          : Container(),
                      mCouponCodeModelList != null &&
                              mCouponCodeModelList.length > 0
                          ? new ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(8.0),
                              children: new List<Widget>.generate(
                                  mCouponCodeModelList.length, (index) {
                                return new Row(
                                  children: <Widget>[
                                    new TitleText(
                                      align: TextAlign.start,
                                      color: Colors.green,
                                      text: Constants.getValueFromKey(
                                              "nop.AddCartScreen.CouponCodeLabel",
                                              resourceData) +
                                          "-" +
                                          mCouponCodeModelList[index]
                                              .couponCode
                                              .toString(),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: AppColor.appColor,
                                        ),
                                        onPressed: () async {
                                          Constants.progressDialog(
                                              true,
                                              context,
                                              Constants.getValueFromKey(
                                                  "nop.ProgressDilog.title",
                                                  resourceData));
                                          await removeDiscountCoupon(
                                              mCouponCodeModelList[index]
                                                  .couponCode
                                                  .toString());
                                        })
                                  ],
                                );
                              }),
                            )
                          : Container(),
                      mShoppingCartAttributeModel.isShowGiftCardBox
                          ? new Padding(
                              padding: EdgeInsets.all(
                                8.0,
                              ),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: new Theme(
                                      data: new ThemeData(
                                          primaryColor: AppColor.appColor),
                                      child: new Row(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all()),
                                                height: 50.0,
                                                child: Center(
                                                  child: new TextFormField(
                                                    controller:
                                                        giftCardController,
                                                    decoration:
                                                        new InputDecoration
                                                            .collapsed(
//                                                      border: OutlineInputBorder(),
                                                      hintText: Constants
                                                          .getValueFromKey(
                                                              "ShoppingCart.GiftCardCouponCode.Tooltip",
                                                              resourceData),
                                                      hintStyle: new TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  new RaisedButton(
                                      padding: EdgeInsets.all(15.0),
                                      child: Body1Text(
                                        text: Constants.getValueFromKey(
                                                "ShoppingCart.DiscountCouponCode.Button",
                                                resourceData)
                                            .toUpperCase(),
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (giftCardController.text != null &&
                                            giftCardController.text != "") {
                                          Constants.progressDialog(
                                              true,
                                              context,
                                              Constants.getValueFromKey(
                                                  "nop.ProgressDilog.title",
                                                  resourceData));
                                          ifPressApply = true;
                                          await applyGiftCardCoupon(
                                              giftCardController.text
                                                  .toString());
                                          setState(() {});
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: Constants.getValueFromKey(
                                                  "ShoppingCart.DiscountCouponCode.WrongDiscount",
                                                  resourceData));
                                        }
                                      })
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget estimateShipping() {
    return mShippingCartAttributeModel.isEstimateShippingEnabled
        ? new Padding(
            padding: EdgeInsets.only(right: 8.0, left: 8.0),
            child: new Card(
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  new ExpansionTile(
                    initiallyExpanded: false,
                    leading: Icon(
                      Icons.local_shipping,
                      color: AppColor.appColor,
                    ),
                    title: Body2Text(
                        text: Constants.getValueFromKey(
                            "ShoppingCart.EstimateShipping", resourceData),
                        color: AppColor.appColor),
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.all(10.0),
                        primary: false,
                        shrinkWrap: true,
                        children: <Widget>[
                          /*SizedBox(
                      height: 15.0,
                    ),*/
                          countryDropDown(),
                          SizedBox(
                            height: 15.0,
                          ),
                          stateDropDown(),
                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(border: Border.all()),
                            height: 50.0,
                            child: Center(
                              child: new TextFormField(
                                controller: zipCodeController,
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration.collapsed(
//                                  border: OutlineInputBorder(),
                                  hintText: Constants.getValueFromKey(
                                      "ShoppingCart.EstimateShipping.ZipPostalCode",
                                      resourceData),
                                  hintStyle:
                                      new TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          RaisedBtn(
                            onPressed: () async {
                              isExpandedEstimation = true;
                              await estimateShippingClick();
                              setState(() {});
                            },
                            text: Constants.getValueFromKey(
                                    "ShoppingCart.EstimateShipping.Button",
                                    resourceData)
                                .toUpperCase(),
                            elevation: 0.0,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          estimateShippingList != null &&
                                  estimateShippingList.length != 0
                              ? new ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount: estimateShippingList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TitleText(
                                              text: estimateShippingList[index]
                                                      .mName
                                                      .toString() +
                                                  "(" +
                                                  estimateShippingList[index]
                                                      .mPrice
                                                      .toString() +
                                                  ")"),
                                          SizedBox(height: 8.0),
                                          Body1Text(
                                              text: estimateShippingList[index]
                                                  .mDescription
                                                  .toString())
                                        ],
                                      ),
                                    ));
                                  })
                              : Container(),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget countryDropDown() {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 50.0,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
      child: DropdownButtonHideUnderline(
        child: new DropdownButton(
          isExpanded: true,
          hint: Text(Constants.getValueFromKey(
              "Admin.Address.SelectCountry", resourceData)),
          value: countryDropDownModel.currentValue,
          items: countryDropDownModel.dropDownItems,
          onChanged: (value) async {
            Constants.progressDialog(
                true,
                context,
                Constants.getValueFromKey(
                    "nop.ProgressDilog.title", resourceData));
            countryModel = value;
            await callApiForGetStates(countryModel.strValue.toString());
            setState(() {
              countryDropDownModel.currentValue = countryModel;
            });
            Constants.progressDialog(
                false,
                context,
                Constants.getValueFromKey(
                    "nop.ProgressDilog.title", resourceData));
          },
        ),
      ),
    );
  }

  Widget stateDropDown() {
    if (stateDropDownModel == null) {
      return Container();
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          height: 50.0,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2.0)),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              isExpanded: true,
              hint: Text(Constants.getValueFromKey(
                  "Admin.Address.SelectState", resourceData)),
              value: stateDropDownModel.currentValue,
              items: stateDropDownModel.dropDownItems,
              onChanged: (value) {
                mStateModel = value;
                setState(() {
                  stateDropDownModel.currentValue = value;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget discountCode() {
    return new Row(
      children: <Widget>[
        TitleText(
            text: LanguageStrings.couponLabel +
                "-" +
                discountCodeController.text),
        IconButton(
            icon: Icon(
              Icons.cancel,
              color: AppColor.appColor,
            ),
            onPressed: () {})
      ],
    );
  }

  //region custom attributes
  Widget attributeCard() {
    if (checkoutAttributesModel == null) {
      return Container();
    }
    if (checkoutAttributesModel.attributes.length == 0) {
      return Container();
    }
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 4.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(
                checkoutAttributesModel.attributes.length, (int index) {
              if (hideAttributeIds.contains(
                  checkoutAttributesModel.attributes[index].mapId.toString())) {
                return Container();
              }
              switch (checkoutAttributesModel
                  .attributes[index].attributeControlTypeId) {
                case 1:
                  return dropDownList(
                      checkoutAttributesModel.attributes[index]);
                  break;
                case 2:
                  return radioList(checkoutAttributesModel.attributes[index]);
                  break;
                case 3:
                  return checkBoxList(
                      checkoutAttributesModel.attributes[index]);
                  break;
                case 4:
                  return textFormField(
                      checkoutAttributesModel.attributes[index]);
                  break;
                case 10:
                  return multiTextFormField(
                      checkoutAttributesModel.attributes[index]);
                  break;
                case 40:
                  return colorSquare(checkoutAttributesModel.attributes[index]);
                  break;
                case 45:
                  return imageSquare(checkoutAttributesModel.attributes[index]);
                  break;
                case 50:
                  return readOnlyCheckBoxList(
                      checkoutAttributesModel.attributes[index]);
                  break;
                case 20:
                  return datePicker(checkoutAttributesModel.attributes[index]);
                  break;
                case 30:
                  return filePicker(checkoutAttributesModel.attributes[index]);
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
        DropdownButtonHideUnderline(
          child: new DropdownButton(
            hint: Padding(
              padding: EdgeInsets.only(bottom: 0.0),
              child: Text(
                attributeModel.labelText != null &&
                        attributeModel.labelText.isNotEmpty
                    ? attributeModel.labelText
                    : Constants.getValueFromKey(
                        "Admin.Common.Select", resourceData),
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
              giftwrapstatus = model.currentValue.id;
              setState(() {
                callAPIforGiftwrap();
              });
            },
            isDense: true,
          ),
        ),
        errorText(attributeModel),
        SizedBox(height: 8.0),
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
                      setState(() {});
                    },
                  ),
                  InkWell(
                      onTap: () async {
                        model.currentValue = model.values[index];
                        attributeModel.error = null;
                        setState(() {});
                      },
                      child: Container(
                        width: 250,
                        height: 40,
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
                      setState(() {});
                    },
                  ),
                  InkWell(
                      onTap: () async {
                        model.values[index].isPreSelected =
                            !model.values[index].isPreSelected;
                        attributeModel.error = null;
                        setState(() {});
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
                /*String request = makeRequestStringForConditionalAttribute();
                Constants.progressDialog(true, context);
                await callApiForConditionalAttribute(request);
                Constants.progressDialog(false, context);*/
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

              return new GestureDetector(
                onTap: () async {
                  model.selectedColorBox = index;
                  attributeModel.error = null;
                  setState(() {});
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
              return new GestureDetector(
                onTap: () async {
                  model.selectedImageBox = index;
                  attributeModel.error = null;
                  setState(() {});
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
                setState(() {});
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

  Future selectDate(
      DatePickerAttributeModel model, AttributeModel attributeModel) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(DateTime.now().year),
      lastDate: new DateTime(DateTime.now().year + 2),
    );

    if (picked != null) {
      String pickedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        model.value = pickedDate;
        attributeModel.textEditingController.text = pickedDate;
        attributeModel.error = null;
      });
    }
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
              text: Constants.getValueFromKey(
                  "Admin.Download.UploadFile", resourceData),
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

  //endregion

  callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      isLoading = true;
        await getSharedPref();
        await getShoppingCartItemNumber();
        await getCartProductList();
        if (cartItemList != null && cartItemList.length > 0) {
          await getDiscountAttributes();
          await getShippingAttributes();
          await getCustomerAttributeAddress();
          await getCheckoutAttributes();
          await getCartProductListPriceTotal();
          await appliedDiscountCoupon();
          await appliedGiftCard();
      }
      isLoading = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  Future getCartProductListPriceTotal() async {
    Map result = await CartProductPriceParser.callApi(
        "${Config.strBaseURL}shopping_cart_items/getcarttotal?customerId=" +
            customerId.toString());
    if (result["errorCode"] == "0") {
      mCartProductListModel = result["value"];
      if(this.mounted){
      setState(() {
      });}
    } else {
      isError = true;
    }
  }

  Future getCartProductList() async {
    Map result = await CartProductListParser.callApi(
        "${Config.strBaseURL}shopping_cart_items/$customerId");
    if (result["errorCode"] == "0") {
      cartItemList = result["value"];
      await getShoppingCartItemNumber();
    } else {
      isError = true;
    }
  }

  Future deleteItem(deleteId) async {
    Map result = await AddProductIntoCartParser.callApiDelete(
        "${Config.strBaseURL}shopping_cart_items/deleteshoppingcartorwishlistitem?id=" +
            deleteId.toString());
    if (result["errorCode"] == "0") {
      String msg = result["value"];
      Fluttertoast.showToast(
        msg: msg,
      );
      await getShoppingCartItemNumber();
      Constants.progressDialog(
          true,
          context,
          Constants.getValueFromKey(
              "nop.ProgressDilog.title", resourceData));
      await getCartProductListPriceTotal();
      Constants.progressDialog(
          false,
          context,
          Constants.getValueFromKey(
              "nop.ProgressDilog.title", resourceData));
      setState(() {
      });
    } else {
      String msg = result["value"];
      Fluttertoast.showToast(
        msg: msg,
      );
    }
  }

  Future getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future getDiscountAttributes() async {
    Map result = await AddProductIntoCartParser.callApiForGetShoppingAttributes(
        "${Config.strBaseURL}shopping_cart_items/shoppingcartsetting");
    if (result["errorCode"] == "0") {
      if (result['value'] != null) {
        mShoppingCartAttributeModel = result['value'];
      }
    } else {
      isError = true;
    }
  }

  Future getShippingAttributes() async {
    Map result = await AddProductIntoCartParser.callApiForGetShippingAttributes(
        "${Config.strBaseURL}shopping_cart_items/shippingsetting");
    if (result["errorCode"] == "0") {
      if (result['value'] != null) {
        mShippingCartAttributeModel = result['value'];
      }
    } else {
      isError = true;
    }
  }

  Future getShoppingCartItemNumber() async {
    Map result = await AddProductIntoCartParser.callApiForGetCartItemTotal(
        "${Config.strBaseURL}shopping_cart_items/" + customerId.toString());
    if (result["errorCode"] == "0") {
      if (this.mounted) {
        setState(() {
          Constants.cartItemCount = result["value"];
          HomeScreenState.listener.onRefresh();
        });
      }
    } else {
      isError = true;
    }
  }

  Future getCustomerAttributeAddress() async {
    Map result = await CustomerAddressListParser.callApiForGetContry(
        "${Config.strBaseURL}customers/getcustomerattributeaddress");
    if (result["errorCode"] == "0") {
      List countryList = result["value"];
      countryModelList =
          countryList.map((c) => new CountryModel.fromMap(c)).toList();
      countryDropDownModel = new CountryDropDownModel(values: countryModelList);
    } else {
      isError = true;
    }
  }

  Future getCheckoutAttributes() async {
    Map result = await CheckOutAttributes.callApi(
        "${Config.strBaseURL}shopping_cart_items/checkoutattributeincart?customerId=" +
            customerId.toString());
    if (result["errorCode"] == "0") {
      checkoutAttributesModel = result["value"];
    } else {
      isErrorInCheckoutAttribute = true;
    }
  }

  Future callApiForGetStates(String countryId) async {
    Map result = await CustomerAddressListParser.callApiForGetStates(
        "${Config.strBaseURL}customers/getstatesbycountryid?countryId=" +
            countryId);
    if (result["errorCode"] == "0") {
      List list = result["value"];
      stateModelList =
          list.map((c) => new StateModel.fromMapForStates(c)).toList();
      stateDropDownModel = new StateDropDownModel(values: stateModelList);
    } else {
      isError = true;
    }
  }

  Future applyDiscountCoupon(String string) async {
    if (discountCodeController.text != null) {
      Map result = await CustomerAddressListParser.applyCouponCode(
          "${Config.strBaseURL}shopping_cart_items/applydiscountcoupon?discountcouponcode=" +
              string +
              "&customerId=" +
              customerId.toString());
      if (result["errorCode"] == 0) {
        await appliedDiscountCoupon();
        await getCartProductListPriceTotal();
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      } else {
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      }
    }
  }

  Future appliedDiscountCoupon() async {
    if (discountCodeController.text != null) {
      Map result = await CustomerAddressListParser.appliedCouponCode(
          "${Config.strBaseURL}shopping_cart_items/applieddiscountcouponcode?customerId=" +
              customerId.toString());
      if (result["errorCode"] == 0) {
        mCouponCodeModelList = result['value'];
        if (this.mounted) {
          setState(() {});
        }
      }
    }
  }

  Future removeDiscountCoupon(String string) async {
    if (discountCodeController.text != null) {
      Map result = await CustomerAddressListParser.removeCouponCode(
          "${Config.strBaseURL}shopping_cart_items/removediscountcoupon?discountcouponcode=" +
              string +
              "&customerId=" +
              customerId.toString());
      if (result["errorCode"] == 0) {
        String msg = result['value'];
        Fluttertoast.showToast(msg: msg.toString());
        await appliedDiscountCoupon();
        await getCartProductListPriceTotal();
        setState(() {});
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      } else {
        String msg = result['value'];
        Fluttertoast.showToast(msg: msg.toString());
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      }
    }
  }

  Future removeGiftCoupon(String string) async {
    Map result = await CustomerAddressListParser.removeGiftCode(
        "${Config.strBaseURL}shopping_cart_items/removegiftcardcode?giftcardcouponcode=" +
            string +
            "&customerId=" +
            customerId.toString());
    if (result["errorCode"] == 0) {
      String msg = result['value'];
      Fluttertoast.showToast(msg: msg.toString());
      await appliedGiftCard();
      await getCartProductListPriceTotal();
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    } else {
      String msg = result['value'];
      Fluttertoast.showToast(msg: msg.toString());
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    }
  }

  Future applyGiftCardCoupon(String string) async {
    if (giftCardController.text != null) {
      Map result = await CustomerAddressListParser.applyGiftCode(
          "${Config.strBaseURL}shopping_cart_items/applygiftcard?giftcardcouponcode=" +
              string +
              "&customerId=" +
              customerId.toString());
      if (result["errorCode"] == 0) {
        Fluttertoast.showToast(msg: result['value'].toString());
        await appliedGiftCard();
        await getCartProductListPriceTotal();
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      } else {
        Fluttertoast.showToast(msg: result['value'].toString());
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      }
    }
  }

  Future appliedGiftCard() async {
    Map result = await CustomerAddressListParser.appliedGiftCard(
        "${Config.strBaseURL}shopping_cart_items/appliedgiftcard?customerId=" +
            customerId.toString());
    if (result["errorCode"] == 0) {
      mGiftCodeCardList = result['value'];
    } else {
    }
  }

  Future increaseQuantity(CartProductListModel cartItemList) async {
    Map result = await AddProductIntoCartParser.callApiCartItemIncrese(
        "${Config.strBaseURL}shopping_cart_items/updatecart?quantity=" +
            (cartItemList.quantityByUser + 1).toString() +
            "&shoppingcartId=" +
            cartItemList.deleteCartId.toString() +
            "&removeshoppingcartId=0&customerId=" +
            customerId.toString());
    if (result["errorCode"] == "0") {
      ///addCouponList = result['value'];
      add(cartItemList);
      await getCartProductListPriceTotal();
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      setState(() {});
    } else {
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: LanguageStrings.quantityLabel,
      );
    }
  }

  Future estimateShippingClick() async {
    Map result = await CustomerAddressListParser.estimateShippingClick(
        "${Config.strBaseURL}shopping_cart_items/getestimateshipping?countryId=" +
            countryModel.strValue.toString() +
            "&stateProvinceId=" +
            mStateModel.strValue.toString() +
            "&zipPostalCode=" +
            zipCodeController.text.toString() +
            "&customerId=" +
            customerId.toString());
    if (result["errorCode"] == 0) {
      estimateShippingList = result['value'];
    }
  }

  Future decreaseQuantity(CartProductListModel cartItemList) async {
    Map result = await AddProductIntoCartParser.callApiDecrease(
        "${Config.strBaseURL}shopping_cart_items/updatecart?quantity=" +
            (cartItemList.quantityByUser - 1).toString() +
            "&shoppingcartId=" +
            cartItemList.deleteCartId.toString() +
            "&removeshoppingcartId=0&customerId=" +
            customerId.toString());
    if (result["errorCode"] == "0") {
      await getCartProductListPriceTotal();
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      setState(() {});
    } else {
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(msg: LanguageStrings.quantityLabel);
    }
  }

  void errorDialog(List<EstimateShippingMethod> estimateShippingList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 1,
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: new ListView(
                    shrinkWrap: true,
                    children: new List<Widget>.generate(
                        estimateShippingList.length, (index) {
                      return new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          TitleText(
                              align: TextAlign.start,
                              text:
                                  estimateShippingList[index].mName.toString() +
                                      "(" +
                                      estimateShippingList[index]
                                          .mPrice
                                          .toString() +
                                      ")"),
                          SizedBox(height: 10.0),
                          Body1Text(
                              align: TextAlign.start,
                              text: estimateShippingList[index]
                                  .mDescription
                                  .toString())
                        ],
                      );
                    }),
                  ),
                ),
              )
            ],
          );
        });
  }

  void minus(CartProductListModel cartItemList) {
    setState(() {
      if (cartItemList.quantityByUser > 0) {
        cartItemList.quantityByUser--;
      }
    });
  }

  void add(CartProductListModel cartItemList) {
    setState(() {
      cartItemList.quantityByUser++;
    });
  }

  void _showDialog(int index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(Constants.getValueFromKey(
                  "Common.FileUploader.RemoveDownload", resourceData) +
              " !"),
          content: new Text(Constants.getValueFromKey(
              "nop.AddCartScreen.removeSubTitle", resourceData)),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                  Constants.getValueFromKey("Admin.Common.No", resourceData)
                      .toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                  Constants.getValueFromKey("Admin.Common.Yes", resourceData)
                      .toUpperCase()),
              onPressed: () {
                setState(() {
                  Constants.progressDialog(
                      true,
                      context,
                      Constants.getValueFromKey(
                          "nop.ProgressDilog.title", resourceData));
                  deleteItem(cartItemList[index].deleteCartId);
                  cartItemList.removeAt(index);
                  Constants.progressDialog(
                      false,
                      context,
                      Constants.getValueFromKey(
                          "nop.ProgressDilog.title", resourceData));
                  Navigator.of(context).pop();
                });
              },
            ), // usually buttons at the bot
          ],
        );
      },
    );
  }

  void onClickSubmitBtn() {
    //todo isShippingMethodEnable
    navigatePush(AddressScreenForCheckOut(
      isShippingMethodEnable: true,
      mCartProductListModel: mCartProductListModel,
    ));
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    var connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isInternet = await Constants.isInternetAvailable();
      if (isLoading == null) {
        isLoading = true;
      }
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  navigatePush(Widget page) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }

    Future callAPIforGiftwrap() async {
      Map result = await AddProductIntoCartParser.callApiGiftWrap(
          "${Config.strBaseURL}shopping_cart_items/checkoutattributechange/?customerId="
              +customerId.toString()+"&checkoutAttribute=checkout_attribute_1_"+giftwrapstatus.toString());
         /* "${Config.strBaseURL}shopping_cart_items/updatecart?quantity=" +
              (cartItemList.quantityByUser - 1).toString() +
              "&shoppingcartId=" +
              cartItemList.deleteCartId.toString() +
              "&removeshoppingcartId=0&customerId=" +
              customerId.toString());*/
      if (result["errorCode"] == "0") {
        isApplied = result["value"];
        await getCartProductListPriceTotal();
      /*  Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));*/
        setState(() {});
      } else {
       /* Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));*/
       // Fluttertoast.showToast(msg: LanguageStrings.quantityLabel);
      }
    }
}
