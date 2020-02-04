import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class UserLoginParser {
  static Future callApi(String url) async {
    final response =
        await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body["Success"] == "0") {
          int customerID = body["CustomerId"];
          return {
            'errorCode': "0",
            'value': customerID,
          };
        } else {
          String errorMsg = body['Message'];
          return {
            'errorCode': -1,
            'value': errorMsg,
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

  static Future callApiForRegistration(String url) async {
    final response = await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
print(["BODY", statusCode]);
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body.containsKey("errors")) {
          return {
            'errorCode': "0",
            'value': "fail",
          };
        } else {
          UserModel userModel = UserModel.userForRegistrationFromMap(body);

          return {
            'errorCode': "0",
            'value': userModel,
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
