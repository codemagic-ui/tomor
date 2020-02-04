import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/AddressModel/AddressModel.dart';
import 'package:i_am_a_student/models/AddressModel/Attributes/DropDownAttributeModel.dart';
import 'package:i_am_a_student/models/AddressModel/CountryDropDownModel.dart';
import 'package:i_am_a_student/models/AddressModel/CountryModel.dart';
import 'package:i_am_a_student/models/AddressModel/CustomAddressAttributeModel.dart';
import 'package:i_am_a_student/models/AddressModel/StateDropDownModel.dart';
import 'package:i_am_a_student/models/AddressModel/StateModel.dart';
import 'package:i_am_a_student/models/attributes/CheckBoxAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/RadioButtonAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/TextFormFieldAttributeModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/LoadingScreen.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/parser/CustomerAddressListParser.dart';
import 'package:i_am_a_student/parser/GetAddressAttributeParser.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewAddressScreen extends StatefulWidget {
  final AddressModel model;
  final bool isUpdate;
  final String appBar;

  NewAddressScreen({this.model, this.isUpdate, this.appBar});

  @override
  _NewAddressScreenState createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  bool isInternet;
  bool isLoading;
  bool isError = false;

  AddressModel model;

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController addressLineController = new TextEditingController();
  TextEditingController addressLine2Controller = new TextEditingController();
  TextEditingController postalCodeController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController faxController = new TextEditingController();

  FocusNode firstFocusNode = new FocusNode();
  FocusNode secondFocusNode = new FocusNode();
  FocusNode thirdFocusNode = new FocusNode();
  FocusNode forthFocusNode = new FocusNode();
  FocusNode fifthFocusNode = new FocusNode();
  FocusNode sixthFocusNode = new FocusNode();
  FocusNode seventhFocusNode = new FocusNode();
  FocusNode eighthFocusNode = new FocusNode();
  FocusNode ninthFocusNode = new FocusNode();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Map resourceData;
  SharedPreferences prefs;
  int customerId;

  @override
  void initState() {
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  Future getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
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
          return layout();
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

  Widget layout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isUpdate != null && widget.isUpdate == true
              ? Constants.getValueFromKey(
                  "admin.customers.customers.addresses.editaddress",
                  resourceData)
              : Constants.getValueFromKey(
                  "admin.customers.customers.addresses.addbutton",
                  resourceData),
          style: TextStyle(color: AppColor.black),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          widget.isUpdate != null && widget.isUpdate == true
              ? formEditWidget()
              : formWidget(),
          SizedBox(
            height: 15.0,
          ),
          RaisedBtn(
              onPressed: () {
                widget.isUpdate != null && widget.isUpdate == true
                    ? onClickSaveBtn(widget.model)
                    : onClickSaveBtn(model);
              },
              text: Constants.getValueFromKey("common.save", resourceData)
                  .toUpperCase())
        ],
      ),
    );
  }

  Widget formWidget() {
    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            firstName(model),
            lastName(model),
            email(model),
            company(model),
            countryDropDown(model),
            stateDropDown(model),
            city(model),
            addressLine1(model),
            addressLine2(model),
            pinCode(model),
            phoneNumber(model),
            faxNumber(model),
          ],
        ),
      ),
    );
  }

  Widget formEditWidget() {
    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            firstName(widget.model),
            lastName(widget.model),
            email(widget.model),
            company(widget.model),
            countryDropDown(widget.model),
            stateDropDown(widget.model),
            city(widget.model),
            addressLine1(widget.model),
            addressLine2(widget.model),
            pinCode(widget.model),
            phoneNumber(widget.model),
            faxNumber(widget.model),
          ],
        ),
      ),
    );
  }

  Widget firstName(AddressModel model) {
    if (firstNameController.text == null || firstNameController.text.isEmpty) {
      if (model.firstName != null && model.firstName.isNotEmpty) {
        firstNameController.text = model.firstName;
      }
    }

    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Customers.Customers.Fields.FirstName", resourceData),
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
          requiredTitle,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: firstNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Customers.Customers.Fields.FirstName", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return Constants.getValueFromKey(
                    "Account.Fields.FirstName.Required", resourceData);
              }
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(firstFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget lastName(AddressModel model) {
    if (lastNameController.text == null || lastNameController.text.isEmpty) {
      if (model.lastName != null && model.lastName.isNotEmpty) {
        lastNameController.text = model.lastName;
      }
    }

    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Customers.Customers.Fields.LastName", resourceData),
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
          SizedBox(height: 20.0),
          requiredTitle,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            focusNode: firstFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: lastNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Customers.Customers.Fields.LastName", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "${Constants.getValueFromKey("Account.Fields.LastName.Required", resourceData)}";
              }
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(secondFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget email(AddressModel model) {
    if (emailController.text == null || emailController.text.isEmpty) {
      if (model.email != null && model.email.isNotEmpty) {
        emailController.text = model.email;
      }
    }
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Customers.Customers.List.SearchEmail", resourceData),
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
          SizedBox(height: 20.0),
          requiredTitle,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: secondFocusNode,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Customers.Customers.List.SearchEmail", resourceData),
            ),
            validator: (value) {
              return Validator.validateFormField(
                  value,
                  Constants.getValueFromKey(
                      "Account.Login.Fields.Email.Required", resourceData),
                  Constants.getValueFromKey(
                      "Admin.Common.WrongEmail", resourceData),
                  Constants.EMAIL_VALIDATION);
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(thirdFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget company(AddressModel model) {
    if (model.isCompanyEnable != null && !model.isCompanyEnable) {
      return Container();
    }
    if (companyController.text == null || companyController.text.isEmpty) {
      if (model.company != null && model.company.isNotEmpty) {
        companyController.text = model.company;
      }
    }
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Address.Fields.Company", resourceData),
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

    Widget title = SubTitleText(
      text: Constants.getValueFromKey(
          "Admin.Address.Fields.Company", resourceData),
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          model.isCompanyRequired ? requiredTitle : title,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: thirdFocusNode,
            keyboardType: TextInputType.text,
            controller: companyController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Address.Fields.Company", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "${Constants.getValueFromKey("Admin.Customers.Customers.Fields.Company.Required", resourceData)}";
              }
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(forthFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget countryDropDown(AddressModel model) {
    if (model.isCountryEnabled != null && !model.isCountryEnabled) {
      return Container();
    }
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Address.Fields.Country", resourceData),
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
        SizedBox(height: 15.0),
        requiredTitle,
        SizedBox(
          height: 5.0,
        ),
        new DropdownButton(
          isExpanded: true,
          hint: Text(
              Constants.getValueFromKey("Address.SelectCountry", resourceData)),
          value: model.countryDropDownModel.currentValue,
          items: model.countryDropDownModel.dropDownItems,
          onChanged: (value) async {
            Constants.progressDialog(
                true,
                context,
                Constants.getValueFromKey(
                    "nop.ProgressDilog.title", resourceData));
            CountryModel countryModel = value;
            await callApiForGetStates(countryModel.strValue.toString());
            setState(() {
              model.countryDropDownModel.currentValue = countryModel;
            });
            Constants.progressDialog(
                false,
                context,
                Constants.getValueFromKey(
                    "nop.ProgressDilog.title", resourceData));
          },
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget stateDropDown(AddressModel model) {
    if (model.isStateProvinceEnabled != null && !model.isStateProvinceEnabled) {
      return Container();
    }

    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Address.Fields.StateProvince", resourceData),
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
        requiredTitle,
        SizedBox(
          height: 5.0,
        ),
        new DropdownButton(
          isExpanded: true,
          hint: Text(
              Constants.getValueFromKey("Address.SelectState", resourceData)),
          value: model.stateDropDownModel.currentValue,
          items: model.stateDropDownModel.dropDownItems,
          onChanged: (value) {
            setState(() {
              model.stateDropDownModel.currentValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget city(AddressModel model) {
    if (model.isCityEnabled != null && !model.isCityEnabled) {
      return Container();
    }
    if (cityController.text == null || cityController.text.isEmpty) {
      if (model.city != null && model.city.isNotEmpty) {
        cityController.text = model.city;
      }
    }
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Address.Fields.City", resourceData),
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
    Widget title = SubTitleText(
      text:
          Constants.getValueFromKey("Admin.Address.Fields.City", resourceData),
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          model.isCityRequired ? requiredTitle : title,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: forthFocusNode,
            keyboardType: TextInputType.text,
            controller: cityController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Address.Fields.City", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "${Constants.getValueFromKey("Address.Fields.City.Required", resourceData)}";
              }
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(fifthFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget addressLine1(AddressModel model) {
    if (model.isAddressLineEnabled != null && !model.isAddressLineEnabled) {
      return Container();
    }
    if (addressLineController.text == null ||
        addressLineController.text.isEmpty) {
      if (model.addressLine1 != null && model.addressLine1.isNotEmpty) {
        addressLineController.text = model.addressLine1;
      }
    }
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Orders.Address.Address1", resourceData),
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
    Widget title = SubTitleText(
      text: Constants.getValueFromKey(
          "Admin.Orders.Address.Address1", resourceData),
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          model.isAddressLineRequired ? requiredTitle : title,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: fifthFocusNode,
            keyboardType: TextInputType.text,
            controller: addressLineController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Orders.Address.Address1", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "${Constants.getValueFromKey("Admin.Customers.Customers.Fields.StreetAddress.Required", resourceData)}";
              }
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(sixthFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget addressLine2(AddressModel model) {
    if (model.isAddressLine2Enabled != null && !model.isAddressLine2Enabled) {
      return Container();
    }
    if (addressLine2Controller.text == null ||
        addressLine2Controller.text.isEmpty) {
      if (model.addressLine2 != null && model.addressLine2.isNotEmpty) {
        addressLine2Controller.text = model.addressLine2;
      }
    }
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Orders.Address.Address2", resourceData),
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
    Widget title = SubTitleText(
      text: Constants.getValueFromKey(
          "Admin.Orders.Address.Address2", resourceData),
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          model.isAddressLine2Required ? requiredTitle : title,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: sixthFocusNode,
            keyboardType: TextInputType.text,
            controller: addressLine2Controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Orders.Address.Address2", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "${Constants.getValueFromKey("Admin.Customers.Customers.Fields.StreetAddress2.Required", resourceData)}";
              }
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(seventhFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget pinCode(AddressModel model) {
    if (model.isZipPostalCodeEnabled != null && !model.isZipPostalCodeEnabled) {
      return Container();
    }
    if (postalCodeController.text == null ||
        postalCodeController.text.isEmpty) {
      if (model.zipPostalCode != null && model.zipPostalCode.isNotEmpty) {
        postalCodeController.text = model.zipPostalCode;
      }
    }

    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Orders.Address.ZipPostalCode", resourceData),
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
    Widget title = SubTitleText(
      text: Constants.getValueFromKey(
          "Admin.Orders.Address.ZipPostalCode", resourceData),
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          model.isZipPostalCodeRequired ? requiredTitle : title,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: seventhFocusNode,
            keyboardType: TextInputType.number,
            controller: postalCodeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Orders.Address.ZipPostalCode", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "${Constants.getValueFromKey("Admin.Customers.Customers.Fields.ZipPostalCode.Required", resourceData)}";
              }
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(eighthFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget phoneNumber(AddressModel model) {
    if (model.isPhoneEnabled != null && !model.isPhoneEnabled) {
      return Container();
    }
    if (phoneController.text == null || phoneController.text.isEmpty) {
      if (model.phoneNumber != null && model.phoneNumber.isNotEmpty) {
        phoneController.text = model.phoneNumber;
      }
    }

    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Address.Fields.PhoneNumber", resourceData),
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
    Widget title = SubTitleText(
        text: Constants.getValueFromKey(
            "Admin.Address.Fields.PhoneNumber", resourceData));

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          model.isPhoneRequired ? requiredTitle : title,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: eighthFocusNode,
            keyboardType: TextInputType.phone,
            controller: phoneController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Address.Fields.PhoneNumber", resourceData),
            ),
            validator: (value) {
              return Validator.validateFormField(
                  value,
                  Constants.getValueFromKey(
                      "Account.Login.Fields.Phone.Required", resourceData),
                  Constants.getValueFromKey(
                      "Admin.Common.WrongPhone", resourceData),
                  Constants.PHONE_VALIDATION);
            },
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(ninthFocusNode);
            },
          ),
        ],
      ),
    );
  }

  Widget faxNumber(AddressModel model) {
    if (model.isFaxEnabled != null && !model.isFaxEnabled) {
      return Container();
    }
    if (faxController.text == null || faxController.text.isEmpty) {
      if (model.faxNumber != null && model.faxNumber.isNotEmpty) {
        faxController.text = model.faxNumber;
      }
    }
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: Constants.getValueFromKey(
              "Admin.Address.Fields.FaxNumber", resourceData),
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
    Widget title = SubTitleText(
        text: Constants.getValueFromKey(
            "Admin.Address.Fields.FaxNumber", resourceData));

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          model.isFaxRequired ? requiredTitle : title,
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            focusNode: ninthFocusNode,
            keyboardType: TextInputType.text,
            controller: faxController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: Constants.getValueFromKey(
                  "Admin.Address.Fields.FaxNumber", resourceData),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "${Constants.getValueFromKey("Admin.Customers.Customers.Fields.Fax.Required", resourceData)}";
              }
            },
          ),
        ],
      ),
    );
  }

  Widget customAttributes(AddressModel model) {
    if (model.customAddressAttributeModelList.length != 0) {
      return Column(
        children: List<Widget>.generate(
            model.customAddressAttributeModelList.length, (int index) {
          switch (model
              .customAddressAttributeModelList[index].attributeControlType) {
            case 1:
              return dropDownAttribute(
                  model.customAddressAttributeModelList[index]);
              break;
            case 2:
              return radioList(model.customAddressAttributeModelList[index]);
              break;
            case 3:
              return checkBoxList(model.customAddressAttributeModelList[index]);
              break;
            case 4:
              return textFormField(
                  model.customAddressAttributeModelList[index]);
              break;
            case 10:
              return multiTextFormField(
                  model.customAddressAttributeModelList[index]);
              break;
            case 50:
              return readOnlyCheckBoxList(
                  model.customAddressAttributeModelList[index]);
              break;
            default:
              return Container();
          }
        }),
      );
    }

    return Container();
  }

  Widget dropDownAttribute(
      CustomAddressAttributeModel customAddressAttributeModel) {
    DropDownAttributeModel model =
        customAddressAttributeModel.dropDownAttribute;

    Widget title = SubTitleText(
      text: customAddressAttributeModel.attributeName,
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0),
          title,
          SizedBox(
            height: 10.0,
          ),
          new DropdownButton(
            isExpanded: true,
            hint: Text("${customAddressAttributeModel.attributeName}"),
            value: model.currentValue,
            items: model.dropDownItems,
            onChanged: (value) {
              setState(() {
                model.currentValue = value;
              });
            },
          )
        ],
      ),
    );
  }

  Widget radioList(CustomAddressAttributeModel customAddressAttributeModel) {
    RadioButtonAttributeModel model =
        customAddressAttributeModel.radioButtonAttributeModel;

    Widget notRequiredTitle = SubTitleText(
      text: customAddressAttributeModel.attributeName,
    );
    Widget requiredTitle = new Row(
      children: <Widget>[
        SubTitleText(
          text: customAddressAttributeModel.attributeName,
        ),
        SizedBox(
          width: 5.0,
        ),
        SubTitleText(
          text: "*",
          color: Colors.red,
        ),
        Text("(Required)"),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        customAddressAttributeModel.attributeName != null &&
                customAddressAttributeModel.attributeName.toString().isNotEmpty
            ? customAddressAttributeModel.isRequired != null &&
                    customAddressAttributeModel.isRequired
                ? requiredTitle
                : notRequiredTitle
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
                    onChanged: (value) {
                      setState(() {
                        model.currentValue = value;
                      });
                    },
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          model.currentValue = model.values[index];
                        });
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
      ],
    );
  }

  Widget checkBoxList(CustomAddressAttributeModel attributeModel) {
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
        Text("(Required)"),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
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
                    onChanged: (value) {
                      setState(() {
                        model.values[index].isPreSelected = value;
                      });
                    },
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          model.values[index].isPreSelected =
                              !model.values[index].isPreSelected;
                        });
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
      ],
    );
  }

  Widget textFormField(CustomAddressAttributeModel attributeModel) {
    TextFormFieldAttributeModel model =
        attributeModel.textFormFieldAttributeModel;

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
        Text("(Required)"),
      ],
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          attributeModel.attributeName != null &&
                  attributeModel.attributeName.toString().isNotEmpty
              ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
              : Container(),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: model.hint,
            ),
            validator: (value) {
              if (attributeModel.isRequired && value.isEmpty) {
                return "${model.hint}";
              }
              return "";
            },
          ),
        ],
      ),
    );
  }

  Widget multiTextFormField(CustomAddressAttributeModel attributeModel) {
    TextFormFieldAttributeModel model =
        attributeModel.textFormFieldAttributeModel;

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
        Text("(Required)"),
      ],
    );

    return Theme(
      data: ThemeData(primaryColor: AppColor.appColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          attributeModel.attributeName != null &&
                  attributeModel.attributeName.toString().isNotEmpty
              ? attributeModel.isRequired ? requiredTitle : notRequiredTitle
              : Container(),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: model.hint,
            ),
            validator: (value) {
              if (attributeModel.isRequired && value.isEmpty) {
                return "${model.hint}";
              }
              return "";
            },
          ),
        ],
      ),
    );
  }

  Widget readOnlyCheckBoxList(CustomAddressAttributeModel attributeModel) {
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
        Text("(Required)"),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
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
      ],
    );
  }

  onClickSaveBtn(AddressModel model) async {
    if (formKey.currentState.validate()) {
      //todo set value in model

      Constants.progressDialog(true, context,
          Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));

      model.firstName = firstNameController.text;
      model.lastName = lastNameController.text;
      model.email = emailController.text;
      model.company = companyController.text;
      if (model.countryDropDownModel != null) {
        if (model.countryDropDownModel.currentValue != null) {
          model.countryName = model.countryDropDownModel.currentValue.strValue;
        }
      }

      if (model.stateDropDownModel != null) {
        if (model.stateDropDownModel.currentValue != null) {
          model.stateProvinceName =
              model.stateDropDownModel.currentValue.strValue.toString();
        }
      }

      model.city = cityController.text;
      model.addressLine1 = addressLineController.text;
      model.addressLine2 = addressLine2Controller.text;
      model.zipPostalCode = postalCodeController.text;
      model.phoneNumber = phoneController.text;
      model.faxNumber = faxController.text;

      String strJson = AddressModel.addNewAddress(model, "");

      Map result;
      if (widget.isUpdate != null && widget.isUpdate == true) {
        result = await CustomerAddressListParser.insertIntoEditAddress(
            "${Config.strBaseURL}customers/updatecustomeraddress?customerId=" +
                customerId.toString(),
            strJson);
      } else {
        result = await CustomerAddressListParser.insertIntoAddress(
            "${Config.strBaseURL}customers/createcustomeraddress?customerId=" +
                customerId.toString(),
            strJson);
      }
      if (result["errorCode"] == "0") {
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
        if (widget.isUpdate != null && widget.isUpdate == true) {
          Fluttertoast.showToast(
              msg: Constants.getValueFromKey(
                  "Admin.Customers.Customers.Addresses.Updated", resourceData),
              toastLength: Toast.LENGTH_SHORT);
        } else {
          Fluttertoast.showToast(
              msg: Constants.getValueFromKey(
                  "Admin.Customers.Customers.Addresses.Added", resourceData),
              toastLength: Toast.LENGTH_SHORT);
        }
        Navigator.of(context).pop(["succsess"]);
      } else {
        Constants.progressDialog(false, context,
            Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
        if (widget.isUpdate != null && widget.isUpdate == true) {
          Fluttertoast.showToast(
              msg: 'Address No Update', toastLength: Toast.LENGTH_SHORT);
        } else {
          Fluttertoast.showToast(
              msg: 'Address No Valid', toastLength: Toast.LENGTH_SHORT);
        }
      }
    }
  }

  Future callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    await getSharedPreferences();
    await getAddressModel();
    await getCountryListModel();
    if (widget.isUpdate != null && widget.isUpdate) {
      if (widget.model.countryId != null &&
          widget.model.countryId.toString().isNotEmpty) {
        await callApiForGetStates(widget.model.countryId);
      }
    }
    isLoading = false;
    setState(() {});
  }

  Future callApiForGetStates(countryId) async {
    Map result = await CustomerAddressListParser.callApiForGetStates(
        "${Config.strBaseURL}customers/getstatesbycountryid?countryId=" +
            countryId.toString());
    if (result["errorCode"] == "0") {
      List list = result["value"];
      model.stateModelList =
          list.map((c) => new StateModel.fromMapForStates(c)).toList();

      if (widget.isUpdate != null && widget.isUpdate == true) {
        widget.model.stateDropDownModel =
            new StateDropDownModel(values: model.stateModelList);
      } else {
        model.stateDropDownModel =
            new StateDropDownModel(values: model.stateModelList);
      }

      if (widget.model != null) {
        for (int i = 0; i < model.stateModelList.length; i++) {
          String name = widget.model.stateId.toString();
          String currentName = model.stateModelList[i].strValue.toString();
          if (name == currentName) {
            if (widget.isUpdate != null && widget.isUpdate == true) {
              widget.model.stateDropDownModel.currentValue =
                  model.stateModelList[i];
            } else {
              model.stateDropDownModel.currentValue = model.stateModelList[i];
            }
          }
        }
      }
    } else {
      isError = true;
    }
  }

  Future getCountryListModel() async {
    Map result = await CustomerAddressListParser.callApiForGetContry(
        "${Config.strBaseURL}customers/getcustomerattributeaddress");
    if (result["errorCode"] == "0") {
      List countryList = result["value"];
      model.countryModelList =
          countryList.map((c) => new CountryModel.fromMap(c)).toList();

      if (widget.isUpdate != null && widget.isUpdate == true) {
        widget.model.countryDropDownModel =
            new CountryDropDownModel(values: model.countryModelList);
      } else {
        model.countryDropDownModel =
            new CountryDropDownModel(values: model.countryModelList);
      }

      if (widget.model != null) {
        for (int i = 0; i < model.countryModelList.length; i++) {
          String name = widget.model.countryId.toString();
          String currentName = model.countryModelList[i].strValue.toString();
          if (name == currentName) {
            if (widget.isUpdate != null && widget.isUpdate == true) {
              widget.model.countryDropDownModel.currentValue =
                  model.countryModelList[i];
            } else {
              model.countryDropDownModel.currentValue =
                  model.countryModelList[i];
            }
          }
        }
      }
    } else {
      isError = true;
    }
  }

  Future getAddressModel() async {
    Map result = await GetAddressAttributeParser.callApi(
        "${Config.strBaseURL}customers/getcustomerattributeaddress");
    if (result["errorCode"] == "0") {
      model = result["value"];
    } else {
      isError = true;
    }
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  void addDataIntoModel() {}
}
