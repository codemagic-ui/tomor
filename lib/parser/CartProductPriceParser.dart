import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class CartProductPriceParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map productPriceTotal = json.decode(response.body);
        Map cartTotal = productPriceTotal['CartTotal'];
        CartProductListModel cartProductListModel = new CartProductListModel.fromMapForAddCartProductPriceTotal(cartTotal);

        return {
          'errorCode': "0",
          'value': cartProductListModel,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
