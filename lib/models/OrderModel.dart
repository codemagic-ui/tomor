import 'package:i_am_a_student/models/AddressModel/AddressModel.dart';
import 'package:i_am_a_student/models/OrderItemModel.dart';

class OrderModel {
  AddressModel billingAddress;

  AddressModel shippingAddress;

  List<OrderItemModel> orderItemList = new List<OrderItemModel>();

  String subTotal;
  String shipping;
  String tax;
  var orderTotalDiscount;
  var redeemedRewardPoints;
  String orderTotal;

  OrderModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("billingAddress", map)) {
      billingAddress = AddressModel.fromMapForConfirmOrder(map["billingAddress"]);
    }

    if (checkForNull("ShippingAddress", map)) {
      shippingAddress =
          AddressModel.fromMapForConfirmOrder(map["ShippingAddress"]);
    }

    if (checkForNull("ShoppingCartItem", map)) {
      Map shoppingCartItem = map["ShoppingCartItem"];
      if (checkForNull("shopping_carts", shoppingCartItem)) {
        List orderItems = shoppingCartItem["shopping_carts"];
        orderItemList =
            orderItems.map((c) => new OrderItemModel.fromMap(c)).toList();
      }
    }

    if (checkForNull("Ordertotalmodel", map)) {
      Map orderTotalModel = map["Ordertotalmodel"];
      if (checkForNull("SubTotal", orderTotalModel)) {
        subTotal = orderTotalModel["SubTotal"];
      }
      if (checkForNull("Shipping", orderTotalModel)) {
        shipping = orderTotalModel["Shipping"];
      }
      if (checkForNull("Tax", orderTotalModel)) {
        tax = orderTotalModel["Tax"];
      }
      if (checkForNull("OrderTotalDiscount", orderTotalModel)) {
        orderTotalDiscount = orderTotalModel["OrderTotalDiscount"];
      }
      if (checkForNull("OrderTotal", orderTotalModel)) {
        orderTotal = orderTotalModel["OrderTotal"];
      }
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
