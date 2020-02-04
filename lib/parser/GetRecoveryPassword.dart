import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class GetRecoveryPassword {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map msgBody = json.decode(response.body);
        String message=msgBody['message'].toString();
        return {
          'errorCode': "0",
          'value': message,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
