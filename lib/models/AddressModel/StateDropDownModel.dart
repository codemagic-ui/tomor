import 'package:flutter/material.dart';
import 'package:i_am_a_student/models/AddressModel/StateModel.dart';

class StateDropDownModel{
  List<StateModel> values = new List<StateModel>();

  List<DropdownMenuItem<StateModel>> dropDownItems = new List<DropdownMenuItem<StateModel>>();
  StateModel currentValue;



  StateDropDownModel({this.values}){
    generateDropDownList(values);
  }

  generateDropDownList(List<StateModel> values){
    for (int i = 0; i < values.length; i++) {
      if(values[i].isSelected!=null){
        if(values[i].isSelected){
          currentValue = values[i];
        }
      }

      dropDownItems.add(new DropdownMenuItem(child: Text(values[i].strText),value: values[i],));
    }
  }
}