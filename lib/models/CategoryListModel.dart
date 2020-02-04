class CategoryListModel {
  var categoryId;
  var categoryName;
  var categoryImageURl;
  var categoryDescription;

  CategoryListModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      categoryId = map['id'];
    }

    if (checkForNull("name", map)) {
      categoryName = map['name'];
    }

    if (checkForNull("description", map)) {
      categoryDescription = map['description'];
    }

    if (checkForNull("image", map)) {
      Map images = map["image"];
      if (checkForNull("src", images)) {
        categoryImageURl = images['src'];
      }
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
