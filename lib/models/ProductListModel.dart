import 'package:i_am_a_student/models/productDetail/AttributeModel.dart';
import 'package:i_am_a_student/models/productDetail/TierPriceModel.dart';

class ProductListModel {
  var id;
  var deleteId;
  var name;
  var skuName;
  var image = "";
  var price;
  var unitPrice;
  var oldPrice;
  var rating;
  var minQuntity;
  var currencyType;

  bool isGiftCard;
  List<AttributeModel> attributes = new List<AttributeModel>();
  List<ProductListModel> wishProductList = new List<ProductListModel>();

  List<TierPriceModel> tierPriceModelList = new List<TierPriceModel>();

  //region used in product detail screen
  var sku;
  var stockQuantity;
  var isDisplayStockAvailability;
  var isDisplayAvailabilityStockQuantityCount;
  var minimumPrice, maximumPrice;

  var IsProductInWishList = false;

  //endregion

  ProductListModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    oldPrice = map['old_price'];
    rating = map['approved_rating_sum'];
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }
    if (map['images'] != null) {
      List images = map["images"];
      if (images != null && images.length > 0) {
        if (checkForNull("src", images[0])) {
          if (images.length > 0) {
            image = images[0]['src'];
          }
        }
      }
    }
    if (map.containsKey("TierPrices")) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  ProductListModel.fromMapForSubcategoryProductList(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      id = map['id'];
    }

    if (checkForNull("name", map)) {
      name = map['name'];
    }

    if (checkForNull("order_minimum_quantity", map)) {
      minQuntity = map['order_minimum_quantity'];
    }

    if (checkForNull("price", map)) {
      price = map['price'];
    }

    if (checkForNull("old_price", map)) {
      oldPrice = map['old_price'];
    }

    if (checkForNull("MinPrice", map)) {
      minimumPrice = map['MinPrice'];
    }

    if (checkForNull("MAxPrice", map)) {
      maximumPrice = map['MAxPrice'];
    }

    if (checkForNull("approved_rating_sum", map)) {
      rating = map['approved_rating_sum'];
    }
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }
    if (checkForNull("is_gift_card", map)) {
      isGiftCard = map['is_gift_card'];
    }
    if (checkForNull("attributes", map)) {
      List attributeList = map["attributes"];
      attributes =
          attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
    }
    if (checkForNull("CurrencyType", map)) {
      currencyType = map['CurrencyType'];
    }

    if (checkForNull("images", map)) {
      List images = map["images"];
      if (images != null && images.length > 0) {
        if (checkForNull("src", images[0])) {
          if (images.length > 0) {
            image = images[0]['src'];
          }
        }
      }
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  ProductListModel.fromMapForRelatedProduct(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      id = map['id'];
    }

    if (checkForNull("name", map)) {
      name = map['name'];
    }

    if (checkForNull("order_minimum_quantity", map)) {
      minQuntity = map['order_minimum_quantity'];
    }

    if (checkForNull("price", map)) {
      price = map['price'];
    }

    if (checkForNull("old_price", map)) {
      oldPrice = map['old_price'];
    }
    if (checkForNull("approved_rating_sum", map)) {
      rating = map['approved_rating_sum'];
    }
    if (checkForNull("is_gift_card", map)) {
      isGiftCard = map['is_gift_card'];
    }
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }
    if (checkForNull("attributes", map)) {
      List attributeList = map["attributes"];
      attributes =
          attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
    }

    if (checkForNull("CurrencyType", map)) {
      currencyType = map['CurrencyType'];
    }

    if (checkForNull("images", map)) {
      List images = map["images"];
      if (images != null && images.length > 0) {
        if (checkForNull("src", images[0])) {
          if (images.length > 0) {
            image = images[0]['src'];
          }
        }
      }
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }

