import 'dart:async';
import 'dart:convert';
import 'package:i_am_a_student/models/NewsListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

import 'package:http/http.dart' as http;

class NewsListParser {
  static Future callApi(String url) async {
    final response = await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
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
          //todo parse here


          Map newsMap = body["News"];
          List newsItemsList = newsMap["NewsItems"];
          List<NewsListModel> newsModelList =
              newsItemsList.map((c) => new NewsListModel.fromMap(c)).toList();

          return {
            'errorCode': "0",
            'value': newsModelList,
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
