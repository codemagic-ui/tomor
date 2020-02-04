import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class SearchProductParser {
  static Future callApi(String url) async {
    final response =
        await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body.containsKey("SearchProducts")) {
          List searchedList = body["SearchProducts"];
          List<ProductListModel> list = searchedList
              .map((c) => new ProductListModel.fromMapForSearchProductsList(c))
              .toList();
          return {'errorCode': "0", 'value': list};
        } else if (body.containsKey("errors")) {
          List errors = body["errors"];
          String msg = "";
          if (errors.length != 0) {
            msg = errors[0];
          }
          return {'errorCode': "-1", 'msg': msg};
        }
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future searchCallApi(String url, var strJson) async {
    var client = new http.Client();

    Map body2 = json.decode(strJson);

    http.Response response = await client.post(url, headers: Config.httpPostHeaderForEncode, body: body2, encoding: Encoding.getByName("utf-8"));

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        List searchList=body['pro'];
        List<ProductListModel> list = searchList.map((c) => new ProductListModel.fromMapForSearchProductsList(c)).toList();
        return {'errorCode': "0",'value': list};
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
