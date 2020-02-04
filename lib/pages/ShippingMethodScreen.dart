import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/models/PaymentMethodModel.dart';
import 'package:i_am_a_student/models/ShippingMethodModel.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/PaymentScreen.dart';
import 'package:i_am_a_student/parser/InsertShippingMethodParser.dart';
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

class ShippingMethodScreen extends StatefulWidget {
  final bool isShippingMethodEnable;
  final List<ShippingMethodModel> shippingMethodModelList;
  final List<CartProductListModel> cartItemList;
  final CartProductListModel mCartProductListModel;

  ShippingMethodScreen(
      {this.isShippingMethodEnable,
      this.shippingMethodModelList,
      this.cartItemList,
      this.mCartProductListModel});

  @override
  _ShippingMethodScreenState createState() => _ShippingMethodScreenState();
}

class _ShippingMethodScreenState extends State<ShippingMethodScreen> {
  bool isInternet;

  ShippingMethodModel groupValue;

  int customerId;

  List<PaymentMethodModel> paymentMethodModelList;
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
      return Scaffold(
        appBar: AppBar(
          title: Text(Constants.getValueFromKey("Admin.Orders.Fields.ShippingMethod", resourceData)),
        ),
        body: layout(),
      );
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () {
          internetConnection();
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
  }

  Widget layout() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            SizedBox(height: 10.0),
            Image.asset(
              widget.isShippingMethodEnable != null &&
                      widget.isShippingMethodEnable
                  ? ImageStrings.imgStepperForShippingMethod2
                  : ImageStrings.imgStepperForAddress,
              height: 70.0,
            ),
            SizedBox(height: 10.0),
            methodList(),
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
                            Expanded(child: Body1Text(text: Constants.getValueFromKey("Order.SubTotal", resourceData))),
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
                            Expanded(child: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Fields.Edit.OrderSubTotalDiscount", resourceData))),
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
                            Expanded(child: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Fields.OrderShipping", resourceData))),
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
                            Expanded(child: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Fields.Tax", resourceData))),
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
                                child: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Fields.OrderTotalDiscount", resourceData))),
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
                            Expanded(child: Body1Text(text: Constants.getValueFromKey("Admin.CurrentCarts.Total", resourceData))),
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

                            Expanded(child: Body1Text(text: Constants.getValueFromKey("ShoppingCart.Totals.RewardPoints.WillEarn", resourceData))),
                            Body2Text(
                              text: widget.mCartProductListModel.itemEarnPoints
                                      .toString() +
                                  " "+Constants.getValueFromKey("Admin.Customers.Customers.RewardPoints.Fields.Points", resourceData),
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
          padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Body1Text(
                      text: Constants.getValueFromKey("Admin.Orders.Fields.Edit.OrderTotal", resourceData),
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
                  onPressed: groupValue != null
                      ? () {
                          callApiToInsertShippingMethod();

                        }
                      : null,
                  text: Constants.getValueFromKey("Checkout.ThankYou.Continue", resourceData),
                  elevation: 0.0,
                ),
              )
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
                            topLeft:
                                Radius.circular(4.0),
                            bottomLeft:
                                Radius.circular(4.0)),
                        child: model.addCartProductList[0].src != null &&
                                model.addCartProductList[0].src.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: model.addCartProductList[0].src,
                                fit: BoxFit.cover,
                                placeholder:(context, url) =>
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
          text: Constants.getValueFromKey("PDFInvoice.ProductQuantity", resourceData)+": ${model.cartItemQuantity}", align: TextAlign.end);
    }

    return Container();
  }

  Widget methodList() {
    if (widget.shippingMethodModelList == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(widget.shippingMethodModelList.length,
          (int index) {
        ShippingMethodModel model = widget.shippingMethodModelList[index];
        if (groupValue == null) {
          if (model.isSelected) {
            groupValue = model;
          }
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: model,
                  groupValue: groupValue,
                  onChanged: (value) {
                    setState(() {
                      groupValue = value;
                    });
                  },
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        groupValue = model;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        nameWidget(model),
                        SizedBox(
                          height: 10.0,
                        ),
                        descriptionWidget(model),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget nameWidget(ShippingMethodModel model) {
    String text = "";
    if (model.name != null && model.name.isNotEmpty) {
      text = model.name;
      if (model.fee != null && model.fee.isNotEmpty) {
        text = text + " (${model.fee})";
      }
    }
    if (text.isNotEmpty) {
      return SubTitleText(text: text);
    }
    return Container();
  }

  Widget descriptionWidget(ShippingMethodModel model) {
    String text = "";
    if (model.description != null && model.description.isNotEmpty) {
      text = model.description;
    }
    if (text.isNotEmpty) {
      return Body1Text(
        text: text,
        maxLine: 4,
      );
    }
    return Container();
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  Future callApiToInsertShippingMethod() async {
    await getPreferences();

    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Map encode = {
        "shippingoption":
            "${groupValue.name}___${groupValue.shippingRateComputationMethodSystemName}",
      };
      String strJson = json.encode(encode);
      Map result = await InsertShippingMethodParser.callApi(
          "${Config.strBaseURL}checkouts/selectshippingmethod?shippingoption=${groupValue.name}___${groupValue.shippingRateComputationMethodSystemName}&customerId=" +
              customerId.toString(),
          strJson);
      if (result["errorCode"] == 0) {
        paymentMethodModelList = result["value"];
        Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
        navigatePush(PaymentScreen(
          paymentMethodModelList: paymentMethodModelList,
          mCartProductListModel: widget.mCartProductListModel,
          cartItemList: widget.cartItemList,
          strShippingMethodName: "${groupValue.name}",
        ));
      } else {
        Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      }
      setState(() {});
    }else{
      Fluttertoast.showToast(msg: Constants.getValueFromKey("Admin.Orders.Fields.InternetToast", resourceData));
    }

  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();

    setState(() {});
  }

  navigatePush(Widget page) async {
     var result = await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
    return result;
  }

  navigatePushReplacement(Widget page) async {
      await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }
}
