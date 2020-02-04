import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class MyAccountDetailParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        List customers = body["customers"];
        Map customer = customers[0];

        UserModel userModel = UserModel.fromMap(customer);

        return {
          'errorCode': "0",
          'value': userModel,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
