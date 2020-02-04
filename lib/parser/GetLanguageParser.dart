import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/LanguageModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class GetLanguageParser{
  static Future getLanguageParser(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    print([response.body]);

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body.containsKey("errors")) {
          return {
            'errorCode': "0",
            'value': "fail",
          };
        } else {
          List list = body["Languages"];
          List<LanguageModel> languageList = list
              .map((c) => new LanguageModel.fromMap(c))
              .toList();
          return {
            'errorCode': "0",
            'value': languageList,
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