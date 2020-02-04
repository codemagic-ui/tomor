import 'dart:convert';

import 'package:i_am_a_student/models/AddressModel/CountryDropDownModel.dart';
import 'package:i_am_a_student/models/AddressModel/CountryModel.dart';
import 'package:i_am_a_student/models/AddressModel/StateDropDownModel.dart';
import 'package:i_am_a_student/models/AddressModel/StateModel.dart';
import 'package:i_am_a_student/models/AddressModel/CustomAddressAttributeModel.dart';

class AddressModel {
  int id;
  String firstName;
  String lastName;
  String email;
  String company;
  String countryName;
  String stateProvinceName;
  String city;
  String addressLine1;
  String addressLine2;
  String zipPostalCode;
  String phoneNumber;
  var countryId;
  var stateId;

  String faxNumber;
  bool isCompanyEnable = false;
  bool isCountryEnabled = false;
  bool isStateProvinceEnabled = false;
  bool isCityEnabled = false;
  bool isAddressLineEnabled = false;
  bool isAddressLine2Enabled = false;
  bool isZipPostalCodeEnabled = false;
  bool isPhoneEnabled = false;

  bool isFaxEnabled = false;
  bool isCompanyRequired = false;
  bool isCityRequired = false;
  bool isAddressLineRequired = false;
  bool isAddressLine2Required = false;
  bool isZipPostalCodeRequired = false;
  bool isPhoneRequired = false;

  bool isFaxRequired = false;
  List<CountryModel> countryModelList = new List<CountryModel>();

  List<StateModel> stateModelList = new List<StateModel>();
  CountryDropDownModel countryDropDownModel;

  StateDropDownModel stateDropDownModel;

  List<CustomAddressAttributeModel> customAddressAttributeModelList =
      new List<CustomAddressAttributeModel>();

  AddressModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Id", map)) {
      id = map["Id"];
    }
    if (checkForNull("FirstName", map)) {
      firstName = map["FirstName"];
    }
    if (checkForNull("LastName", map)) {
      lastName = map["LastName"];
    }

    if (checkForNull("Email", map)) {
      email = map["Email"];
    }

    if (checkForNull("Company", map)) {
      company = map["Company"];
    }

    if (checkForNull("CountryName", map)) {
      countryName = map["CountryName"];
    }

    if (checkForNull("CountryId", map)) {
      countryId = map["CountryId"];
    }

    if (checkForNull("StateProvinceId", map)) {
      stateId = map["StateProvinceId"];
    }

    if (checkForNull("StateProvinceName", map)) {
      stateProvinceName = map["StateProvinceName"];
    }

    if (checkForNull("City", map)) {
      city = map["City"];
    }

    if (checkForNull("Address1", map)) {
      addressLine1 = map["Address1"];
    }

    if (checkForNull("Address2", map)) {
      addressLine2 = map["Address2"];
    }

    if (checkForNull("ZipPostalCode", map)) {
      zipPostalCode = map["ZipPostalCode"];
    }

    if (checkForNull("PhoneNumber", map)) {
      phoneNumber = map["PhoneNumber"];
    }

    if (checkForNull("FaxNumber", map)) {
      faxNumber = map["FaxNumber"];
    }

    if (checkForNull("CompanyEnabled", map)) {
      isCompanyEnable = map["CompanyEnabled"];
    }

    if (checkForNull("CountryEnabled", map)) {
      isCountryEnabled = map["CountryEnabled"];
    }

    if (checkForNull("StateProvinceEnabled", map)) {
      isStateProvinceEnabled = map["StateProvinceEnabled"];
    }

    if (checkForNull("CityEnabled", map)) {
      isCityEnabled = map["CityEnabled"];
    }

    if (checkForNull("StreetAddressEnabled", map)) {
      isAddressLineEnabled = map["StreetAddressEnabled"];
    }

    if (checkForNull("StreetAddress2Enabled", map)) {
      isAddressLine2Enabled = map["StreetAddress2Enabled"];
    }

    if (checkForNull("ZipPostalCodeEnabled", map)) {
      isZipPostalCodeEnabled = map["ZipPostalCodeEnabled"];
    }

    if (checkForNull("PhoneEnabled", map)) {
      isPhoneEnabled = map["PhoneEnabled"];
    }

    if (checkForNull("FaxEnabled", map)) {
      isFaxEnabled = map["FaxEnabled"];
    }

    if (checkForNull("CustomAddressAttributes", map)) {
      List list = map["CustomAddressAttributes"];
      customAddressAttributeModelList =
          list.map((c) => new CustomAddressAttributeModel.fromMap(c)).toList();
    }

    if (checkForNull("AvailableCountries", map)) {
      List countryList = map["AvailableCountries"];
      countryModelList =
          countryList.map((c) => new CountryModel.fromMap(c)).toList();
    }

    if (checkForNull("AvailableStates", map)) {
      List stateList = map["AvailableStates"];
      stateModelList = stateList.map((c) => new StateModel.fromMap(c)).toList();
    }

    if (checkForNull("CustomAddressAttributes", map)) {
      List list1 = map["CustomAddressAttributes"];
      customAddressAttributeModelList =
          list1.map((c) => new CustomAddressAttributeModel.fromMap(c)).toList();
    }

    countryDropDownModel = new CountryDropDownModel(values: countryModelList);
    stateDropDownModel = new StateDropDownModel(values: stateModelList);
  }

  AddressModel.fromMapForAddOrEditAddress(Map<String, dynamic> map) {
    if (checkForNull("Id", map)) {
      id = map["Id"];
    }

    if (checkForNull("FirstName", map)) {
      firstName = map["FirstName"];
    }

    if (checkForNull("LastName", map)) {
      lastName = map["LastName"];
    }

    if (checkForNull("Email", map)) {
      email = map["Email"];
    }

    if (checkForNull("Company", map)) {
      company = map["Company"];
    }

    if (checkForNull("CountryName", map)) {
      countryName = map["CountryName"];
    }

    if (checkForNull("StateProvinceName", map)) {
      stateProvinceName = map["StateProvinceName"];
    }

    if (checkForNull("City", map)) {
      city = map["City"];
    }

    if (checkForNull("Address1", map)) {
      addressLine1 = map["Address1"];
    }

    if (checkForNull("Address2", map)) {
      addressLine2 = map["Address2"];
    }

    if (checkForNull("ZipPostalCode", map)) {
      zipPostalCode = map["ZipPostalCode"];
    }

    if (checkForNull("PhoneNumber", map)) {
      phoneNumber = map["PhoneNumber"];
    }

    if (checkForNull("FaxNumber", map)) {
      faxNumber = map["FaxNumber"];
    }

    if (checkForNull("CountryId", map)) {
      countryId = map["CountryId"];
    }

    if (checkForNull("StateProvinceId", map)) {
      stateId = map["StateProvinceId"];
    }

    if (checkForNull("CompanyEnabled", map)) {
      isCompanyEnable = map["CompanyEnabled"];
    }
    if (checkForNull("CountryEnabled", map)) {
      isCountryEnabled = map["CountryEnabled"];
    }
    if (checkForNull("StateProvinceEnabled", map)) {
      isStateProvinceEnabled = map["StateProvinceEnabled"];
    }
    if (checkForNull("CityEnabled", map)) {
      isCityEnabled = map["CityEnabled"];
    }
    if (checkForNull("StreetAddressEnabled", map)) {
      isAddressLineEnabled = map["StreetAddressEnabled"];
    }
    if (checkForNull("StreetAddress2Enabled", map)) {
      isAddressLine2Enabled = map["StreetAddress2Enabled"];
    }
    if (checkForNull("ZipPostalCodeEnabled", map)) {
      isZipPostalCodeEnabled = map["ZipPostalCodeEnabled"];
    }
    if (checkForNull("PhoneEnabled", map)) {
      isPhoneEnabled = map["PhoneEnabled"];
    }
    if (checkForNull("FaxEnabled", map)) {
      isFaxEnabled = map["FaxEnabled"];
    }

    if (checkForNull("CompanyRequired", map)) {
      isCompanyRequired = map["CompanyRequired"];
    }
    if (checkForNull("CityRequired", map)) {
      isCityRequired = map["CityRequired"];
    }
    if (checkForNull("StreetAddressRequired", map)) {
      isAddressLineRequired = map["StreetAddressRequired"];
    }
    if (checkForNull("StreetAddress2Required", map)) {
      isAddressLine2Required = map["StreetAddress2Required"];
    }
    if (checkForNull("ZipPostalCodeRequired", map)) {
      isZipPostalCodeRequired = map["ZipPostalCodeRequired"];
    }
    if (checkForNull("PhoneRequired", map)) {
      isPhoneRequired = map["PhoneRequired"];
    }
    if (checkForNull("FaxRequired", map)) {
      isFaxRequired = map["FaxRequired"];
    }

    if (checkForNull("AvailableCountries", map)) {
      List countryList = map["AvailableCountries"];
      countryModelList =
          countryList.map((c) => new CountryModel.fromMap(c)).toList();
    }

    if (checkForNull("AvailableStates", map)) {
      List stateList = map["AvailableStates"];
      stateModelList = stateList.map((c) => new StateModel.fromMap(c)).toList();
    }

    if (checkForNull("CustomAddressAttributes", map)) {
      List list = map["CustomAddressAttributes"];
      customAddressAttributeModelList =
          list.map((c) => new CustomAddressAttributeModel.fromMap(c)).toList();
    }

    countryDropDownModel = new CountryDropDownModel(values: countryModelList);
    stateDropDownModel = new StateDropDownModel(values: stateModelList);
  }

  AddressModel.fromMapForConfirmOrder(Map<String, dynamic> map) {
    if (checkForNull("Name", map)) {
      firstName = map["Name"];
    }
    if (checkForNull("", map)) {
      lastName = "";
    }
    if (checkForNull("Email", map)) {
      email = map["Email"];
    }
    if (checkForNull("Company", map)) {
      company = map["Company"];
    }
    if (checkForNull("country", map)) {
      countryName = map["country"];
    }
    if (checkForNull("state", map)) {
      stateProvinceName = map["state"];
    }
    if (checkForNull("city", map)) {
      city = map["city"];
    }
    if (checkForNull("Address1", map)) {
      addressLine1 = map["Address1"];
    }
    if (checkForNull("Address2", map)) {
      addressLine2 = map["Address2"];
    }
    if (checkForNull("pincode", map)) {
      zipPostalCode = map["pincode"];
    }
    if (checkForNull("Phone", map)) {
      phoneNumber = map["Phone"];
    }
    if (checkForNull("FAX", map)) {
      faxNumber = map["FAX"];
    }

  }

  static String addNewAddress(AddressModel addressModel, String attributeString) {
    Map<String, dynamic> map = {
      "AddressId": addressModel.id.toString(),
      "FirstName": addressModel.firstName.toString(),
      "LastName": addressModel.lastName.toString(),
      "Email": addressModel.email.toString(),
      "Company": addressModel.company.toString(),
      "CountryId": addressModel.countryDropDownModel != null
          ? addressModel.countryDropDownModel.currentValue != null
              ? addressModel.countryDropDownModel.currentValue.strValue
                  .toString()
              : ""
          : "",
      "StateProvinceId": addressModel.stateDropDownModel != null
          ? addressModel.stateDropDownModel.currentValue != null
              ? addressModel.stateDropDownModel.currentValue.strValue.toString()
              : ""
          : "",
      "City": addressModel.city.toString(),
      "Address1": addressModel.addressLine1.toString(),
      "Address2": addressModel.addressLine2.toString(),
      "ZipPostalCode": addressModel.zipPostalCode.toString(),
      "PhoneNumber": addressModel.phoneNumber.toString(),
      "customattrributeList": attributeString,
      "FaxNumber": addressModel.faxNumber.toString(),
    };
    return json.encode(map);
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
