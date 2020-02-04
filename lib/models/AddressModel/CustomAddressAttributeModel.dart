import 'package:flutter/material.dart';
import 'package:i_am_a_student/models/AddressModel/Attributes/DropDownAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/CheckBoxAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/RadioButtonAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/TextFormFieldAttributeModel.dart';
import 'package:i_am_a_student/models/productDetail/AttributeValueModel.dart';

class CustomAddressAttributeModel {
  int attributeId;
  String attributeName;
  String defaultValue;
  bool isRequired = false;
  int attributeControlType;
  List<AttributeValueModel> values = new List<AttributeValueModel>();

  AttributeValueModel currentValue;

  DropDownAttributeModel dropDownAttribute;

  RadioButtonAttributeModel radioButtonAttributeModel;

  CheckBoxAttributeModel checkBoxAttributeModel;

  TextFormFieldAttributeModel textFormFieldAttributeModel;

  TextEditingController textEditingController = new TextEditingController();

  String error;

  CustomAddressAttributeModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Id", map)) {
      attributeId = map["Id"];
    }
    if (checkForNull("Name", map)) {
      attributeName = map["Name"];
    }
    if (checkForNull("DefaultValue", map)) {
      defaultValue = map["DefaultValue"];
    }
    if (checkForNull("AttributeControlType", map)) {
      attributeControlType = map["AttributeControlType"];
    }
    if (checkForNull("IsRequired", map)) {
      isRequired = map["IsRequired"];
    }
    if (checkForNull("Values", map)) {
      List list = map["Values"];
      values = list
          .map((c) => new AttributeValueModel.fromMapForAddress(c))
          .toList();
    }

    dropDownAttribute = new DropDownAttributeModel(values: values);
    radioButtonAttributeModel = new RadioButtonAttributeModel(values: values);
    checkBoxAttributeModel = new CheckBoxAttributeModel(values: values);
    textFormFieldAttributeModel = new TextFormFieldAttributeModel(hint: attributeName);
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
