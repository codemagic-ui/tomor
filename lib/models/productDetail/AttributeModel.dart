import 'package:flutter/material.dart';
import 'package:i_am_a_student/models/attributes/CheckBoxAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/ColorSquareAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/DatePickerAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/FileChooserAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/ImageSquareAttribute.dart';
import 'package:i_am_a_student/models/attributes/RadioButtonAttributeModel.dart';
import 'package:i_am_a_student/models/productDetail/AttributeValueModel.dart';
import 'package:i_am_a_student/models/attributes/DropDownAttributeModel.dart';
import 'package:i_am_a_student/models/attributes/TextFormFieldAttributeModel.dart';

class AttributeModel{
  var attributeId;
  var mapId;
  var attributeValueFromUser;
  var attributeName;
  var isRequired;
  var attributeControlTypeId;
  var labelText;
  String error;

  List<AttributeValueModel> values = new List<AttributeValueModel>();

  AttributeValueModel currentValue;
  List<AttributeValueModel> currentValueList = new List<AttributeValueModel>();

  TextEditingController textEditingController = new TextEditingController();

  DropDownAttributeModel dropDownAttributeModel;
  RadioButtonAttributeModel radioButtonAttributeModel;
  CheckBoxAttributeModel checkBoxAttributeModel;
  TextFormFieldAttributeModel textFormFieldAttributeModel;
  ColorSquareAttributeModel colorSquareAttributeModel;
  ImageSquareAttribute imageSquareAttribute;
  DatePickerAttributeModel datePickerAttributeModel;
  FileChooserAttributeModel fileChooserAttributeModel;


  AttributeModel.fromMap(Map<String,dynamic> map){

    if(checkForNull("product_attribute_id",map)) {
      attributeId = map["product_attribute_id"];
    }
    if(checkForNull("id",map)) {
      mapId = map["id"];
    }
    if(checkForNull("product_attribute_name",map)) {
      attributeName = map["product_attribute_name"];
    }
    if(checkForNull("text_prompt",map)) {
      labelText = map["text_prompt"];
    }
    if(checkForNull("is_required",map)) {
      isRequired = map["is_required"];
    }
    if(checkForNull("attribute_control_type_id",map)) {
      attributeControlTypeId = map["attribute_control_type_id"];
    }
    if(checkForNull("attribute_values",map)) {
      List valueList = map["attribute_values"];
      values = valueList.map((c) => new AttributeValueModel.fromMap(c)).toList();
    }
    dropDownAttributeModel = new DropDownAttributeModel(values: values);
    radioButtonAttributeModel = new RadioButtonAttributeModel(values: values);
    checkBoxAttributeModel = new CheckBoxAttributeModel(values: values);
    textFormFieldAttributeModel = new TextFormFieldAttributeModel(hint: labelText);
    colorSquareAttributeModel = new ColorSquareAttributeModel(values: values);
    imageSquareAttribute = new ImageSquareAttribute(values: values);
    datePickerAttributeModel = new DatePickerAttributeModel(hint: labelText);
    fileChooserAttributeModel = new FileChooserAttributeModel(label: labelText);
  }

  AttributeModel.fromMpForCheckoutAttribute(Map<String,dynamic> map){
    if(checkForNull("Id",map)) {
      attributeId = map["Id"];
    }

    if(checkForNull("Name",map)) {
      attributeName = map["Name"];
    }
    if(checkForNull("TextPrompt",map)) {
      labelText = map["TextPrompt"];
    }
    if(checkForNull("IsRequired",map)) {
      isRequired = map["IsRequired"];
    }
    if(checkForNull("AttributeControlType",map)) {
      attributeControlTypeId = map["AttributeControlType"];
    }
    if(checkForNull("Values",map)) {
      List valueList = map["Values"];
      values = valueList.map((c) => new AttributeValueModel.fromMpForCheckoutAttribute(c)).toList();
    }
    dropDownAttributeModel = new DropDownAttributeModel(values: values);
    radioButtonAttributeModel = new RadioButtonAttributeModel(values: values);
    checkBoxAttributeModel = new CheckBoxAttributeModel(values: values);
    textFormFieldAttributeModel = new TextFormFieldAttributeModel(hint: labelText);
    colorSquareAttributeModel = new ColorSquareAttributeModel(values: values);
    imageSquareAttribute = new ImageSquareAttribute(values: values);
    datePickerAttributeModel = new DatePickerAttributeModel(hint: labelText);
    fileChooserAttributeModel = new FileChooserAttributeModel(label: labelText);
  }

  bool checkForNull(String key,Map<String,dynamic> map){
    return map.containsKey(key) && map[key] != null;
  }

}