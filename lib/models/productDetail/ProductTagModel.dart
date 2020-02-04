class ProductTagModel {
  var tagName;
  var tagId;

  ProductTagModel({this.tagName, this.tagId});

  ProductTagModel.fromMap(var map) {
    tagName = map;
  }
}
