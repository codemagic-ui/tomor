import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class BrandListParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map featuredProductsBody = json.decode(response.body);
        List featuredProductsList = featuredProductsBody["ManufacturerList"];
        List<ProductListModel> featureProductList = featuredProductsList
            .map((c) => new ProductListModel.fromMapForBrandList(c))
            .toList();
        return {
          'errorCode': "0",
          'value': featureProductList,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
