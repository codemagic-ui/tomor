import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ShippingMethodModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class InsertShippingAddressParser{
  static Future callApi(String url,String strJson) async {
//    final response = await http.post(url, body: strJson,headers: Config.httpPostHeader);
    final response = await http.post(url, headers: Config.httpPostHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if(body["Success"] == "0"){
          Map shippingMethodList = body["ShippingMethodList"];
          List shippingMethods = shippingMethodList["ShippingMethods"];
          List<ShippingMethodModel> shippingMethodModelList = shippingMethods.map((c) => new ShippingMethodModel.fromMap(c)).toList();
          return {'errorCode' : 0,'value' : shippingMethodModelList,};
        }else {
          return {'errorCode' : -1,'value' : "",};
        }
      } else {
        return {'errorCode': -1, 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': -1, 'msg': "$e"};
    }
  }
}