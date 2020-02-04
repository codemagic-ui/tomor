import 'package:i_am_a_student/models/productDetail/AttributeValueModel.dart';

class ImageSquareAttribute{
  int selectedImageBox;
  List<AttributeValueModel> values = new List<AttributeValueModel>();


  ImageSquareAttribute({this.values}){
    for (int i = 0; i < values.length; i++) {
      if(values[i].isPreSelected){
        selectedImageBox = i;
      }
    }
  }
}