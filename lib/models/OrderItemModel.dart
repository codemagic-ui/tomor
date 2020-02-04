class OrderItemModel {
  var id;
  int quantity;
  String name;
  String image;
  var price;
  var oldPrice;
  var rating;
  var sku;

  OrderItemModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      id = map['id'];
    }

    if (checkForNull("quantity", map)) {
      quantity = map['quantity'];
    }

    if (checkForNull("product", map)) {
      Map productDetail = map['product'];

      if (checkForNull("name", productDetail)) {
        name = productDetail['name'];
      }
      if (checkForNull("sku", productDetail)) {
        sku = productDetail['sku'];
      }

      if (checkForNull("images", productDetail)) {
        List images = productDetail["images"];
        if (images.length > 0) {
          if (checkForNull('src', images[0])) {
            image = images[0]['src'];
          }
        }
      }

      if (checkForNull("price", productDetail)) {
        price = productDetail['price'];
      }
      if (checkForNull("old_price", productDetail)) {
        oldPrice = productDetail['old_price'];
      }
      if (checkForNull("approved_rating_sum", productDetail)) {
        rating = productDetail['approved_rating_sum'];
      }
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
