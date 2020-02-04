import 'package:flutter/material.dart';
import 'package:i_am_a_student/models/productDetail/AttributeValueModel.dart';

class DropDownAttributeModel{
  List<AttributeValueModel> values = new List<AttributeValueModel>();

  List<DropdownMenuItem<AttributeValueModel>> dropDownItems =[];
  AttributeValueModel currentValue;



  DropDownAttributeModel({this.values}){
    generateDropDownList(values);
  }

  generateDropDownList(List<AttributeValueModel> values){
    for (int i = 0; i < values.length; i++) {
      if(values[i].isPreSelected){
        currentValue = values[i];
      }
      dropDownItems.add(new DropdownMenuItem(child: Text(values[i].name),value: values[i],));
    }
  }
}