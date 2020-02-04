class EstimateShippingMethod {
  var mName, mDescription, mPrice;

  EstimateShippingMethod.fromMapEstimateShippingMethod(
      Map<String, dynamic> map) {
    if (checkForNull("Name", map)) {
      mName = map['Name'];
    }
    if (checkForNull("Description", map)) {
      mDescription = map['Description'];
    }
    if (checkForNull("Price", map)) {
      mPrice = map['Price'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
