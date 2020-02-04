import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class UserRegistrationPassword {
  static Future userRegistration(String url, var strJson) async {
    var client = new http.Client();

    Map body = json.decode(strJson);

    http.Response response = await client.post(url,
        headers: Config.httpPostHeaderForEncode,
        body: body,
        encoding: Encoding.getByName("utf-8"));

    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body["Success"] == "0") {
          var customerId = body['CustomerId'];
          String errorMsg = body['Message'];
          return {
            'errorCode': 0,
            'value': [customerId,errorMsg],
          };
        } else {
          String errorMsg = body['Message'];
          return {
            'errorCode': -1,
            'value':errorMsg,
          };
        }
      } else {
        return {
          'errorCode': "1",
          'value': "fail",
        };
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
