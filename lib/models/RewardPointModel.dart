class RewardPointModel {
  var rewardPoints;
  var rewardPointsAmount;
  var rewardListPoints;
  var rewardListMessage;
  var rewardListDate;

  List<RewardPointModel> rewardPointProductList;
  List<RewardPointModel> downloadAbleProductList;
  List<RewardPointModel> productReviewList;

  RewardPointModel.fromMapForRewardPointList(Map<String, dynamic> map) {
    if (checkForNull("RewardPointsBalance", map)) {
      rewardPoints = map['RewardPointsBalance'];
    }

    if (checkForNull("RewardPointsAmount", map)) {
      rewardPointsAmount = map['RewardPointsAmount'];
    }

    if (checkForNull("RewardPoints", map)) {
      List rewardPointList = map['RewardPoints'];
      rewardPointProductList = rewardPointList
          .map((c) => new RewardPointModel.fromMapForRewardPointProductList(c))
          .toList();
    }
  }

  RewardPointModel.fromMapForRewardPointProductList(Map<String, dynamic> map) {
    if (checkForNull("Points", map)) {
      rewardListPoints = map['Points'];
    }

    if (checkForNull("Message", map)) {
      rewardListMessage = map['Message'];
    }

    if (checkForNull("CreatedOn", map)) {
      rewardListDate = map['CreatedOn'];
    }
  }

  RewardPointModel.fromMapForDownloadAbleProductList(Map<String, dynamic> map) {
    if (checkForNull("Items", map)) {
      List mDownloadAbleProductList = map['Items'];
      downloadAbleProductList = mDownloadAbleProductList
          .map((c) =>
              new RewardPointModel.fromMapForDownloadAbleProductDetailList(c))
          .toList();
    }
  }

  var orderProductId;
  var orderProductDate;
  var orderProductName;
  var orderProductSize;
  var orderProductColor;
  var orderProductDownload;

  RewardPointModel.fromMapForDownloadAbleProductDetailList(
      Map<String, dynamic> map) {
    if (checkForNull("OrderId", map)) {
      orderProductId = map['OrderId'];
    }

    if (checkForNull("CreatedOn", map)) {
      orderProductDate = map['CreatedOn'];
    }

    if (checkForNull("ProductName", map)) {
      orderProductName = map['ProductName'];
    }

    if (checkForNull("DownloadId", map)) {
      orderProductDownload = map['DownloadId'];
    }
  }

  var reviewProductId;
  var reviewProductDate;
  var reviewProductName;
  var reviewProductDescription;
  var reviewProductRating;

  RewardPointModel.fromMapForProductReviewList(Map<String, dynamic> map) {
    if (checkForNull("ProductReviews", map)) {
      List mProductReviewList = map['ProductReviews'];
      productReviewList = mProductReviewList
          .map((c) => new RewardPointModel.fromMapForProductReviewDetailList(c))
          .toList();
    }
  }

  RewardPointModel.fromMapForProductReviewDetailList(Map<String, dynamic> map) {
    if (checkForNull("ProductId", map)) {
      reviewProductId = map['ProductId'];
    }

    if (checkForNull("WrittenOnStr", map)) {
      reviewProductDate = map['WrittenOnStr'];
    }

    if (checkForNull("ProductName", map)) {
      reviewProductName = map['ProductName'];
    }

    if (checkForNull("ReviewText", map)) {
      reviewProductDescription = map['ReviewText'];
    }

    if (checkForNull("Rating", map)) {
      reviewProductRating = map['Rating'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
