
import 'package:i_am_a_student/models/productDetail/AttributeValueModel.dart';

class RadioButtonAttributeModel{
  List<AttributeValueModel> values = new List<AttributeValueModel>();
  AttributeValueModel currentValue;

  RadioButtonAttributeModel({this.values}){
    for (int i = 0; i < values.length; i++) {
      if(values[i].isPreSelected){
        currentValue = values[i];
      }
    }
    /*if(currentValue == null && values.length != 0){
      currentValue = values[0];
    }*/
  }

}