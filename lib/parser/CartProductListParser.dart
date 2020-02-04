import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class CartProductListParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map featuredProductsBody = json.decode(response.body);
        List addCartProducts = featuredProductsBody["shopping_carts"];
        List<CartProductListModel> addCartProductList = addCartProducts.map((c) => new CartProductListModel.fromMapForAddCartProductList(c)).toList();
        return {
          'errorCode': "0",
          'value': addCartProductList,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
  static Future callApiForAddressCheckOut(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map featuredProductsBody = json.decode(response.body);
        Map mShoppingCartItems =featuredProductsBody['ShoppingCartItems'];
        List addCartProducts = mShoppingCartItems["shopping_carts"];
        List<CartProductListModel> addCartProductList = addCartProducts.map((c) => new CartProductListModel.fromMapForAddCartProductList(c)).toList();
        return {
          'errorCode': "0",
          'value': addCartProductList,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