//    if (map['images'] != null) {
//      if (map['images'][0].containsKey('src')) {
//        image = map['images'][0]['src'];
//      }
//    }
//
//    if (map.containsKey("TierPrices")) {
//      List tierPrices = map["TierPrices"];
//      tierPriceModelList =
//          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
//    }
  }

  ProductListModel.fromMapForSearchProductsList(Map<String, dynamic> map) {
    try {
      if (checkForNull("id", map)) {
        id = map['id'];
      }

      if (checkForNull("name", map)) {
        name = map['name'];
      }

      if (checkForNull("price", map)) {
        price = map['price'];
      }

      if (checkForNull("old_price", map)) {
        oldPrice = map['old_price'];
      }
      if (checkForNull("order_minimum_quantity", map)) {
        minQuntity = map['order_minimum_quantity'];
      }

      if (checkForNull("approved_rating_sum", map)) {
        rating = map['approved_rating_sum'];
      }

      if (checkForNull("MinPrice", map)) {
        minimumPrice = map['MinPrice'];
      }

      if (checkForNull("MAxPrice", map)) {
        maximumPrice = map['MAxPrice'];
      }
      if (checkForNull("IsProductInWishList", map)) {
        IsProductInWishList = map['IsProductInWishList'];
      }
      if (checkForNull("CurrencyType", map)) {
        currencyType = map['CurrencyType'];
      }
      if (checkForNull("is_gift_card", map)) {
        isGiftCard = map['is_gift_card'];
      }

      if (checkForNull("images", map)) {
        List images = map["images"];
        if (images != null && images.length > 0) {
          if (checkForNull("src", images[0])) {
            if (images.length > 0) {
              image = images[0]['src'];
            }
          }
        }
      }

      if (checkForNull("TierPrices", map)) {
        List tierPrices = map["TierPrices"];
        tierPriceModelList =
            tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
      }
    } catch (e) {
      print(e);
    }
  }

  ProductListModel.fromMapForCategoryProductList(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      id = map['id'];
    }

    if (checkForNull("name", map)) {
      name = map['name'];
    }

    if (checkForNull("order_minimum_quantity", map)) {
      minQuntity = map['order_minimum_quantity'];
    }

    if (checkForNull("price", map)) {
      price = map['price'];
    }
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }
    if (checkForNull("old_price", map)) {
      oldPrice = map['old_price'];
    }
    if (checkForNull("approved_rating_sum", map)) {
      rating = map['approved_rating_sum'];
    }
    if (checkForNull("is_gift_card", map)) {
      isGiftCard = map['is_gift_card'];
    }
    if (checkForNull("attributes", map)) {
      List attributeList = map["attributes"];
      attributes =
          attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
    }

    if (checkForNull("CurrencyType", map)) {
      currencyType = map['CurrencyType'];
    }

    if (checkForNull("images", map)) {
      List images = map["images"];
      if (images != null && images.length > 0) {
        if (checkForNull("src", images[0])) {
          if (images.length > 0) {
            image = images[0]['src'];
          }
        }
      }
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  ProductListModel.fromMapForWishList(Map<String, dynamic> map) {
    if (checkForNull("Items", map)) {
      List wishList = map['Items'];
      wishProductList = wishList
          .map((c) => new ProductListModel.fromMapForWishListProduct(c))
          .toList();
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  ProductListModel.fromMapForWishListProduct(Map<String, dynamic> map) {
    if (checkForNull("Sku", map)) {
      skuName = map['Sku'];
    }

    if (checkForNull("ProductId", map)) {
      id = map['ProductId'];
    }

    if (checkForNull("ProductName", map)) {
      name = map['ProductName'];
    }

    if (checkForNull("Quantity", map)) {
      stockQuantity = map['Quantity'];
    }
    if (checkForNull("SubTotal", map)) {
      price = map['SubTotal'];
    }
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }
    if (checkForNull("Id", map)) {
      deleteId = map['Id'];
    }
    if (checkForNull("Picture", map)) {
      Map imageProduct = map['Picture'];
      if (checkForNull("ImageUrl", imageProduct)) {
        image = imageProduct['ImageUrl'];
      }
    }

    if (checkForNull("UnitPrice", map)) {
      unitPrice = map['UnitPrice'];
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  ProductListModel.fromMapForBrandProductList(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      id = map['id'];
    }

    if (checkForNull("name", map)) {
      name = map['name'];
    }
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }

    if (checkForNull("order_minimum_quantity", map)) {
      minQuntity = map['order_minimum_quantity'];
    }

    if (checkForNull("price", map)) {
      price = map['price'];
    }

    if (checkForNull("MinPrice", map)) {
      minimumPrice = map['MinPrice'];
    }

    if (checkForNull("MAxPrice", map)) {
      maximumPrice = map['MAxPrice'];
    }

    if (checkForNull("old_price", map)) {
      oldPrice = map['old_price'];
    }

    if (checkForNull("approved_rating_sum", map)) {
      rating = map['approved_rating_sum'];
    }
    if (checkForNull("is_gift_card", map)) {
      isGiftCard = map['is_gift_card'];
    }

    if (checkForNull("attributes", map)) {
      List attributeList = map["attributes"];
      if (attributeList != null && attributeList.length != 0) {
        attributes =
            attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
      }
    }

    if (checkForNull("CurrencyType", map)) {
      currencyType = map['CurrencyType'];
    }

    if (checkForNull("images", map)) {
      List images = map["images"];
      if (images != null && images.length > 0) {
        if (checkForNull("src", images[0])) {
          if (images.length > 0) {
            image = images[0]['src'];
          }
        }
      }
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  ProductListModel.fromMapForFeatureProductList(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      id = map['id'];
    }

    if (checkForNull("name", map)) {
      name = map['name'];
    }

    if (checkForNull("order_minimum_quantity", map)) {
      minQuntity = map['order_minimum_quantity'];
    }
    if (checkForNull("IsProductInWishList", map)) {
      IsProductInWishList = map['IsProductInWishList'];
    }

    if (checkForNull("price", map)) {
      price = map['price'];
    }

    if (checkForNull("old_price", map)) {
      oldPrice = map['old_price'];
    }
    if (checkForNull("approved_rating_sum", map)) {
      rating = map['approved_rating_sum'];
    }
    if (checkForNull("is_gift_card", map)) {
      isGiftCard = map['is_gift_card'];
    }
    if (checkForNull("attributes", map)) {
      List attributeList = map["attributes"];
      attributes =
          attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
    }

    if (checkForNull("CurrencyType", map)) {
      currencyType = map['CurrencyType'];
    }

    if (checkForNull("images", map)) {
      List images = map["images"];
      if (images != null && images.length > 0) {
        if (checkForNull("src", images[0])) {
          if (images.length > 0) {
            image = images[0]['src'];
          }
        }
      }
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  ProductListModel.fromMapForTagProductList(Map<String, dynamic> map) {

      if (checkForNull("id", map)) {
            id = map['id'];
          }

      if (checkForNull("name", map)) {
            name = map['name'];
          }

      if (checkForNull("order_minimum_quantity", map)) {
            minQuntity = map['order_minimum_quantity'];
          }

      if (checkForNull("price", map)) {
            price = map['price'];
          }

      if (checkForNull("old_price", map)) {
            oldPrice = map['old_price'];
          }

      if (checkForNull("MinPrice", map)) {
            minimumPrice = map['MinPrice'];
          }
      if (checkForNull("IsProductInWishList", map)) {
        IsProductInWishList = map['IsProductInWishList'];
      }
      if (checkForNull("MAxPrice", map)) {
            maximumPrice = map['MAxPrice'];
          }

      if (checkForNull("approved_rating_sum", map)) {
            rating = map['approved_rating_sum'];
          }
      if (checkForNull("is_gift_card", map)) {
            isGiftCard = map['is_gift_card'];
          }

      if (checkForNull("attributes", map)) {
            List attributeList = map["attributes"];
            if (attributeList != null && attributeList.length > 0) {
              attributes =
                  attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
            }
          }

      if (checkForNull("CurrencyType", map)) {
            currencyType = map['CurrencyType'];
          }

      if (checkForNull("images", map)) {
            List images = map["images"];
            if (images != null && images.length > 0) {
              if (checkForNull("src", images[0])) {
                if (images.length > 0) {
                  image = images[0]['src'];
                }
              }
            }
          }

      if (checkForNull("TierPrices", map)) {
            List tierPrices = map["TierPrices"];
            if (tierPrices != null && tierPrices.length > 0) {
              tierPriceModelList =
                  tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
            }
          }

  }

  ProductListModel.fromMapForNewArrival(Map map) {
    if (map != null) {
      if (checkForNull("id", map)) {
        id = map['id'];
      }

      if (checkForNull("name", map)) {
        name = map['name'];
      }

      if (checkForNull("order_minimum_quantity", map)) {
        minQuntity = map['order_minimum_quantity'];
      }
      if (checkForNull("IsProductInWishList", map)) {
        IsProductInWishList = map['IsProductInWishList'];
      }

      if (checkForNull("price", map)) {
        price = map['price'];
      }

      if (checkForNull("old_price", map)) {
        oldPrice = map['old_price'];
      }

      if (checkForNull("approved_rating_sum", map)) {
        rating = map['approved_rating_sum'];
      }
      if (checkForNull("is_gift_card", map)) {
        isGiftCard = map['is_gift_card'];
      }

      if (checkForNull("attributes", map)) {
        List attributeList = map["attributes"];
        attributes =
            attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
      }

      if (checkForNull("CurrencyType", map)) {
        currencyType = map['CurrencyType'];
      }

      if (checkForNull("images", map)) {
        List images = map["images"];
        if (images != null && images.length > 0) {
          if (checkForNull("src", images[0])) {
            if (images.length > 0) {
              image = images[0]['src'];
            }
          }
        }
      }

      if (checkForNull("TierPrices", map)) {
        List tierPrices = map["TierPrices"];
        tierPriceModelList =
            tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
      }
    }
  }

  ProductListModel.fromMapForBestSeller(Map map) {
    if (map != null) {
      if (checkForNull("id", map)) {
        id = map['id'];
      }

      if (checkForNull("name", map)) {
        name = map['name'];
      }

      if (checkForNull("order_minimum_quantity", map)) {
        minQuntity = map['order_minimum_quantity'];
      }
      if (checkForNull("IsProductInWishList", map)) {
        IsProductInWishList = map['IsProductInWishList'];
      }
      if (checkForNull("price", map)) {
        price = map['price'];
      }

      if (checkForNull("old_price", map)) {
        oldPrice = map['old_price'];
      }

      if (checkForNull("approved_rating_sum", map)) {
        rating = map['approved_rating_sum'];
      }
      if (checkForNull("is_gift_card", map)) {
        isGiftCard = map['is_gift_card'];
      }

      if (checkForNull("attributes", map)) {
        List attributeList = map["attributes"];
        attributes =
            attributeList.map((c) => new AttributeModel.fromMap(c)).toList();
      }

      if (checkForNull("CurrencyType", map)) {
        currencyType = map['CurrencyType'];
      }

      if (checkForNull("images", map)) {
        List images = map["images"];
        if (images != null && images.length > 0) {
          if (checkForNull("src", images[0])) {
            if (images.length > 0) {
              image = images[0]['src'];
            }
          }
        }
      }

      if (checkForNull("TierPrices", map)) {
        List tierPrices = map["TierPrices"];
        tierPriceModelList =
            tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
      }
    }
  }

  ProductListModel.fromMapForBrandList(Map map) {
    if (checkForNull("Id", map)) {
      id = map['Id'];
    }

    if (checkForNull("Name", map)) {
      name = map['Name'];
    }

    if (checkForNull("PictureModel", map)) {
      Map mapImage = map['PictureModel'];
      if (checkForNull("ImageUrl", mapImage)) {
        image = mapImage['ImageUrl'];
      }
    }

    if (checkForNull("TierPrices", map)) {
      List tierPrices = map["TierPrices"];
      tierPriceModelList =
          tierPrices.map((c) => new TierPriceModel.fromMap(c)).toList();
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
