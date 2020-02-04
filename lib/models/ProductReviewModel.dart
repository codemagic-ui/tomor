import 'dart:convert';

class ProductReviewModel {
  var mCustomerId;
  var mCustomerName;
  var mTitle;
  var mReviewText;
  var mReviewId;
  var mRating;
  var mHelpfulYesTotal;
  var mHelpfulNoTotal;
  var mWrittenOnStr;

  ProductReviewModel.fromMapForReviewList(Map<String, dynamic> map) {
    if (checkForNull("CustomerId", map)) {
      mCustomerId = map['CustomerId'];
    }

    if (checkForNull("CustomerName", map)) {
      mCustomerName = map['CustomerName'];
    }

    if (checkForNull("Title", map)) {
      mTitle = map['Title'];
    }

    if (checkForNull("ReviewText", map)) {
      mReviewText = map['ReviewText'];
    }

    if (checkForNull("Rating", map)) {
      mRating = map['Rating'];
    }

    if (checkForNull("Id", map)) {
      mReviewId = map['Id'];
    }

    if (checkForNull("Title", map)) {
      mTitle = map['Title'];
    }

    if (checkForNull("WrittenOnStr", map)) {
      mWrittenOnStr = map['WrittenOnStr'];
    }

    if (checkForNull("WrittenOnStr", map)) {
      mWrittenOnStr = map['WrittenOnStr'];
    }

    if (checkForNull("Helpfulness", map)) {
      Map mHelpfulness = map['Helpfulness'];
      if (checkForNull("HelpfulYesTotal", mHelpfulness)) {
        mHelpfulYesTotal = mHelpfulness['HelpfulYesTotal'];
      }
      if (checkForNull("HelpfulNoTotal", mHelpfulness)) {
        mHelpfulNoTotal = mHelpfulness['HelpfulNoTotal'];
      }
    }
  }

  static String addReview(
      String productId, String title, String reviewText, double ratingByUser) {
    Map<String, dynamic> map = {
      "ProductId": productId.toString(),
      "Title": title.toString(),
      "ReviewText": reviewText.toString(),
      "Rating": ratingByUser.round().toString(),
      "DisplayCaptcha": true.toString(),
      "CanCurrentCustomerLeaveReview": true.toString(),
      "SuccessfullyAdded": true.toString()
    };
    return json.encode(map);
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
