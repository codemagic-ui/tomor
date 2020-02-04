import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/productDetail/ProductDetailModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class GetProductDetailParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        List list = body["products"];
        Map product = list[0];

        ProductDetailModel productDetailModel = ProductDetailModel.fromMap(product);
        return {'errorCode' : "0",'value' : productDetailModel,};
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
