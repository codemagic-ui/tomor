import 'dart:convert';

import 'package:i_am_a_student/models/productDetail/AttributeModel.dart';
import 'package:i_am_a_student/models/productDetail/ImageListModel.dart';
import 'package:i_am_a_student/models/productDetail/ManufacturerModel.dart';
import 'package:i_am_a_student/models/productDetail/ProductSpecificationModel.dart';
import 'package:i_am_a_student/models/productDetail/ProductTagModel.dart';
import 'package:i_am_a_student/models/productDetail/TierPriceModel.dart';

class ProductDetailModel {
  var productType = "";
  var productId;
  var productTitle = "";
  var shortDescription = "";
  var longDescription = "";
  var price;
  var oldPrice;

  bool hasTierPrice;

  List<ImageListModel> imageList = new List<ImageListModel>();
  int currentImageIndex = 0;

  bool isDisableWishListButton = false;
  bool isDisableCartButton = false;
  var sku;

  var approvedRatingSum;
  var approvedTotalReviews;
  var isFreeShipping;
  var isAllowForReview;

  var stockQuantity;
  var isDisplayStockAvailability;
  var isDisplayAvailabilityStockQuantityCount;
  var minimumOrderQuantityCount;
  var maximumOrderQuantityCount;
  var quantityByUser;

  bool isDownload;
  bool isGiftCard;
  String giftCardType;

  String customerEnteredPriceValue;

  bool hasDownloadSample;
  var downLoadSampleUrl;
  bool isUnlimitedDownloads;
  int maxNumberOfDownload;

  bool isRental;
  int rentalPriceLength;
  String rentStartDateByUser;
  String rentEndDateByUser;
  String rentalType;

  bool isCustomerEnterPrice;
  var minimumCustomerEnterPrice;
  var maximumCustomerEnterPrice;

  List<AttributeModel> attributes = new List<AttributeModel>();

  List<ProductTagModel> productTagList = new List<ProductTagModel>();

  List<ManufacturerModel> manufacturesList = new List<ManufacturerModel>();

  List<ProductSpecificationModel> specificationList =
      new List<ProductSpecificationModel>();

  List<TierPriceModel> tierPriceModelList = new List<TierPriceModel>();

  List<ProductDetailModel> associatedProducts = new List<ProductDetailModel>();

  List<int> associatedProductIds = new List<int>();

  List<int> tagIds = new List<int>();

  var IsProductInWishList;

  ProductDetailModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("product_type", map)) {
      productType = map["product_type"];
    }

    if (checkForNull("id", map)) {
      productId = map["id"];
    }

    if (checkForNull("name", map)) {
      productTitle = map["name"];
    }

    if (checkForNull("short_description", map)) {
      shortDescription = map["short_description"];
    }
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }

    if (checkForNull("full_description", map)) {
      longDescription = map["full_description"];
    }

    if (checkForNull("allow_customer_reviews", map)) {
      isAllowForReview = map["allow_customer_reviews"];
    }

    if (checkForNull("approved_rating_sum", map)) {
      approvedRatingSum = map["approved_rating_sum"];
    }

    if (checkForNull("approved_total_reviews", map)) {
      approvedTotalReviews = map["approved_total_reviews"];
    }

    if (checkForNull("sku", map)) {
      sku = map["sku"];
    }

    if (checkForNull("is_free_shipping", map)) {
      isFreeShipping = map["is_free_shipping"];
    }

    if (checkForNull("stock_quantity", map)) {
      stockQuantity = map["stock_quantity"];
    }

    if (checkForNull("display_stock_availability", map)) {
      isDisplayStockAvailability = map["display_stock_availability"];
    }

    if (checkForNull("display_stock_quantity", map)) {
      isDisplayAvailabilityStockQuantityCount = map["display_stock_quantity"];
    }

    if (checkForNull("order_minimum_quantity", map)) {
      minimumOrderQuantityCount = map["order_minimum_quantity"];
    }

    if (checkForNull("order_maximum_quantity", map)) {
      maximumOrderQuantityCount = map["order_maximum_quantity"];
    }

    if (checkForNull("price", map)) {
      price = map["price"];
    }

    if (checkForNull("old_price", map)) {
      oldPrice = map["old_price"];
    }

    if (checkForNull("is_gift_card", map)) {
      isGiftCard = map["is_gift_card"];
    }

    if (checkForNull("images", map)) {
      List images = map["images"];
      imageList = images.map((c) => new ImageListModel.fromMap(c)).toList();
    }

    if (checkForNull("attributes", map)) {
      List attributeList = map["attributes"];
      attributes =
          attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
    }

    if (checkForNull("tags", map)) {
      List tagList = map["tags"];
      productTagList = tagList.map((c) => new ProductTagModel.fromMap(c)).toList();
    }

    if (checkForNull("Tagids", map)) {
      List tagIdsList = map["Tagids"];
      for (int i = 0; i < tagIdsList.length; i++) {
        tagIds.add(tagIdsList[i]);
      }
    }

    if (checkForNull("manufacturer", map)) {
      List manufacturerList = map["manufacturer"];
      manufacturesList = manufacturerList
          .map((c) => new ManufacturerModel.fromMap(c))
          .toList();
    }

    if (checkForNull("ProductSpecifications", map)) {
      List specifications = map["ProductSpecifications"];
      specificationList = specifications
          .map((c) => new ProductSpecificationModel.fromMap(c))
          .toList();
    }

    if (checkForNull("has_tier_prices", map)) {
      hasTierPrice = map["has_tier_prices"];
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }

    if (checkForNull("associated_product_ids", map)) {
      List groupProductIds = map["associated_product_ids"];
      groupProductIds.map((c) => associatedProductIds.add(c)).toList();
    }

    if (checkForNull("GiftCardType", map)) {
      giftCardType = map["GiftCardType"];
    }

    if (checkForNull("is_download", map)) {
      isDownload = map["is_download"];
    }

    if (checkForNull("customer_enters_price", map)) {
      isCustomerEnterPrice = map["customer_enters_price"];
    }

    if (checkForNull("minimum_customer_entered_price", map)) {
      minimumCustomerEnterPrice = map["minimum_customer_entered_price"];
    }

    if (checkForNull("maximum_customer_entered_price", map)) {
      maximumCustomerEnterPrice = map["maximum_customer_entered_price"];
    }

    if (minimumCustomerEnterPrice != null &&
        minimumCustomerEnterPrice.toString().isNotEmpty) {
      customerEnteredPriceValue = minimumCustomerEnterPrice.toString();
    }

    if (checkForNull("has_sample_download", map)) {
      hasDownloadSample = map["has_sample_download"];
    }

    if (checkForNull("DownLoadSampleUrl", map)) {
      downLoadSampleUrl = map["DownLoadSampleUrl"];
    }

    if (checkForNull("unlimited_downloads", map)) {
      isUnlimitedDownloads = map["unlimited_downloads"];
    }

    if (checkForNull("max_number_of_downloads", map)) {
      maxNumberOfDownload = map["max_number_of_downloads"];
    }

    if (checkForNull("is_rental", map)) {
      isRental = map["is_rental"];
    }

    if (checkForNull("rental_price_length", map)) {
      rentalPriceLength = map["rental_price_length"];
    }
    if (checkForNull("RentalType", map)) {
      rentalType = map["RentalType"];
    }
    if (checkForNull("disable_buy_button", map)) {
      isDisableCartButton = map["disable_buy_button"];
    }
    if (checkForNull("disable_wishlist_button", map)) {
      isDisableWishListButton = map["disable_wishlist_button"];
    }
  }

  static String toJsonForAddToCart(productDetailModel, customerId) {
    Map<String, dynamic> map = {
      "shopping_cart_item": [
        {
          "shopping_cart_type": "1",
          "customer_id": "$customerId",
          "product_id": productDetailModel.productId,
          "product": {
            "id": productDetailModel.productId,
            "attributes": mapForAttribute(productDetailModel),
          },
        }
      ]
    };

    String strJson = json.encode(map);
    return strJson;
  }

  static mapForAttribute(productDetailModel) {
    List list = new List();
    for (int i = 0; i < productDetailModel.attributes.length; i++) {
      Map<String, dynamic> map = {
        "id": productDetailModel.attributes[i].attributeId,
        "attribute_values":
            mapForAttributeValues(productDetailModel.attributes[i]),
      };
      list.add(map);
    }
    return list;
  }

  static mapForAttributeValues(AttributeModel attribute) {
    List list = new List();
    String keyForId = "id";
    var valueForId;

    switch (attribute.attributeControlTypeId) {
      case 1:
        if (attribute.dropDownAttributeModel.currentValue != null) {
          list.add(
              valueForId = attribute.dropDownAttributeModel.currentValue.id);
        }
        break;
      case 2:
        if (attribute.radioButtonAttributeModel.currentValue != null) {
          list.add(
              valueForId = attribute.radioButtonAttributeModel.currentValue.id);
        }
        break;
      case 3:
        for (int i = 0;
            i < attribute.checkBoxAttributeModel.values.length;
            i++) {
          if (attribute.checkBoxAttributeModel.values[i].isPreSelected) {
            list.add(
                valueForId = attribute.checkBoxAttributeModel.values[i].id);
          }
        }
        break;
      case 4:
        if (attribute.textFormFieldAttributeModel.value != null) {
          list.add(valueForId = attribute.textFormFieldAttributeModel.value);
        }
        break;
      case 10:
        if (attribute.textFormFieldAttributeModel.value != null) {
          list.add(valueForId = attribute.textFormFieldAttributeModel.value);
        }
        break;
      case 40:
        for (int i = 0;
            i < attribute.colorSquareAttributeModel.values.length;
            i++) {
          if (attribute.colorSquareAttributeModel.selectedColorBox == i) {
            list.add(
                valueForId = attribute.checkBoxAttributeModel.values[i].id);
          }
        }
        break;
      case 45:
        for (int i = 0; i < attribute.imageSquareAttribute.values.length; i++) {
          if (attribute.imageSquareAttribute.selectedImageBox == i) {
            list.add(valueForId = attribute.imageSquareAttribute.values[i].id);
          }
        }
        break;
      case 50:
        for (int i = 0;
            i < attribute.checkBoxAttributeModel.values.length;
            i++) {
          if (attribute.checkBoxAttributeModel.values[i].isPreSelected) {
            list.add(
                valueForId = attribute.checkBoxAttributeModel.values[i].id);
          }
        }
        break;
      case 20:
        if (attribute.datePickerAttributeModel.value != null) {
          list.add(attribute.datePickerAttributeModel.value);
        }
        break;
      case 30:
//        return filePicker(productDetailModel.attributes[index]);
        break;
    }
    var map = [
      {
        keyForId: valueForId,
      }
    ];
    return map;
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
