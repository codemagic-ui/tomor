import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/AddressModel/AddressModel.dart';
import 'package:i_am_a_student/models/AddressModel/CustomAddressAttributeModel.dart';
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/models/ShippingMethodModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/MyAddress.dart';
import 'package:i_am_a_student/pages/NewAddressScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ShippingMethodScreen.dart';
import 'package:i_am_a_student/parser/CartProductListParser.dart';
import 'package:i_am_a_student/parser/CustomerAddressListParser.dart';
import 'package:i_am_a_student/parser/InsertBillingAddressParser.dart';
import 'package:i_am_a_student/parser/InsertShippingAddressParser.dart';
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

class AddressScreenForCheckOut extends StatefulWidget {
  final bool isShippingMethodEnable;

  final CartProductListModel mCartProductListModel;

  AddressScreenForCheckOut(
      {this.isShippingMethodEnable, this.mCartProductListModel});

  @override
  _AddressScreenForCheckOutState createState() =>
      _AddressScreenForCheckOutState();
}

class _AddressScreenForCheckOutState extends State<AddressScreenForCheckOut> {

  bool isErrorInAddress = false;

  bool isErrorInCartItem = false;

  bool isError = false;

  bool isInternet;

  bool isLoading;

  List<AddressModel> addressList = new List<AddressModel>();

  List<CartProductListModel> cartItemList = new List<CartProductListModel>();

  AddressModel modelForBillingAddress;

  AddressModel modelForShippingAddress;

  var customerId;

  List<ShippingMethodModel> shippingMethodModelList;

  Map resourceData;

