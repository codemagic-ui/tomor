import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class GetLogoAndColorParser{
  static Future getLogoAndColorParser(String url) async {
    final response = await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body["Success"] == "0") {
          String color = body['ColorInfo'].toString();
          String logo = body['LogoUrl'].toString();
          return {
            'errorCode': 0,
            'value': [color,logo],
          };
        } else {
          return {
            'errorCode': -1,
            'value': "",
          };
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