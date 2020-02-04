import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class ChangePasswordParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body["Success"] == "0") {

          String mMessage=body["Message"];

          return {
            'errorCode': 0,
            'value': mMessage.toString(),
          };
        } else {
          String mMessage=body["Message"];
          return {
            'errorCode': -1,
            'value': mMessage.toString(),
          };
        }
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }


}