  @override
  void initState() {
    internetConnection();
    super.initState();
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
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

  Widget layoutMain() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants.getValueFromKey("PageTitle.Checkout", resourceData)),
        ),
        body: isLoading != null && !isLoading
            ? layout()
            : Center(
          child: SpinKitThreeBounce(
            color: AppColor.appColor,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  Widget layout() {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          SizedBox(height: 10.0),
          Image.asset(
            widget.isShippingMethodEnable != null &&
                widget.isShippingMethodEnable
                ? ImageStrings.imgStepperForShippingMethod1
                : ImageStrings.imgStepperForAddress,
            height: 70.0,
          ),
          SizedBox(height: 10.0),
          addressCard(),
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
                        Expanded(child: Body1Text(text: Constants.getValueFromKey("Admin.Orders.Fields.OrderTotalDiscount", resourceData)),),
                        Body2Text(text: widget.mCartProductListModel.itemOrderTotalDiscount.toString(),),
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
                              " "+Constants.getValueFromKey("Admin.Orders.Fields.RedeemedRewardPoints.Points", resourceData),
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
                onPressed: modelForShippingAddress != null &&
                    modelForBillingAddress != null
                    ? () {
                  onClickSubmitBtn();
                }
                    : null,
                text: Constants.getValueFromKey("Checkout.ThankYou.Continue", resourceData),
                elevation: 0.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addressCard() {
    if (addressList.length != 0) {
      return ifAddressIsFound();
    } else {
      return ifAddressIsNotFound();
    }
  }

  Widget ifAddressIsNotFound() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedBtn(
        onPressed: () async {
          await navigatePush(NewAddressScreen(
            appBar: Constants.getValueFromKey("admin.customers.customers.addresses.addbutton", resourceData),
            isUpdate: false,

          ));
          setState(() {
            isLoading = true;
          });
        },
        text: Constants.getValueFromKey("Account.CustomerAddresses.AddNew", resourceData),
        elevation: 0.0,
      ),
    );
  }

  Widget ifAddressIsFound() {
    return Column(
      children: <Widget>[billingAddressCard(), shippingAddressCard()],
    );
  }

  //region address
  Widget billingAddressCard() {
    AddressModel model = modelForBillingAddress;
    return new Card(
      child: new ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(
          Icons.assignment,
          color: AppColor.appColor,
        ),
        title: Body2Text(
            text: Constants.getValueFromKey("Order.BillingAddress", resourceData), color: AppColor.appColor),
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
                new Container(
                  color: Colors.grey.withAlpha(100),
                  height: 1.0,
                ),
                new Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTapEditBillAddress();
                        },
                        child: Container(
                            height: 45.0,
                            child: Center(
                                child: new Body2Text(
                                  text: Constants.getValueFromKey("Account.CustomerAddresses.Edit", resourceData).toUpperCase(),
                                  color: AppColor.appColor,
                                ))),
                      ),
                    ),
                    Container(
                      color: Colors.grey.withAlpha(100),
                      height: 45.0,
                      width: 1.0,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTapChangeBillAddress();
                        },
                        child: Container(
                            height: 45.0,
                            child: Center(
                                child: new Body2Text(
                                  text: Constants.getValueFromKey("nop.AddressScreenForCheckOut.changeAddress", resourceData).toUpperCase(),
                                  color: AppColor.appColor,
                                ))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shippingAddressCard() {
    AddressModel model = modelForShippingAddress;
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
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
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
                    new Container(
                      color: Colors.grey.withAlpha(100),
                      height: 1.0,
                    ),
                    new Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              onTapEditShippingAddress();
                            },
                            child: Container(
                                height: 45.0,
                                child: Center(
                                    child: new Body2Text(
                                      text: Constants.getValueFromKey("Account.CustomerAddresses.Edit", resourceData).toUpperCase(),
                                      color: AppColor.appColor,
                                    ))),
                          ),
                        ),
                        Container(
                          color: Colors.grey.withAlpha(100),
                          height: 45.0,
                          width: 1.0,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              onTapChangeShippingAddress(model);
                            },
                            child: Container(
                                height: 45.0,
                                child: Center(
                                    child: new Body2Text(
                                      text: Constants.getValueFromKey("nop.AddressScreenForCheckOut.changeAddress", resourceData).toUpperCase(),
                                      color: AppColor.appColor,
                                    ))),
                          ),
                        ),
                      ],
                    ),
                  ],
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
        child: new TitleText(text: "${model.firstName} ${model.lastName}"),
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
        text: Constants.getValueFromKey("Address.Fields.FaxNumber", resourceData)+" Number: ${model.faxNumber}",
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
    if (model.isAddressLineEnabled != null && model.isAddressLineEnabled) {
      if (model.addressLine1 != null && model.addressLine1.isNotEmpty) {
        return new Body1Text(
          text: "${model.addressLine1}",
        );
      }
    }

    return Container();
  }

  Widget addressLine2(AddressModel model) {
    if (model.isAddressLine2Enabled != null && model.isAddressLine2Enabled) {
      if (model.addressLine2 != null && model.addressLine2.isNotEmpty) {
        return new Body1Text(
          text: "${model.addressLine2}",
        );
      }
    }

    return Container();
  }

  Widget cityStatePostalCodeLayout(AddressModel model) {
    String text = "";
    if (model.isCityEnabled != null && model.isCityEnabled) {
      if (model.city != null && model.city.isNotEmpty) {
        text = "${model.city}";
      }
    }
    if (model.isStateProvinceEnabled != null && model.isStateProvinceEnabled) {
      if (model.stateProvinceName != null &&
          model.stateProvinceName.isNotEmpty) {
        text = "$text${model.stateProvinceName} ";
      }
    }

    if (model.isZipPostalCodeEnabled != null && model.isZipPostalCodeEnabled) {
      if (model.zipPostalCode != null && model.zipPostalCode.isNotEmpty) {
        text = "$text${model.zipPostalCode}";
      }
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

  //endregion

  Widget productList() {
    if (cartItemList.length == 0) {
      return Container();
    }
    return SizedBox(
      height: 120.0,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(cartItemList.length, (index) {
          CartProductListModel model = cartItemList[index];
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
                        child: model.addCartProductList.length != 0
                            ? CachedNetworkImage(
                          imageUrl: model.addCartProductList[0].src.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset(ImageStrings.noimage),
                        )
                            : Image.asset(ImageStrings.noimage),
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

  oldPrice(CartProductListModel model) {
    if (model.cartItemOldPrice != null) {
      return new RichText(
          text: new TextSpan(
            text: model.cartItemOldPrice.toString(),
            style: new TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                fontSize: 12.0),
          ));
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

  Future onTapEditBillAddress() async {
    await navigatePush(NewAddressScreen(
        model: modelForBillingAddress,
        isUpdate: true,
        appBar: Constants.getValueFromKey("admin.customers.customers.addresses.editaddress", resourceData)
    ));
    setState(() {
      isLoading = true;
    });
    internetConnection();
  }

  Future onTapEditShippingAddress() async {
    await navigatePush(NewAddressScreen(
        model: modelForShippingAddress,
        isUpdate: true,
        appBar: Constants.getValueFromKey("admin.customers.customers.addresses.editaddress", resourceData)
    ));
    setState(() {
      isLoading = true;
    });
    internetConnection();
  }

  void onTapChangeBillAddress() async {
    var result = await navigatePush(MyAddress(
      isFromCheckOutAddressScreen: true,
      model: modelForBillingAddress,
    ));
    if (result != null && result[0] != null) {
      setState(() {
        modelForBillingAddress = result[0];
      });
    }
  }

  void onTapChangeShippingAddress(AddressModel model) async {
    var result = await navigatePush(MyAddress(
      isFromCheckOutAddressScreen: true,
      model: model,
    ));
    if (result != null && result[0] != null) {
      setState(() {
        modelForShippingAddress = result[0];
      });
    }
  }

  Future onClickSubmitBtn() async {
    isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      if (modelForBillingAddress != null) {
        if (modelForShippingAddress != null) {
          Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
          int errorCode = await callApiForInsertBillingAddress();
          if (errorCode == 0) {
            int errorCode = await callApiForInsertShippingAddress();
            Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
            if (errorCode == 0) {
              navigatePush(ShippingMethodScreen(
                isShippingMethodEnable: true,
                shippingMethodModelList: shippingMethodModelList,
                cartItemList: cartItemList,
                mCartProductListModel: widget.mCartProductListModel,
              ));
            }
          } else {
            Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
          }
        } else {
          Fluttertoast.showToast(msg: Constants.getValueFromKey("nop.AddressScreenForCheckOut.addShippingAddress", resourceData));
        }
      } else {
        Fluttertoast.showToast(msg: Constants.getValueFromKey("nop.AddressScreenForCheckOut.addBillingAddress", resourceData));
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: Constants.getValueFromKey("nop.LoginScreen.NoInternet", resourceData));
    }
  }

  callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }
    if (isInternet) {
      await getPreferences();
      await getCustomerAddressList();
      await getCartItemList();
      isLoading = false;
      setState(() {});
    }
  }

  Future<int> callApiForInsertBillingAddress() async {
    Map encoder = {"AddressId": modelForBillingAddress.id};
    String strJson = json.encode(encoder);
    Map result = await InsertBillingAddressParser.callApi(
        "${Config.strBaseURL}checkouts/selectbillingaddress?addressId=" +
            modelForBillingAddress.id.toString() +
            "&customerId=$customerId",
        strJson);
    if (result["errorCode"] == 0) {
      return 0;
    } else {
      String error = result["msg"];
      print(error);
      Fluttertoast.showToast(msg: error);
    }
    return -1;
  }

  Future<int> callApiForInsertShippingAddress() async {
    Map encoder = {"AddressId": modelForShippingAddress.id};
    String strJson = json.encode(encoder);
    Map result = await InsertShippingAddressParser.callApi(
        "${Config.strBaseURL}checkouts/selectshippingaddress?addressId=" +
            modelForShippingAddress.id.toString() +
            "&customerId=$customerId",
        strJson);
    if (result["errorCode"] == 0) {
      shippingMethodModelList = result["value"];
      return 0;
    } else {
      String error = result["msg"];
      print(error);
      Fluttertoast.showToast(msg: error);
    }
    return -1;
  }

  Future getCustomerAddressList() async {
    Map result = await CustomerAddressListParser.callApi(
        "${Config.strBaseURL}customers/customersaddresses?customerId=$customerId");
    if (result["errorCode"] == "0") {
      addressList = result["value"];
      if (addressList.length != 0) {
        modelForBillingAddress = addressList[0];
        modelForShippingAddress = addressList[0];
      }
    } else {
      String error = result["msg"];
      print(error);
      isErrorInAddress = true;
    }
  }

  Future getCartItemList() async {
    Map result = await CartProductListParser.callApiForAddressCheckOut("${Config.strBaseURL}shopping_cart_items/getcartitemsbycustomerId?customerId=$customerId");
    if (result["errorCode"] == "0") {
      cartItemList = result["value"];
    } else {
      String error = result["msg"];
      print(error);
      isErrorInCartItem = true;
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  Future navigatePush(Widget page) async {
    var result = await Navigator.push(context, AnimationPageRoute(page: page, context: context));
    return result;
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }
}
