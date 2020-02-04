import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ResourceString.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageParser {
  static Future languageParser(String url) async {
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
          List list = body["List"];
          List<ResourceString> languageList =
              list.map((c) => new ResourceString.fromMap(c)).toList();
          Map<String, String> hashMap = new Map<String, String>();
          for (Map m in list) {
            String key = m["ResourceName"].toString().toLowerCase();
            String value = m["ResourceValue"].toString();
            hashMap[key] = value;
          }
          String data = json.encode(hashMap);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(Constants.prefMap, data);
          await ResourceString.setIntoLanguageString(languageList);
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
