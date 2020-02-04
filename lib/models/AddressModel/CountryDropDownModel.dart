import 'package:i_am_a_student/models/AddressModel/CountryModel.dart';
import 'package:flutter/material.dart';

class CountryDropDownModel{
  List<CountryModel> values = new List<CountryModel>();

  List<DropdownMenuItem<CountryModel>> dropDownItems = new List<DropdownMenuItem<CountryModel>>();
  CountryModel currentValue;



  CountryDropDownModel({this.values}){
    generateDropDownList(values);
  }

  generateDropDownList(List<CountryModel> values){
    for (int i = 0; i < values.length; i++) {
      if(values[i].isSelected!=null && values[i].isSelected){
        currentValue = values[i];
      }
      if(values[i].strText!=null){
        dropDownItems.add(new DropdownMenuItem(child: Text(values[i].strText),value: values[i],));
      }

    }
  }
}