class ImageSliderModel {
  List<String> mPicture1UrlList = new List<String>();

  ImageSliderModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Picture1Url", map)) {
      if (map["Picture1Url"] != null &&
          map["Picture1Url"].toString().isNotEmpty) {
        mPicture1UrlList.add(map["Picture1Url"].toString());
      }
    }

    if (checkForNull("Picture2Url", map)) {
      if (map["Picture2Url"] != null &&
          map["Picture2Url"].toString().isNotEmpty) {
        mPicture1UrlList.add(map["Picture2Url"].toString());
      }
    }

    if (checkForNull("Picture3Url", map)) {
      if (map["Picture3Url"] != null &&
          map["Picture3Url"].toString().isNotEmpty) {
        mPicture1UrlList.add(map["Picture3Url"].toString());
      }
    }

    if (checkForNull("Picture4Url", map)) {
      if (map["Picture4Url"] != null &&
          map["Picture4Url"].toString().isNotEmpty) {
        mPicture1UrlList.add(map["Picture4Url"].toString());
      }
    }

    if (checkForNull("Picture5Url", map)) {
      if (map["Picture5Url"] != null &&
          map["Picture5Url"].toString().isNotEmpty) {
        mPicture1UrlList.add(map["Picture5Url"].toString());
      }
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
