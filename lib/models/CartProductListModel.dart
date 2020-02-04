import 'package:i_am_a_student/models/ImageModel.dart';

class CartProductListModel {
  var deleteCartId;
  var cartItemId;
  var cartItemName;
//  var cartItemImage = "";
  var cartItemPrice;
  var cartItemOldPrice;
  var cartItemRating;
  var cartItemQuantity;
  var order_minimum_quantity;
  var order_maximum_quantity;

  var quantityByUser;

  List<CartProductListModel> addCartProductDetailList;
  List<ImageModel> addCartProductList;

  CartProductListModel();

  CartProductListModel.fromMapForAddCartProductList(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      deleteCartId = map['id'];
    }

    if (checkForNull("quantity", map)) {
      cartItemQuantity = map['quantity'];
    }

    if (checkForNull("product_id", map)) {
      cartItemId = map['product_id'];
    }

    if (checkForNull("product", map)) {
      Map productDetails = map['product'];

      if (checkForNull("name", productDetails)) {
        cartItemName = productDetails['name'];
      }
      if (checkForNull("order_minimum_quantity", productDetails)) {
        order_minimum_quantity = productDetails['order_minimum_quantity'];
      }
      if (checkForNull("order_maximum_quantity", productDetails)) {
        order_maximum_quantity = productDetails['order_maximum_quantity'];
      }

      if (checkForNull("price", productDetails)) {
        cartItemPrice = productDetails['price'];
      }
      if (checkForNull("old_price", productDetails)) {
        cartItemOldPrice = productDetails['old_price'];
      }
      if (checkForNull("approved_rating_sum", productDetails)) {
        cartItemRating = productDetails['approved_rating_sum'];
      }

      if (checkForNull("images", productDetails)) {
        List images = productDetails["images"];
         addCartProductList = images.map((c) => new ImageModel.fromMap(c)).toList();
        /*if (checkForNull("src", images)) {
          if (images.length > 0) {
            cartItemImage = images[0]['src'];
          }
        }*/
      }
    }

    quantityByUser = cartItemQuantity;
  }

  var itemSubTotal;
  var itemShipping;
  var itemTax;
  var itemTotal;
  var itemEarnPoints;
  var itemSubTotalDiscount;
  var itemOrderTotalDiscount;

  CartProductListModel.fromMapForAddCartProductPriceTotal(
      Map<String, dynamic> map) {
    if (checkForNull("SubTotal", map)) {
      itemSubTotal = map['SubTotal'];
    }
    if (checkForNull("SubTotalDiscount", map)) {
      itemSubTotalDiscount = map['SubTotalDiscount'];
    }
    if (checkForNull("Shipping", map)) {
      itemShipping = map['Shipping'];
    }
    if (checkForNull("Tax", map)) {
      itemTax = map['Tax'];
    }
    if (checkForNull("OrderTotalDiscount", map)) {
      itemOrderTotalDiscount = map['OrderTotalDiscount'];
    }
    if (checkForNull("OrderTotal", map)) {
      itemTotal = map['OrderTotal'];
    }
    if (checkForNull("WillEarnRewardPoints", map)) {
      itemEarnPoints = map['WillEarnRewardPoints'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
