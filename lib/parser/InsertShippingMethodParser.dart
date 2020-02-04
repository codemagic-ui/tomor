import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/PaymentMethodModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class InsertShippingMethodParser{
  static Future callApi(String url,String strJson) async {
//    final response = await http.post(url, body: strJson,headers: Config.httpPostHeader);
    final response = await http.post(url, headers: Config.httpPostHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if(body["Success"] == "0"){
          Map paymentMethodList = body["PaymentMethodList"];
          List paymentMethods = paymentMethodList["PaymentMethods"];
          List<PaymentMethodModel> paymentMethodModelList = paymentMethods.map((c) => new PaymentMethodModel.fromMap(c)).toList();
          return {'errorCode' : 0,'value' : paymentMethodModelList,};
        }else {
          return {'errorCode' : -1,'value' : ""};
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