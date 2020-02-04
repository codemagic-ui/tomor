import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/MyOrderProductListModel.dart';
import 'package:i_am_a_student/pages/AddCartScreen.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/LoadingScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductDetailScreen.dart';
import 'package:i_am_a_student/pages/pdf_viewer.dart';
import 'package:i_am_a_student/parser/InsertConfirmOrderParser.dart';
import 'package:i_am_a_student/parser/OrderListParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderInformationScreen extends StatefulWidget {
  final String orderItemId;
  final String isFrom;

  OrderInformationScreen({
    this.isFrom,
    this.orderItemId,
  });

  @override
  _OrderInformationScreenState createState() => _OrderInformationScreenState();
}

class _OrderInformationScreenState extends State<OrderInformationScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;
  int customerId;
  SharedPreferences prefs;
  List<MyOrderProductListModel> cartItemList =
      new List<MyOrderProductListModel>();
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
    return WillPopScope(
      onWillPop: () {
        if (widget.isFrom == "OrderPlacedSuccess") {
          navigatePushReplacement(HomeScreen());
        } else {
          Navigator.pop(context);
        }
        return null;
      },
      child: Directionality(
        textDirection: Constants.checkRTL != null && Constants.checkRTL
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(Constants.getValueFromKey(
                "nop.OrderInformationScreen.MyOrder", resourceData)),
          ),
          body: !isLoading
              ? ListView(
                  padding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                Constants.getValueFromKey(
                                        "Account.CustomerOrders.OrderNumber",
                                        resourceData) +
                                    ": " +
                                    cartItemList.last.orderNumber.toString(),
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                              ),
                              SizedBox(height: 10.0),
                              Body1Text(
                                maxLine: 1,
                                text: Constants.getValueFromKey(
                                        "Admin.SalesReport.Average.OrderStatus",
                                        resourceData) +
                                    ": " +
                                    cartItemList.last.orderItemStatus
                                        .toString(),
                                color: Colors.red,
                              ),
                              SizedBox(height: 10.0),
                              new Body1Text(
                                text: Constants.getValueFromKey(
                                        "Order.OrderDate", resourceData) +
                                    ": " +
                                    cartItemList.last.orderItemDate.toString(),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        Container(
                          child: RaisedBtn(
                              onPressed: () {
                                if (cartItemList
                                        .last.orderOrderPdfInvoiceDownloadUrl !=
                                    null) {
                                  String url = cartItemList
                                      .last.orderOrderPdfInvoiceDownloadUrl
                                      .toString();
                                  launchURL(url);
                                } else {
                                  String urll =
                                      "http://defaultnop420.forefrontinfotech.com/orderdetails/pdf/${cartItemList.last.orderNumber}";
                                  launchURL(urll);
                                }
                              },
                              text: "PDF Invoice"),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Body2Text(
                          text: Constants.getValueFromKey(
                                  "Order.OrderTotal", resourceData) +
                              ": ",
                        ),
                        new Body2Text(
                          text: cartItemList
                                  .last.orderItemProductList[0].orderCurrency
                                  .toString() +
                              " " +
                              cartItemList.last.orderTotal.toString(),
                          color: AppColor.appColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    billingAndShippingAddress(),
                    SizedBox(height: 5.0),
                    Card(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TitleText(
                            text: Constants.getValueFromKey(
                                "Order.Payment", resourceData),
                            color: AppColor.appColor,
                          ),
                          SizedBox(height: 5.0),
                          Body1Text(
                              text: Constants.getValueFromKey(
                                      "Order.Payment.Method", resourceData) +
                                  ": " +
                                  cartItemList.last.orderPaymentMethod
                                      .toString()),
                          SizedBox(height: 5.0),
                          Body1Text(
                              text: Constants.getValueFromKey(
                                      "Order.Payment.Status", resourceData) +
                                  ": " +
                                  cartItemList.last.orderPaymentStatus
                                      .toString()),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    )),
                    SizedBox(height: 10.0),
                    Card(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TitleText(
                            text: Constants.getValueFromKey(
                                "Order.Shipping", resourceData),
                            color: AppColor.appColor,
                          ),
                          SizedBox(height: 5.0),
                          Body1Text(
                              text: Constants.getValueFromKey(
                                      "Order.Shipping.Name", resourceData) +
                                  ": " +
                                  cartItemList.last.orderShippingMethod
                                      .toString()),
                          SizedBox(height: 5.0),
                          Body1Text(
                              text: Constants.getValueFromKey(
                                      "Order.Shipping.Status", resourceData) +
                                  ": " +
                                  cartItemList.last.orderShippingStatus
                                      .toString()),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    )),
                    SizedBox(height: 10.0),
                    new Text(
                      Constants.getValueFromKey(
                          "ReturnRequests.Products.Name", resourceData),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 10.0),
                    productList(),
                    new Card(
                        child: Column(
                      children: <Widget>[
                        cartItemList.last.orderSubTotal != null
                            ? new Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Body1Text(
                                            text: Constants.getValueFromKey(
                                                "Messages.Order.SubTotal",
                                                resourceData))),
                                    Body2Text(
                                        text: cartItemList
                                                .last
                                                .orderItemProductList[0]
                                                .orderCurrency
                                                .toString() +
                                            cartItemList.last.orderSubTotal
                                                .toString()),
                                  ],
                                ),
                              )
                            : Container(),
                        cartItemList.last.orderShipping != null
                            ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Body1Text(
                                            text: Constants.getValueFromKey(
                                                "ShoppingCart.Totals.Shipping",
                                                resourceData))),
                                    Body2Text(
                                        text: cartItemList
                                                .last
                                                .orderItemProductList[0]
                                                .orderCurrency
                                                .toString() +
                                            cartItemList.last.orderShipping
                                                .toString()),
                                  ],
                                ),
                              )
                            : Container(),
                        cartItemList.last.orderTax != null
                            ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Body1Text(
                                            text: Constants.getValueFromKey(
                                                "ShoppingCart.Totals.Tax",
                                                resourceData))),
                                    Body2Text(
                                        text: cartItemList
                                                .last
                                                .orderItemProductList[0]
                                                .orderCurrency
                                                .toString() +
                                            cartItemList.last.orderTax
                                                .toString()),
                                  ],
                                ),
                              )
                            : Container(),
                        cartItemList.last.orderOrderTotalDiscount != null &&
                                cartItemList.last.orderOrderTotalDiscount != 0
                            ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Body1Text(
                                            text: Constants.getValueFromKey(
                                                "Admin.Orders.Fields.OrderTotalDiscount",
                                                resourceData))),
                                    Body2Text(
                                        text: cartItemList
                                                .last
                                                .orderItemProductList[0]
                                                .orderCurrency
                                                .toString() +
                                            cartItemList
                                                .last.orderOrderTotalDiscount
                                                .toString()),
                                  ],
                                ),
                              )
                            : Container(),
                        cartItemList.last.orderEarnPoints != null &&
                                cartItemList.last.orderEarnPoints > 0
                            ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Body1Text(
                                            text: Constants.getValueFromKey(
                                                "ShoppingCart.Totals.RewardPoints.WillEarn",
                                                resourceData))),
                                    Body2Text(
                                      text: cartItemList
                                              .last
                                              .orderItemProductList[0]
                                              .orderCurrency
                                              .toString() +
                                          cartItemList.last.orderEarnPoints
                                              .toString() +
                                          " " +
                                          Constants.getValueFromKey(
                                              "Admin.Orders.Fields.RedeemedRewardPoints.Points",
                                              resourceData),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        cartItemList.last.orderTotal != null
                            ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Body1Text(
                                            text: Constants.getValueFromKey(
                                                "Admin.Orders.Products.Total",
                                                resourceData))),
                                    TitleText(
                                        text: cartItemList
                                                .last
                                                .orderItemProductList[0]
                                                .orderCurrency
                                                .toString() +
                                            cartItemList.last.orderTotal
                                                .toString(),
                                        color: Colors.blue),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )),
                    RaisedBtn(
                        onPressed: () async {
                          Constants.progressDialog(
                              true,
                              context,
                              Constants.getValueFromKey(
                                  "nop.ProgressDilog.title", resourceData));
                          await reOrder();
                        },
                        text: Constants.getValueFromKey(
                                "Order.Reorder", resourceData)
                            .toUpperCase())
                  ],
                )
              : LoadingScreen(),
        ),
      ),
    );
  }

  Widget orderItemList() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.only(top: 5.0),
      children: <Widget>[
        new Container(
          height: 300.0,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: cartItemList.last.orderItemProductList.length,
              padding: EdgeInsets.only(left: 15.0),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    navigatePush(ProductDetailScreen(
                        productId: cartItemList
                            .last.orderItemProductList[index].orderItemId));
                  },
                  child: new Container(
                    width: 220.0,
                    margin: EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Expanded(
                            flex: 3,
                            child: new Container(
                              height: 130.0,
                              padding: EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4.0),
                                    topLeft: Radius.circular(4.0)),
                                child: CachedNetworkImage(
                                  imageUrl: cartItemList
                                      .last
                                      .orderItemProductList[index]
                                      .orderItemImage,
                                  placeholder: (context, url) => FlutterLogo(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          new Expanded(
                            flex: 2,
                            child: new Container(
                              margin: EdgeInsets.only(
                                top: 8.0,
                                left: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Body1Text(
                                    text: cartItemList
                                        .last
                                        .orderItemProductList[index]
                                        .orderItemName
                                        .toString(),
                                    maxLine: 3,
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Body2Text(
                                        text: Constants.getValueFromKey(
                                                "Order.Shipments.Product(s).SKU",
                                                resourceData) +
                                            ": ",
                                        color: AppColor.appColor,
                                        maxLine: 1,
                                      ),
                                      new Body1Text(
                                        text: cartItemList
                                            .last
                                            .orderItemProductList[index]
                                            .orderItemSku
                                            .toString(),
                                        maxLine: 1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  new RatingBar(
                                    size: 15.0,
                                    rating: double.parse(cartItemList
                                        .last
                                        .orderItemProductList[index]
                                        .orderItemRating
                                        .toString()),
                                    color: AppColor.appColor,
                                  ),
                                  SizedBox(height: 3.0),
                                  oldPriceText(index),
                                  SizedBox(height: 8.0),
                                  new Body2Text(
                                      maxLine: 1,
                                      text: cartItemList
                                          .last
                                          .orderItemProductList[index]
                                          .orderItemPrice
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Body1Text(
                                    text: Constants.getValueFromKey(
                                            "PDFInvoice.ProductQuantity",
                                            resourceData) +
                                        ": "),
                                new Body1Text(
                                    text: cartItemList
                                        .last
                                        .orderItemProductList[index]
                                        .orderItemQuantity
                                        .toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget productList() {
    if (cartItemList.length == 0) {
      return Container();
    }
    return SizedBox(
      height: 120.0,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(
            cartItemList.last.orderItemProductList.length, (index) {
          MyOrderProductListModel model =
              cartItemList.last.orderItemProductList[index];
          return new Card(
            child: Container(
              height: 110.0,
              width: 335.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: new Container(
                      width: 100.0,
                      height: 110.0,
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0)),
                        child: model.orderItemImage != null &&
                                model.orderItemImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: model.orderItemImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Image.asset(ImageStrings.imgPlaceHolder),
                              )
                            : Image.asset(ImageStrings.imgPlaceHolder),
                      ),
                    ),
                  ),
                  new Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new SubHeadText(
                                  text: model.orderItemName != null
                                      ? model.orderItemName
                                      : "",
                                  maxLine: 2,
                                  align: TextAlign.start,
                                ),
                                SizedBox(height: 5.0),
                                model.orderItemRating != null
                                    ? new RatingBar(
                                        size: 15.0,
                                        rating: double.parse(
                                            model.orderItemRating.toString()),
                                        color: AppColor.appColor,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          oldPrice(model),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 8.0),
                              Expanded(
                                child: new TitleText(
                                  align: TextAlign.start,
                                  text: model.orderItemPrice.toString(),
                                  color: AppColor.appColor,
                                ),
                              ),
                              quantity(model),
                            ],
                          ),
                        ],
                      ),
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

  Widget oldPrice(MyOrderProductListModel model) {
    if (model.orderItemOldPrice != null) {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new RichText(
            text: new TextSpan(
              text: model.orderItemOldPrice.toString(),
              style: new TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12.0),
            ),
          )
        ],
      );
    }

    return Container();
  }

  Widget quantity(MyOrderProductListModel model) {
    if (model.orderItemQuantity != null &&
        model.orderItemQuantity.toString().isNotEmpty) {
      return Body2Text(
          text: Constants.getValueFromKey(
                  "PDFInvoice.ProductQuantity", resourceData) +
              ": ${model.orderItemQuantity}",
          align: TextAlign.end);
    }

    return Container();
  }

  Widget billingAndShippingAddress() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        new Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new ExpansionTile(
                initiallyExpanded: true,
                leading: Icon(
                  Icons.assignment,
                  color: AppColor.appColor,
                ),
                title: Body2Text(
                    text: Constants.getValueFromKey(
                        "Order.BillingAddress", resourceData),
                    color: AppColor.appColor),
                children: <Widget>[
                  new Container(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new TitleText(
                                  text: cartItemList.last.billingAddressMap
                                          .customerFirstName +
                                      " " +
                                      cartItemList.last.billingAddressMap
                                          .customerLastName),
                              new SizedBox(
                                height: 15.0,
                              ),
                              Body1Text(
                                  text: Constants.getValueFromKey(
                                          "Vendors.ApplyAccount.Email",
                                          resourceData) +
                                      ": " +
                                      cartItemList
                                          .last.billingAddressMap.customerEmail
                                          .toString()),
                              Body1Text(
                                  text: Constants.getValueFromKey(
                                          "Address.Fields.PhoneNumber",
                                          resourceData) +
                                      ": " +
                                      cartItemList
                                          .last.billingAddressMap.customerPhone
                                          .toString()),
                              Body1Text(
                                  text: Constants.getValueFromKey(
                                          "Admin.Orders.Address.Fax",
                                          resourceData) +
                                      ": " +
                                      cartItemList
                                          .last.billingAddressMap.customerFax
                                          .toString()),
                              Body1Text(
                                  text: cartItemList
                                      .last.billingAddressMap.customerCompany
                                      .toString()),
                              Body1Text(
                                  text: cartItemList
                                      .last.billingAddressMap.customerAddress1
                                      .toString()),
                              cartItemList.last.billingAddressMap
                                              .customerAddress2 !=
                                          null &&
                                      cartItemList.last.billingAddressMap
                                              .customerAddress2 !=
                                          ""
                                  ? Body1Text(
                                      text: cartItemList.last.billingAddressMap
                                          .customerAddress2
                                          .toString())
                                  : Container(),
                              Body1Text(
                                  text: cartItemList
                                          .last.billingAddressMap.customerCity
                                          .toString() +
                                      " " +
                                      cartItemList.last.billingAddressMap
                                          .customerZipCode
                                          .toString()),
                              Body1Text(
                                  text: cartItemList
                                      .last.billingAddressMap.customerCountry
                                      .toString()),
                              new SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          color: Colors.grey.withAlpha(100),
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        new Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new ExpansionTile(
                leading: Icon(
                  Icons.local_shipping,
                  color: AppColor.appColor,
                ),
                title: Body2Text(
                    text: Constants.getValueFromKey(
                        "Order.Shipments.ShippingAddress", resourceData),
                    color: AppColor.appColor),
                children: <Widget>[
                  new Container(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new TitleText(
                                  text: cartItemList.last.shippingAddressMap
                                          .customerFirstName +
                                      " " +
                                      cartItemList.last.shippingAddressMap
                                          .customerLastName),
                              new SizedBox(
                                height: 15.0,
                              ),
                              Body1Text(
                                  text: Constants.getValueFromKey(
                                          "Vendors.ApplyAccount.Email",
                                          resourceData) +
                                      ": " +
                                      cartItemList
                                          .last.shippingAddressMap.customerEmail
                                          .toString()),
                              Body1Text(
                                  text: Constants.getValueFromKey(
                                          "Address.Fields.PhoneNumber",
                                          resourceData) +
                                      ": " +
                                      cartItemList
                                          .last.shippingAddressMap.customerPhone
                                          .toString()),
                              cartItemList.last.shippingAddressMap
                                          .customerFax !=
                                      null
                                  ? Body1Text(
                                      text: Constants.getValueFromKey(
                                              "Admin.Orders.Address.Fax",
                                              resourceData) +
                                          ": " +
                                          cartItemList.last.shippingAddressMap
                                              .customerFax
                                              .toString())
                                  : Container(),
                              Body1Text(
                                  text: cartItemList
                                      .last.shippingAddressMap.customerCompany
                                      .toString()),
                              Body1Text(
                                  text: cartItemList
                                      .last.shippingAddressMap.customerAddress1
                                      .toString()),
                              cartItemList.last.shippingAddressMap
                                              .customerAddress2 !=
                                          null &&
                                      cartItemList.last.shippingAddressMap
                                              .customerAddress2 !=
                                          ""
                                  ? Body1Text(
                                      text: cartItemList.last.shippingAddressMap
                                          .customerAddress2
                                          .toString())
                                  : Container(),
                              Body1Text(
                                  text: cartItemList
                                          .last.shippingAddressMap.customerCity
                                          .toString() +
                                      " " +
                                      cartItemList.last.shippingAddressMap
                                          .customerZipCode
                                          .toString()),
                              Body1Text(
                                  text: cartItemList
                                      .last.shippingAddressMap.customerCountry
                                      .toString()),
                              new SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          color: Colors.grey.withAlpha(100),
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget oldPriceText(int index) {
    if (cartItemList.last.orderItemProductList[index].orderItemOldPrice <
        cartItemList.last.orderItemProductList[index].orderItemPrice) {
      if (cartItemList.last.orderItemProductList[index].orderItemOldPrice > 0) {
        return new RichText(
          maxLines: 1,
          text: new TextSpan(
            text:
                " ${cartItemList.last.orderItemProductList[index].orderItemOldPrice}",
            style: new TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                fontSize: 12.0),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      try {
        await getSharedPref();
        await orderListCallApi();
      } catch (e) {
        print(e);
        isError = true;
        isLoading = false;
      }
      isLoading = false;
      setState(() {});
    }
  }

  Future getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future reOrder() async {
    Map result = await InsertConfirmOrderParser.callApiForReOrder(
        "${Config.strBaseURL}orders/reorder?orderId=" +
            widget.orderItemId +
            "&customerId=" +
            customerId.toString());
    Constants.progressDialog(false, context,
        Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    if (result["errorCode"] == 0) {
      navigatePush(AddCartScreen(
        isFromProductDetailScreen: false,
      ));
    } else {
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
        msg: Constants.getValueFromKey(
            "nop.OrderInformation.ItemNotAdded", resourceData),
      );
    }
  }

  Future orderListCallApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(Constants.prefUserIdKeyInt);
    Map result = await OrderListParser.callApi(
        "${Config.strBaseURL}orders?ids=" +
            widget.orderItemId +
            "&customer_id=" +
            userId.toString());
    if (result["errorCode"] == "0") {
      cartItemList = result['value'];
    } else {
      isError = true;
    }
    isLoading = false;
  }

  launchURL(String url) async {
    Directory appDocDir = await getExternalStorageDirectory();
    String dir = appDocDir.path;
    var dio = Dio();
    String cid = cartItemList.last.orderNumber.toString();
    String filename = "OrderInvoice$cid";
    await download1(dio, url, "$dir/Download/$filename.pdf");
  }

  Future download1(Dio dio, String url, savePath) async {
    Constants.progressDialog1(true, context);
    CancelToken cancelToken = CancelToken();
    try {
      await dio.download(url, savePath,
          onReceiveProgress: showDownloadProgress, cancelToken: cancelToken);
    } catch (e) {
      print(e);
    }
    Constants.progressDialog1(false, context);
    showDownloadAlert(savePath);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
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

  void showDownloadAlert(savePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Download Successful"),
          actions: <Widget>[
            Row(
              children: <Widget>[
                new FlatButton(
                  child: new Text("Open"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullPdfViewerScreen(savePath)),
                    );
                    //OpenFile.open(savePath);
                  },
                ),
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
