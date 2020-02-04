class ImageListModel {
  var imageId;
  String url;
  String largeImage;
  bool isVideo;

  ImageListModel();

  ImageListModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      imageId = map["id"];
    }

    if (checkForNull("src", map)) {
      url = map["src"];
      largeImage = map["src"];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
