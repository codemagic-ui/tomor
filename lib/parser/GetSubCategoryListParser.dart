import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/CategoryListModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class GetSubCategoryListParser {
  static Future callApi(String url, int parentCategoryId) async {
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
          List categories = body["categories"];
          List mainCategories = new List();
          for (int i = 0; i < categories.length; i++) {
            Map<String, dynamic> map = categories[i];
            if (map['parent_category_id'] == parentCategoryId) {
              mainCategories.add(map);
            }
          }
          categories.clear();
          categories.addAll(mainCategories);
          List<CategoryListModel> categoryModelList = categories.map((c) => new CategoryListModel.fromMap(c)).toList();
          return {
            'errorCode': "0",
            'value': categoryModelList,
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
