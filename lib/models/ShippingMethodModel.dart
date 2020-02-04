class ShippingMethodModel {
  String name;
  String description;
  String fee;
  String shippingOption;
  String shippingRateComputationMethodSystemName;
  bool isSelected;

  ShippingMethodModel.fromMap(Map<String, dynamic> map) {

    if (checkForNull("Name", map)) {
      name = map["Name"];
    }

    if (checkForNull("ShippingRateComputationMethodSystemName", map)) {
      shippingRateComputationMethodSystemName =
          map["ShippingRateComputationMethodSystemName"];
    }

    if (checkForNull("Description", map)) {
      description = map["Description"];
    }

    if (checkForNull("Fee", map)) {
      fee = map["Fee"];
    }

    if (checkForNull("Selected", map)) {
      isSelected = map["Selected"];
    }

    if (checkForNull("ShippingOption", map)) {
      shippingOption = map["ShippingOption"];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
