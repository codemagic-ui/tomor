import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class GetEditProfileInfo {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.
        body);
        if (body.containsKey("customers") && body["customers"] != null) {
          List customers = body["customers"];
          String company = "";
          Map customer = customers[0];
          if (body.containsKey("billing_address") &&
              body["billing_address"] != null) {
            Map billingAddress = customers[0]['billing_address'];
            company = billingAddress['company'];
          }
          UserModel userModel = UserModel.fromMap(customer);

          return {
            'errorCode': "0",
            'value': [userModel, company],
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

  static Future callApiForUpdateUser(String url, String strJson) async {
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
        if (body.containsKey('errorcode') && body['errorcode'] == "0") {
          String message = body['message'].toString();
          return {
            'errorCode': "0",
            'value': message,
          };
        } else {
          String message = body['message'].toString();
          return {
            'errorCode': "0",
            'value': message,
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
