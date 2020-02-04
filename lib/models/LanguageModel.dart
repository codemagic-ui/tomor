class LanguageModel {
  String name;
  String id;
  bool rtl;
  String image;

  LanguageModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("name", map)) {
      name = map["name"].toString();
    }
    if (checkForNull("id", map)) {
      id = map["id"].toString();
    }
    if (checkForNull("rtl", map)) {
      rtl = map["rtl"];
    }
    if (checkForNull("flag_image_file_name", map)) {
      image = map["flag_image_file_name"].toString();
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
