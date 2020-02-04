import 'dart:convert';

import 'package:http/http.dart' as http;

class JsonParser {
  static Future<List<Map<String, dynamic>>> fetchPost() async {
      var response = await http.get('https://jsonplaceholder.typicode.com/posts');

      List list = json.decode(response.body);

      List<Map<String, dynamic>> mapList = new List();
      for (int i = 0; i < list.length; i++) {
        mapList.add(list[i]);
      }

      return mapList;
  }
}
