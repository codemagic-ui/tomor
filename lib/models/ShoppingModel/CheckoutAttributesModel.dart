import 'package:i_am_a_student/models/productDetail/AttributeModel.dart';

class CheckoutAttributesModel {
  List<AttributeModel> attributes = new List<AttributeModel>();

  CheckoutAttributesModel({this.attributes});

  CheckoutAttributesModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("CheckOutAttribute", map)) {
      List checkOutAttributes = map["CheckOutAttribute"];
      attributes = checkOutAttributes
          .map((c) => new AttributeModel.fromMpForCheckoutAttribute(c))
          .toList();
      print(attributes.toString());
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
