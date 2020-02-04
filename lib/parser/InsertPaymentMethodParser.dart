import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class InsertPaymentMethodParser {
  static Future callApi(String url, String strJson) async {
//    final response = await http.post(url, body: strJson,headers: Config.httpPostHeader);
    final response = await http.post(url, headers: Config.httpPostHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body["Success"] == "0") {
          return {'errorCode': 0, 'value': "",};
        } else {
          return {'errorCode': -1, 'value': body["Message"],};
        }
      } else {
        return {'errorCode': -1, 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': -1, 'msg': "$e"};
    }
  }

  static Future callApiforInfo(String s) async {
    final response = await http.get(
        Uri.encodeFull(s), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    if (statusCode == 200) {
      Map body = json.decode(response.body);
      Map payinfo = body['Paymentinfopage'];
      String mMessage = payinfo["PaymentMethodDescription"];

      return {
        'errorCode': 0,
        'value': mMessage.toString(),
      };
    }else{
      return {
        'errorCode': -1,
        'value': "Info not found",
      };
    }
  }
}