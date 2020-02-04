import 'package:flutter/material.dart';

class AdvancedSearchAttributeModel {
  List<Value> availableVendorList = new List<Value>();
  List<Value> availableManufactureList = new List<Value>();
  List<Value> availableCategoryList = new List<Value>();

  List<DropdownMenuItem<Value>> dropDownItemsVendor = [];
  Value vendorCurrentValue;

  List<DropdownMenuItem<Value>> dropDownItemsManufacture = [];
  Value manufactureCurrentValue;

  List<DropdownMenuItem<Value>> dropDownItemsCategory = [];
  Value categoryCurrentValue;

  AdvancedSearchAttributeModel.fromMap(Map<String, dynamic> map) {

    if (checkForNull("AvailableCategories", map)) {
      List availableCategories = map["AvailableCategories"];
      availableCategoryList =
          availableCategories.map((c) => new Value.fromMap(c)).toList();
    }

    if (checkForNull("AvailableManufacturers", map)) {
      List availableManufacturers = map["AvailableManufacturers"];
      availableManufactureList =
          availableManufacturers.map((c) => new Value.fromMap(c)).toList();
    }
    if (checkForNull("AvailableVendors", map)) {
      List availableVendors = map["AvailableVendors"];
      availableVendorList =
          availableVendors.map((c) => new Value.fromMap(c)).toList();
    }
    if (checkForNull("AvailableVendors", map)) {
      List availableVendors = map["AvailableVendors"];
      availableVendorList =
          availableVendors.map((c) => new Value.fromMap(c)).toList();
    }

    generateDropDownListForCategories(availableCategoryList);
    generateDropDownListForManufacturers(availableManufactureList);
    generateDropDownListForVendor(availableVendorList);
  }

  generateDropDownListForVendor(List<Value> values) {
    for (int i = 0; i < values.length; i++) {
      if (values[i].isSelected) {
        vendorCurrentValue = values[i];
      }
      dropDownItemsVendor.add(new DropdownMenuItem(
        child: Text(values[i].strText),
        value: values[i],
      ));
    }
  }

  generateDropDownListForManufacturers(List<Value> values) {
    for (int i = 0; i < values.length; i++) {
      if (values[i].isSelected) {
        manufactureCurrentValue = values[i];
      }
      dropDownItemsManufacture.add(new DropdownMenuItem(
        child: Text(values[i].strText),
        value: values[i],
      ));
    }
  }

  generateDropDownListForCategories(List<Value> values) {
    for (int i = 0; i < values.length; i++) {
      if (values[i].isSelected) {
        categoryCurrentValue = values[i];
      }
      dropDownItemsCategory.add(new DropdownMenuItem(
        child: Text(values[i].strText),
        value: values[i],
      ));
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}

class Value {
  bool isDisabled;
  bool isSelected;
  String strText;
  var value;
  var group;

  Value.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Disabled", map)) {
      isDisabled = map['Disabled'];
    }

    if (checkForNull("Selected", map)) {
      isSelected = map['Selected'];
    }

    if (checkForNull("Text", map)) {
      strText = map['Text'];
    }

    if (checkForNull("Group", map)) {
      group = map['Group'];
    }

    if (checkForNull("Value", map)) {
      value = map['Value'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
