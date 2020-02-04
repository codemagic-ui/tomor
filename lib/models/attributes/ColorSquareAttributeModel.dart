import 'package:i_am_a_student/models/productDetail/AttributeValueModel.dart';

class ColorSquareAttributeModel{

  int selectedColorBox;
  List<AttributeValueModel> values = new List<AttributeValueModel>();


  ColorSquareAttributeModel({this.values}){
    for (int i = 0; i < values.length; i++) {
      if(values[i].isPreSelected){
        selectedColorBox = i;
      }
    }
  }


}