import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/models/PaymentMethodModel.dart';
import 'package:i_am_a_student/pages/ConfirmOrderScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/SelectedBanking.dart';
import 'package:i_am_a_student/parser/InsertPaymentMethodParser.dart';
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

class PaymentScreen extends StatefulWidget {
  final List<PaymentMethodModel> paymentMethodModelList;
  final CartProductListModel mCartProductListModel;
  final List<CartProductListModel> cartItemList;


  final String strShippingMethodName;

  PaymentScreen(
      {this.paymentMethodModelList,
      this.mCartProductListModel,
      this.cartItemList,
      this.strShippingMethodName});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isInternet;
  bool isLoading;

  PaymentMethodModel radioValue1;

  int customerId;

  Map resourceData;

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
      return layoutMain();
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () async {
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
        appBar: AppBar(
          title: Text(Constants.getValueFromKey(
              "Admin.Configuration.Settings.Tax.BlockTitle.Payment",
              resourceData)),
        ),
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            SizedBox(height: 8.0),
            Image.asset(
              ImageStrings.imgStepperForShippingMethod3,
              height: 70.0,
            ),
            SizedBox(height: 35.0),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "${Constants.getValueFromKey("Admin.Orders.List.PaymentMethod", resourceData)}",
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            paymentMethod(),
            SizedBox(height: 10.0),
            productList(),
            SizedBox(height: 8.0),
            new Card(
                child: Column(
              children: <Widget>[
                widget.mCartProductListModel.itemSubTotal != null
                    ? new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Body1Text(
                                    text: Constants.getValueFromKey(
                                        "Order.SubTotal", resourceData))),
                            Body2Text(
                                text: widget.mCartProductListModel.itemSubTotal
                                    .toString()),
                          ],
                        ),
                      )
                    : Container(),
                widget.mCartProductListModel.itemSubTotalDiscount != null
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Body1Text(
                                    text: Constants.getValueFromKey(
                                        "Admin.Orders.Fields.Edit.OrderSubTotalDiscount",
                                        resourceData))),
                            Body2Text(
                                text: widget
                                    .mCartProductListModel.itemSubTotalDiscount
                                    .toString()),
                          ],
                        ),
                      )
                    : Container(),
                widget.mCartProductListModel.itemShipping != null
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Body1Text(
                                    text: Constants.getValueFromKey(
                                        "Admin.Orders.Fields.OrderShipping",
                                        resourceData))),
                            Body2Text(
                                text: widget.mCartProductListModel.itemShipping
                                    .toString()),
                          ],
                        ),
                      )
                    : Container(),
                widget.mCartProductListModel.itemTax != null
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Body1Text(
                                    text: Constants.getValueFromKey(
                                        "Admin.Orders.Fields.Tax",
                                        resourceData))),
                            Body2Text(
                                text: widget.mCartProductListModel.itemTax
                                    .toString()),
                          ],
                        ),
                      )
                    : Container(),
                widget.mCartProductListModel.itemOrderTotalDiscount != null
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
                                text: widget
                                    .mCartProductListModel.itemOrderTotalDiscount
                                    .toString()),
                          ],
                        ),
                      )
                    : Container(),
                widget.mCartProductListModel.itemTotal != null
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Body1Text(
                                    text: Constants.getValueFromKey(
                                        "Admin.CurrentCarts.Total",
                                        resourceData))),
                            TitleText(
                                text: widget.mCartProductListModel.itemTotal
                                    .toString(),
                                color: Colors.blue),
                          ],
                        ),
                      )
                    : Container(),
                widget.mCartProductListModel.itemEarnPoints != null &&
                        widget.mCartProductListModel.itemEarnPoints > 0
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
                              text: widget.mCartProductListModel.itemEarnPoints
                                      .toString() +
                                  " ${Constants.getValueFromKey("Admin.Orders.Fields.RedeemedRewardPoints.Points", resourceData)}",
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            )),
          ],
        ),
        bottomNavigationBar: new Container(
          decoration: BoxDecoration(
              border: Border(
                  top:
                      BorderSide(width: 0.5, color: Colors.grey.withAlpha(100)))),
          height: 65.0,
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Body1Text(
                      text: Constants.getValueFromKey(
                          "Admin.CurrentCarts.Total", resourceData),
                      align: TextAlign.start,
                    ),
                    HeadlineText(
                      text: widget.mCartProductListModel.itemTotal != null
                          ? widget.mCartProductListModel.itemTotal.toString()
                          : "\$0",
                      color: AppColor.appColor,
                    )
                  ],
                ),
              ),
              Expanded(
                  child: RaisedBtn(
                onPressed: radioValue1 != null
                    ? () {
                        onClickPay();
                      }
                    : null,
                text: Constants.getValueFromKey(
                    "nop.PaymentScreen.pay", resourceData),
                elevation: 0.0,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget productList() {
    if (widget.cartItemList.length == 0) {
      return Container();
    }
    return SizedBox(
      height: 120.0,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(widget.cartItemList.length, (index) {
          CartProductListModel model = widget.cartItemList[index];
          return new Card(
            child: Container(
              height: 110.0,
              width: 270.0,
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
                        child: model.addCartProductList[0].src != null &&
                                model.addCartProductList[0].src.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: model.addCartProductList[0].src,
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
                                  text: model.cartItemName != null
                                      ? model.cartItemName
                                      : "",
                                  maxLine: 2,
                                  align: TextAlign.start,
                                ),
                                SizedBox(height: 5.0),
                                model.cartItemRating != null
                                    ? new RatingBar(
                                        size: 15.0,
                                        rating: double.parse(
                                            model.cartItemRating.toString()),
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
                                  text: model.cartItemPrice.toString(),
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

  Widget oldPrice(CartProductListModel cartItemList) {
    if (cartItemList.cartItemOldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${cartItemList.cartItemOldPrice}",
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

  Widget quantity(CartProductListModel model) {
    if (model.cartItemQuantity != null &&
        model.cartItemQuantity.toString().isNotEmpty) {
      return Body2Text(
          text:
              "${Constants.getValueFromKey("PDFInvoice.ProductQuantity", resourceData)}: ${model.cartItemQuantity}",
          align: TextAlign.end);
    }

    return Container();
  }

  Widget paymentMethod() {
    if (widget.paymentMethodModelList == null) {
      return Container();
    }
    return Column(
      children: List<Widget>.generate(widget.paymentMethodModelList.length,
          (int index) {
        PaymentMethodModel model = widget.paymentMethodModelList[index];
        if (radioValue1 == null) {
          if (model.isSelected) {
            radioValue1 = model;
          }
        }
        return new Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: new ListTile(
                onTap: () {
                  setState(() {
                    radioValue1 = model;
                  });
                },
                title: Body2Text(text: model.name),
                leading: new Radio(
                  value: model,
                  groupValue: radioValue1,
                  onChanged: (value) {
                    setState(() {
                      radioValue1 = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Image.network(
                  model.logoUrl,
                  height: 35.0,
                  width: 35.0,
                ))
          ],
        );
      }),
    );
  }

  getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  void onClickPay() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Map encode = {"paymentmethod": radioValue1.paymentMethodSystemName};
      String strJson = json.encode(encode);
      Map result = await InsertPaymentMethodParser.callApi(
          "${Config.strBaseURL}checkouts/selectpaymentmethod?paymentmethod=" +
              radioValue1.paymentMethodSystemName.toString() +
              "&UseRewardPoints=false&customerId=$customerId",
          strJson);
      if (result["errorCode"] == 0) {
        //todo currently skip order info
        Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));

        navigatePush(SelectedBanking(
            mTitle: radioValue1.name,
            systemName: radioValue1.paymentMethodSystemName,
            orderId: "",
            cartItemList: widget.cartItemList,
            strShippingMethodName: widget.strShippingMethodName,
            orderTotalDecimal: 10,//mCartProductListModel.orderTotalDecimal,
            mCartProductInfo: "",//mCartProductListModel.cartItemName.toString()
        ));
      } else {
        Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: Constants.getValueFromKey(
              "nop.LoginScreen.NoInternet", resourceData));
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
