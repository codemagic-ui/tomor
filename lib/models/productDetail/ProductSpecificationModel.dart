class ProductSpecificationModel {
  var id;
  var name;
  var value;

  ProductSpecificationModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("SpecificationAttributeId", map)) {
      id = map["SpecificationAttributeId"];
    }

    if (checkForNull("SpecificationAttributeName", map)) {
      name = map["SpecificationAttributeName"];
    }

    if (checkForNull("ValueRaw", map)) {
      value = map["ValueRaw"];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
