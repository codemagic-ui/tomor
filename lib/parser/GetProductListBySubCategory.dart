import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class GetProductListBySubCategory {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body.containsKey('errors')) {
          return {
            'errorCode': '0',
            'value': 'fail',
          };
        } else {
          List list = new List();
          if(body.containsKey('products')){
            list = body['products'];
          }
          else if(body.containsKey('ProductsFromParentcategory')) {
            list = body['ProductsFromParentcategory'];
          }

          List<ProductListModel> productModelList = list.map((c) => new ProductListModel.fromMapForSubcategoryProductList(c)).toList();
          return {
            'errorCode': '0',
            'value': productModelList,
          };
        }
      } else {
        return {'errorCode': '-1', 'msg': 'Status Code Error'};
      }
    } catch (e) {
      print(e);
      return {'errorCode': '-1', 'msg': '$e'};
    }
  }

  static Future callApiAscending(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body.containsKey('errors')) {
          return {
            'errorCode': '0',
            'value': 'fail',
          };
        } else {
          List list = body['ProductsFromParentcategory'];
          List<ProductListModel> productModelList = list.map((c) => new ProductListModel.fromMapForSubcategoryProductList(c)).toList();
          return {
            'errorCode': '0',
            'value': productModelList,
          };
        }
      } else {
        return {'errorCode': '-1', 'msg': 'Status Code Error'};
      }
    } catch (e) {
      print(e);
      return {'errorCode': '-1', 'msg': '$e'};
    }
  }
}
