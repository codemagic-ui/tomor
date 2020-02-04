import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/AddressModel/AddressModel.dart';
import 'package:i_am_a_student/models/AddressModel/CustomAddressAttributeModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NewAddressScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/CustomerAddressListParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAddress extends StatefulWidget {
  final bool isFromCheckOutAddressScreen;
  final AddressModel model;

  MyAddress({this.isFromCheckOutAddressScreen, this.model});

  @override
  _MyAddressState createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  bool isInternet;
  bool isError = false;
  bool isLoading;

  List<AddressModel> addressList = new List<AddressModel>();

  int customerId;

  int currentAddressModelId;

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
              "Account.CustomerAddresses", resourceData)),
          actions: <Widget>[
            widget.isFromCheckOutAddressScreen != null &&
                    widget.isFromCheckOutAddressScreen &&
                    addressList.length != 0
                ? IconButton(
                    onPressed: () {
                      onClickAddNewAddress();
                    },
                    icon: Icon(Icons.add),
                  )
                : Container(),
          ],
        ),
        body: isLoading != null && isLoading
            ? Center(
                child: SpinKitThreeBounce(
                  color: AppColor.appColor,
                  size: 30.0,
                ),
              )
            : addressList.length > 0
                ? new ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: 50.0, top: 10.0, right: 10.0, left: 10.0),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: addressList.length,
                    itemBuilder: (BuildContext buildContext, int position) {
                      AddressModel model = addressList[position];
                      return addressCard(model, position);
                    })
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person_pin_circle,
                          size: 80.0,
                          color: AppColor.appColor,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        HeadlineText(
                          text: Constants.getValueFromKey(
                              "Account.CustomerAddresses.NoAddresses",
                              resourceData),
                          color: AppColor.appColor,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        RaisedBtn(
                            onPressed: () {
                              onClickAddNewAddress();
                            },
                            text: Constants.getValueFromKey(
                                    "Admin.Customers.Customers.Addresses.AddButton",
                                    resourceData)
                                .toUpperCase())
                      ],
                    ),
                  ),
        bottomNavigationBar: bottomLayout(),
      ),
    );
  }

  Widget addressCard(AddressModel model, int position) {
    if (isShowRadioButton()) {
      return Card(
        child: addressCardItem(model),
      );
    }
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          addressCardItem(model),
          new Container(color: Colors.grey, height: 1.0),
          new Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    navigatePush(NewAddressScreen(
                        model: model,
                        isUpdate: true,
                        appBar: Constants.getValueFromKey(
                            "admin.customers.customers.addresses.editaddress",
                            resourceData)));
                  },
                  child: Container(
                      height: 40.0,
                      child: Center(
                          child: new Body2Text(
                        text: Constants.getValueFromKey(
                            "Common.Edit", resourceData),
                        color: AppColor.appColor,
                      ))),
                ),
              ),
              Container(
                color: Colors.grey,
                height: 40.0,
                width: 1.0,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _showDialog(model.id, customerId, position);
                  },
                  child: Container(
                      height: 40.0,
                      child: Center(
                          child: new Body2Text(
                        text: Constants.getValueFromKey(
                            "Common.FileUploader.RemoveDownload", resourceData),
                        color: AppColor.appColor,
                      ))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  addressCardItem(AddressModel model) {
    return Row(
      children: <Widget>[
        isShowRadioButton() ? radioButton(model) : Container(),
        Expanded(
            child: InkWell(
          onTap: () {
            onSelectedRadio(model.id);
          },
          child: new Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
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
        ))
      ],
    );
  }

  radioButton(AddressModel model) {
    if (currentAddressModelId == null) {
      if (widget.model != null) {
        currentAddressModelId = widget.model.id;
      } else {
        currentAddressModelId = addressList[0].id;
      }
    }
    return new Radio(
      value: model.id,
      groupValue: currentAddressModelId,
      onChanged: !isDisableRadio()
          ? (value) {
              onSelectedRadio(value);
            }
          : null,
    );
  }

  onSelectedRadio(var value) {
    setState(() {
      currentAddressModelId = value;
    });
  }

  bottomLayout() {
    if (addressList.length != 0) {
      if (widget.isFromCheckOutAddressScreen != null &&
          widget.isFromCheckOutAddressScreen) {
        return Container(
          padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          width: MediaQuery.of(context).size.width,
          child: RaisedBtn(
            onPressed: () {
              onSave();
            },
            text: Constants.getValueFromKey("Common.Save", resourceData)
                .toUpperCase(),
          ),
        );
      } else {
        return Container(
          padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          width: MediaQuery.of(context).size.width,
          child: RaisedBtn(
            onPressed: () {
              navigatePush(NewAddressScreen());
            },
            text: Constants.getValueFromKey(
                    "Admin.Customers.Customers.Addresses.AddButton",
                    resourceData)
                .toUpperCase(),
          ),
        );
      }
    }
    return null;
  }

  //region address attributes
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
        text: Constants.getValueFromKey("Address.Fields.Email", resourceData) +
            ": ${model.email}",
      );
    }
    return Container();
  }

  Widget phone(AddressModel model) {
    if (model.phoneNumber != null && model.phoneNumber.isNotEmpty) {
      return new Body1Text(
        text: Constants.getValueFromKey(
                "Address.Fields.PhoneNumber", resourceData) +
            ": ${model.phoneNumber}",
      );
    }
    return Container();
  }

  Widget faxNumber(AddressModel model) {
    if (model.faxNumber != null && model.faxNumber.isNotEmpty) {
      return new Body1Text(
        text: Constants.getValueFromKey(
                "Admin.Address.Fields.FaxNumber", resourceData) +
            ": ${model.faxNumber}",
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
        text = "${model.city} ";
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

  bool isShowRadioButton() {
    if (widget.isFromCheckOutAddressScreen != null &&
        widget.isFromCheckOutAddressScreen) {
      if (widget.model != null) {
        return true;
      }
    }

    return false;
  }

  bool isDisableRadio() {
    if (addressList.length > 1) {
      return false;
    }
    return true;
  }

  void onClickAddNewAddress() {
    navigatePush(NewAddressScreen(
        isUpdate: false,
        appBar: Constants.getValueFromKey(
            "admin.customers.customers.addresses.addbutton", resourceData)));
  }

  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  void onSave() {
    for (int i = 0; i < addressList.length; i++) {
      if (addressList[i].id == currentAddressModelId) {
        Navigator.of(context).pop([addressList[i]]);
      }
    }
  }

  void _showDialog(int id, int customerId, int position) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return AlertDialog(
          title: new Text(
              Constants.getValueFromKey("ShoppingCart.Remove", resourceData) +
                  " !"),
          content: new Text(Constants.getValueFromKey(
              "nop.myaccountScreen.myaddress.removesubtitleforaddress",
              resourceData)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                  Constants.getValueFromKey("Common.Yes", resourceData)),
              onPressed: () {
                Constants.progressDialog(
                    true,
                    context,
                    Constants.getValueFromKey(
                        "nop.ProgressDilog.title", resourceData));
                removeAddress(id, customerId, position);
              },
            ), // usually buttons at the bot
            SizedBox(
              width: 10.0,
            ),
            new FlatButton(
              child: new Text(
                  Constants.getValueFromKey("Common.No", resourceData)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future removeAddress(int addressId, int customerId, int position) async {
    Map result = await CustomerAddressListParser.callApiForDeleteAddress(
        "${Config.strBaseURL}customers/deletecustomeraddress?addressId=" +
            addressId.toString() +
            "&customerId=" +
            customerId.toString());

    if (result["errorCode"] == "0") {
      try {
        setState(() {
          addressList.removeAt(position);
          Constants.progressDialog(
              false,
              context,
              Constants.getValueFromKey(
                  "nop.ProgressDilog.title", resourceData));
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: 'Address Removed Succsessfully',
              toastLength: Toast.LENGTH_SHORT);
        });
      } catch (e) {
        print(e);
      }
    } else {
      Constants.progressDialog(false, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
      Fluttertoast.showToast(
          msg: 'Address Not Removed', toastLength: Toast.LENGTH_SHORT);
      isError = true;
    }
  }

  callApi() async {
    await getPreferences();
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      await getCustomerAddressList();
      isLoading = false;
      setState(() {});
    }
  }

  Future getCustomerAddressList() async {
    Map result = await CustomerAddressListParser.callApi(
        "${Config.strBaseURL}customers/customersaddresses?customerId=$customerId");
    if (result["errorCode"] == "0") {
      addressList = result["value"];
    } else {
      isError = true;
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  navigatePush(Widget page) async {
    final result = await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));

    if (result != null) {
      if (result[0] == "succsess") {
        setState(() {
          isLoading = true;
        });
      }
    }
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }
}
