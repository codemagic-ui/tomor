class TierPriceModel {
  var price;
  var quantity;

  TierPriceModel.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      if (checkForNull("Price", map)) {
        price = map["Price"];
      }

      if (checkForNull("Quantity", map)) {
        quantity = map["Quantity"];
      }
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
