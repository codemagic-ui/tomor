import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/MyOrderProductListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class OrderListParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    if (statusCode == 200) {
      Map myOrderProductsBody = json.decode(response.body);
      List myOrderProductsList = myOrderProductsBody["orders"];
      List<MyOrderProductListModel> featureProductList = myOrderProductsList
          .map((c) => new MyOrderProductListModel.fromMapForMyOrderProductList(c))
          .toList();
      return {
        'errorCode': "0",
        'value': featureProductList,
      };
    } else {
      return {'errorCode': "-1", 'msg': "Status Code Error"};
    }

  }
}
