class ManufacturerModel {
  var name;
  var id;

  ManufacturerModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Name", map)) {
      name = map["Name"];
    }

    if (checkForNull("Id", map)) {
      id = map["Id"];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
