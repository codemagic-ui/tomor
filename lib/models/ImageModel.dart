class ImageModel {
  var id;
  var pictureId;
  var position;
  var src;

  ImageModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      id = map['id'];
    }
    if (checkForNull("picture_id", map)) {
      pictureId = map['picture_id'];
    }
    if (checkForNull("position", map)) {
      position = map['position'];
    }
    if (checkForNull("src", map)) {
      src = map['src'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
