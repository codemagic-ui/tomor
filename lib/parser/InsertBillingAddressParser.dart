import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class InsertBillingAddressParser{
  static Future callApi(String url,String strJson) async {
    final response = await http.post(url, headers: Config.httpPostHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if(body["Succcess"] == "0"){
          return {'errorCode' : 0,'value' : "",};
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