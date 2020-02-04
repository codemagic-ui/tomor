class PaymentMethodModel {
  String paymentMethodSystemName;
  String name;
  String logoUrl;
  bool isSelected;

  PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("PaymentMethodSystemName", map)) {
      paymentMethodSystemName = map["PaymentMethodSystemName"];
    }

    if (checkForNull("Name", map)) {
      name = map["Name"];
    }

    if (checkForNull("LogoUrl", map)) {
      logoUrl = map["LogoUrl"];
    }

    if (checkForNull("Selected", map)) {
      isSelected = map["Selected"];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
