import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/AdvancedSearchAttributeModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class GetAdvanceSearchAttributeParser{
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body.containsKey("errors")) {
          return {
            'errorCode': "0",
            'value': "fail",
          };
        } else {
          Map map = body["AdvancedSearchList"];
          AdvancedSearchAttributeModel advancedSearchAttributeModel = AdvancedSearchAttributeModel.fromMap(map);
          return {
            'errorCode': "0",
            'value': advancedSearchAttributeModel,
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