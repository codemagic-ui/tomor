import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/AddressModel/AddressModel.dart';
import 'package:i_am_a_student/models/AddressModel/CustomAddressAttributeModel.dart';
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/models/OrderItemModel.dart';
import 'package:i_am_a_student/models/OrderModel.dart';
import 'package:i_am_a_student/pages/OrderPlacedSuccess.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/LoadingScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/GetPaymentInfoParser.dart';
import 'package:i_am_a_student/parser/InsertConfirmOrderParser.dart';
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

class ConfirmOrderScreen extends StatefulWidget {
  final String systemName;
  final String strPaymentMethodName;
  final String strShippingMethodName;
  final List<CartProductListModel> cartItemList;

  ConfirmOrderScreen(
      {this.systemName,
        this.strPaymentMethodName,
        this.strShippingMethodName,
        this.cartItemList});


  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  bool isInternet;
  bool isLoading;
  bool isError = false;

  int customerId;

  OrderModel orderModel;
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
      return NoInternetScreen(onPressedRetyButton: () {
        internetConnection();
      });
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
          title: Text(Constants.getValueFromKey("Checkout.ConfirmOrder", resourceData)),
        ),
        body: isLoading ? LoadingScreen() : layout(),
      ),
    );
  }

  Widget layout() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(8.0),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10.0),
            Image.asset(
              ImageStrings.imgStepperForShippingMethod4,
              height: 70.0,
            ),
            SizedBox(height: 10.0),
            billingAddressCard(orderModel.billingAddress),
            shippingAddressCard(orderModel.shippingAddress),
            SizedBox(height: 8.0),
            paymentMethod(),
            SizedBox(height: 8.0),
            shippingMethod(),
            SizedBox(height: 8.0),
            orderItemList(),
            layoutTotal()
          ],
        ),
      ],
    );
  }

  Widget billingAddressCard(AddressModel model) {
    return new Card(
      child: new ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(
          Icons.assignment,
          color: AppColor.appColor,
        ),
        title: Body2Text(
            text:  Constants.getValueFromKey("Order.BillingAddress", resourceData), color: AppColor.appColor),
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      name(model),
                      email(model),
                      phone(model),
                      faxNumber(model),
                      company(model),
                      addressLine1(model),
                      addressLine2(model),
                      cityStatePostalCodeLayout(model),
                      country(model),
                      customAddressAttributes(model),
                      new SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget shippingAddressCard(AddressModel model) {
    return new Card(
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
                text: Constants.getValueFromKey("Order.Shipments.ShippingAddress", resourceData), color: AppColor.appColor),
            children: <Widget>[
              new Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      name(model),
                      email(model),
                      phone(model),
                      faxNumber(model),
                      company(model),
                      addressLine1(model),
                      addressLine2(model),
                      cityStatePostalCodeLayout(model),
                      country(model),
                      customAddressAttributes(model),
                      new SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget name(AddressModel model) {
    String name = "";
    if (model.firstName != null && model.firstName.isNotEmpty) {
      name = "${model.firstName} ";
    }
    if (model.lastName != null && model.lastName.isNotEmpty) {
      name = "$name${model.lastName} ";
    }
    if (name.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15.0),
        child: new TitleText(text: "${model.firstName} "),
      );
    } else {
      return Container();
    }
  }

  Widget email(AddressModel model) {
    if (model.email != null && model.email.isNotEmpty) {
      return new Body1Text(
        text: Constants.getValueFromKey("Vendors.ApplyAccount.Email", resourceData)+": ${model.email}",
      );
    }
    return Container();
  }

  Widget phone(AddressModel model) {
    if (model.phoneNumber != null && model.phoneNumber.isNotEmpty) {
      return new Body1Text(
        text: Constants.getValueFromKey("Account.Fields.Phone", resourceData)+": ${model.phoneNumber}",
      );
    }
    return Container();
  }

  Widget faxNumber(AddressModel model) {
    if (model.faxNumber != null && model.faxNumber.isNotEmpty) {
      return new Body1Text(
        text: Constants.getValueFromKey("Address.Fields.FaxNumber", resourceData)+": ${model.faxNumber}",
      );
    }
    return Container();
  }

  Widget company(AddressModel model) {
    if (model.isCompanyEnable != null && model.isCityEnabled) {
      if (model.company != null && model.company.isNotEmpty) {
        return new Body1Text(
          text: "${model.company}",
        );
      }
    }

    return Container();
  }

  Widget addressLine1(AddressModel model) {

    if (model.addressLine1 != null && model.addressLine1.isNotEmpty) {
      return new Body1Text(
        text: "${model.addressLine1}",
      );

    }

    return Container();
  }

  Widget addressLine2(AddressModel model) {

    if (model.addressLine2 != null && model.addressLine2.isNotEmpty) {
      return new Body1Text(
        text: "${model.addressLine2}",
      );
    }


    return Container();
  }

  Widget cityStatePostalCodeLayout(AddressModel model) {
    String text = "";

    if (model.city != null && model.city.isNotEmpty) {
      text = "${model.city} ";

    }

    if (model.stateProvinceName != null && model.stateProvinceName.isNotEmpty) {
      text = "$text${model.stateProvinceName} ";
    }


    if (model.zipPostalCode != null && model.zipPostalCode.isNotEmpty) {
      text = "$text${model.zipPostalCode}";

    }

    if (text.isNotEmpty) {
      return Body1Text(text: text);
    }

    return Container();
  }

  Widget country(AddressModel model) {
    if (model.isCountryEnabled != null && model.isCountryEnabled) {
      if (model.countryName != null && model.countryName.isNotEmpty) {
        return new Body1Text(
          text: "${model.countryName}",
        );
      }
    }

    return Container();
  }

  Widget customAddressAttributes(AddressModel model) {
    if (model.customAddressAttributeModelList.length != 0) {
      return Column(
        children: List<Widget>.generate(
            model.customAddressAttributeModelList.length, (int index) {
          CustomAddressAttributeModel attributeModel =
              model.customAddressAttributeModelList[index];
          switch (attributeModel.attributeControlType) {
            case 4:
              return valueOfTextFormAttribute(attributeModel);
              break;
            case 10:
              return valueOfMultilineTextFormField(attributeModel);
              break;
            case 1:
              return valueOfDropDownAttribute(attributeModel);
              break;
            case 3:
              return valueOfCheckBoxes(attributeModel);
              break;
            case 50:
              return valueOfReadOnlyCheckBox(attributeModel);
              break;
            case 2:
              return valueOfRadioList(attributeModel);
              break;
            default:
              return null;
              break;
          }
        }),
      );
    }

    return Container();
  }

  Widget valueOfTextFormAttribute(CustomAddressAttributeModel attributeModel) {
    String text = "";
    if (attributeModel.attributeName != null &&
        attributeModel.attributeName.isNotEmpty) {
      text = "${attributeModel.attributeName}: ";
    }
    if (attributeModel.defaultValue != null &&
        attributeModel.defaultValue.isNotEmpty) {
      text = "$text${attributeModel.defaultValue}";
    } else {
      text = "";
    }
    if (text.isNotEmpty) {
      return Body1Text(text: text);
    }
    return Container();
  }

  Widget paymentMethod() {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleText(
            text: Constants.getValueFromKey("Admin.Configuration.Settings.Tax.BlockTitle.Payment", resourceData),
            color: AppColor.appColor,
          ),
          SizedBox(height: 5.0),
          Body1Text(text: Constants.getValueFromKey("Admin.Orders.Fields.PaymentMethod", resourceData)+": ${widget.strPaymentMethodName}"),
        ],
      ),
    ));
  }

  Widget shippingMethod() {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleText(
            text: Constants.getValueFromKey("Admin.Orders.Report.Shipping", resourceData),
            color: AppColor.appColor,
          ),
          SizedBox(height: 5.0),
          Body1Text(text: Constants.getValueFromKey("Order.Shipments.ShippingMethod", resourceData)+": ${widget.strShippingMethodName}"),
        ],
      ),
    ));
  }

  Widget orderItemList() {
    return SizedBox(
      height: 120.0,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children:
            List<Widget>.generate(orderModel.orderItemList.length, (index) {
          OrderItemModel model = orderModel.orderItemList[index];
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
                        child: model.image != null && model.image.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: model.image,
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
                                  text: model.name != null ? model.name : "",
                                  maxLine: 2,
                                  align: TextAlign.start,
                                ),
                                SizedBox(height: 5.0),
                                model.rating != null
                                    ? new RatingBar(
                                        size: 15.0,
                                        rating: double.parse(
                                            model.rating.toString()),
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
                                  text: model.price.toString(),
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

  Widget quantity(OrderItemModel model) {
    if (model.quantity != null && model.quantity.toString().isNotEmpty) {
      return Body2Text(text: Constants.getValueFromKey("PDFInvoice.ProductQuantity", resourceData)+": ${model.quantity}", align: TextAlign.end);
    }

    return Container();
  }

  Widget oldPrice(OrderItemModel cartItemList) {
    if (cartItemList.oldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${cartItemList.oldPrice}",
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

  Widget layoutTotal() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
        Widget>[
      new Card(
        child: Column(
          children: <Widget>[
            orderModel.subTotal != null && orderModel.subTotal.isNotEmpty
                ? new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Body1Text(text: Constants.getValueFromKey("ShoppingCart.Totals.SubTotal", resourceData))),
                        Body2Text(text: orderModel.subTotal.toString()),
                      ],
                    ),
                  )
                : Container(),
            orderModel.shipping != null && orderModel.shipping.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Body1Text(text: Constants.getValueFromKey("Order.Shipments.ShippingAddress", resourceData))),
                        Body2Text(text: orderModel.shipping.toString()),
                      ],
                    ),
                  )
                : Container(),
            orderModel.tax != null && orderModel.tax.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Body1Text(text: Constants.getValueFromKey("ShoppingCart.Totals.Tax", resourceData))),
                        Body2Text(text: orderModel.tax.toString()),
                      ],
                    ),
                  )
                : Container(),
            orderModel.orderTotalDiscount != null &&
                    orderModel.orderTotalDiscount.toString().isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Fields.Edit.OrderTotalDiscount", resourceData))),
                        Body2Text(
                            text: orderModel.orderTotalDiscount.toString()),
                      ],
                    ),
                  )
                : Container(),
            orderModel.redeemedRewardPoints != null &&
                    orderModel.redeemedRewardPoints.toString().isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Body1Text(text: Constants.getValueFromKey("ShoppingCart.Totals.RewardPoints.WillEarn", resourceData))),
                        Body2Text(
                          text: orderModel.redeemedRewardPoints.toString() +
                              " "+Constants.getValueFromKey("Admin.Customers.Customers.RewardPoints.Fields.Points", resourceData),
                        ),
                      ],
                    ),
                  )
                : Container(),
            orderModel.orderTotal != null && orderModel.orderTotal.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Products.Total", resourceData))),
                        TitleText(
                            text: orderModel.orderTotal.toString(),
                            color: Colors.blue),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      RaisedBtn(
          onPressed: () {
            onClickConfirm();
          },
          text: Constants.getValueFromKey("Checkout.ConfirmButton", resourceData).toUpperCase())
    ]);
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  void onClickConfirm() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Map result = await InsertConfirmOrderParser.callApi(
          "${Config.strBaseURL}checkouts/confirmorder?customerId=$customerId");
      Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      if (result["errorCode"] == 0) {
        var value = result["value"];
        navigatePush(OrderPlacedSuccess(value.toString()));
      } else {
        Fluttertoast.showToast(msg: result["value"]);
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: Constants.getValueFromKey("nop.LoginScreen.NoInternet", resourceData));
    }
  }

  void callApi() async {
    await getPreferences();
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }
    if (isInternet) {
      var result = await GetPaymentInfoParser.callApi("${Config.strBaseURL}checkouts/getpaymentinfo?systemname=${widget.systemName}&customerId=$customerId");
      if (result["errorCode"] == 0) {
        var value = result["value"];
        orderModel = value[1];
      } else {
        String msg = result['msg'];
        Fluttertoast.showToast(
          msg: msg.toString(),
        );
        isError = true;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  valueOfMultilineTextFormField(CustomAddressAttributeModel attributeModel) {
    String text = "";
    if (attributeModel.attributeName != null &&
        attributeModel.attributeName.isNotEmpty) {
      text = "${attributeModel.attributeName}: ";
    }
    if (attributeModel.defaultValue != null &&
        attributeModel.defaultValue.isNotEmpty) {
      text = "$text${attributeModel.defaultValue}";
    } else {
      text = "";
    }
    if (text.isNotEmpty) {
      return Body1Text(text: text);
    }
    return Container();
  }

  valueOfDropDownAttribute(CustomAddressAttributeModel attributeModel) {
    String text = "";

    if (attributeModel.values.length != 0) {
      for (int i = 0; i < attributeModel.values.length; i++) {
        if (attributeModel.values[i].isPreSelected) {
          text =
              "${attributeModel.attributeName}: ${attributeModel.values[i].name}";
        }
      }
    }

    if (text.isNotEmpty) {
      return Body1Text(text: text);
    }
    return Container();
  }

  valueOfCheckBoxes(CustomAddressAttributeModel attributeModel) {
    String text = "";
    List list = new List();
    if (attributeModel.values.length != 0) {
      for (int i = 0; i < attributeModel.values.length; i++) {
        if (attributeModel.values[i].isPreSelected) {
          text =
              "${attributeModel.attributeName}: ${attributeModel.values[i].name}";
          list.add(text);
        }
      }
    }

    if (list.length != 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(list.length, (index) {
          return Body1Text(text: list[index]);
        }),
      );
    }
    return Container();
  }

  valueOfReadOnlyCheckBox(CustomAddressAttributeModel attributeModel) {
    String text = "";
    List list = new List();
    if (attributeModel.values.length != 0) {
      for (int i = 0; i < attributeModel.values.length; i++) {
        if (attributeModel.values[i].isPreSelected) {
          text =
              "${attributeModel.attributeName}: ${attributeModel.values[i].name}";
          list.add(text);
        }
      }
    }

    if (list.length != 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(list.length, (index) {
          return Body1Text(text: list[index]);
        }),
      );
    }
    return Container();
  }

  valueOfRadioList(CustomAddressAttributeModel attributeModel) {
    String text = "";

    if (attributeModel.values.length != 0) {
      for (int i = 0; i < attributeModel.values.length; i++) {
        if (attributeModel.values[i].isPreSelected) {
          text =
              "${attributeModel.attributeName}: ${attributeModel.values[i].name}";
        }
      }
    }

    if (text.isNotEmpty) {
      return Body1Text(text: text);
    }
    return Container();
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
