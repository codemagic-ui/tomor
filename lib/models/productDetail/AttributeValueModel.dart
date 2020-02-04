class AttributeValueModel {
  var id;
  var name;
  var cost;
  bool isPreSelected = false;

  String color;
  var image;
  var productImageId;

  String imageUrl;

  AttributeValueModel({this.id, this.name, this.cost, this.isPreSelected});

  AttributeValueModel.fromMap(Map<String,dynamic> map){
    if(checkForNull("id", map)) {
      id = map["id"];
    }
    if(checkForNull("cost", map)) {
      cost = map["cost"];
    }
    if(checkForNull("name", map)) {
      name = map["name"];
    }
    if(checkForNull("is_pre_selected", map)) {
      isPreSelected = map["is_pre_selected"];
    }
    if(checkForNull("color_squares_rgb", map)) {
      color = map["color_squares_rgb"];
    }
    if(checkForNull("product_image_id", map)) {
      productImageId = map["product_image_id"];
    }

    if(checkForNull("image_squares_image", map)) {
      imageUrl = map["src"];
//      if(checkForNull("src", src)) {
//        imageUrl = src["src"];
//      }
    }
  }

  AttributeValueModel.fromMapForAddress(Map<String,dynamic> map){
    id = map["Id"];
    name = map["Name"];
    isPreSelected = map["IsPreSelected"];
  }

  AttributeValueModel.fromMpForCheckoutAttribute(Map<String,dynamic> map){
    if(checkForNull("Id", map)) {
      id = map["Id"];
    }

    if(checkForNull("PriceAdjustment", map)) {
      cost = map["PriceAdjustment"];
    }

    if(checkForNull("Name", map)) {
      name = map["Name"];
      if(cost != null){
        name += " ["+cost.toString()+"]";
      }
    }
    if(checkForNull("IsPreSelected", map)) {
      isPreSelected = map["IsPreSelected"];
    }
    if(checkForNull("ColorSquaresRgb", map)) {
      color = map["ColorSquaresRgb"];
    }
  }

  bool checkForNull(String key,Map<String,dynamic> map){
    return map.containsKey(key) && map[key] != null;
  }

}
