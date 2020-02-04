import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class CheckConditionalAttributeParser{
  static Future callApi(String url) async {
    final response = await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body.containsKey("disabledattributemappingids")) {
          List<String> ids = new List<String>();
          List disableAttributeIdList = body["disabledattributemappingids"];
          for(int i = 0; i< disableAttributeIdList.length ; i++){
            ids.add(disableAttributeIdList[i].toString());
          }
          return {
            'errorCode': 0,
            'value': ids,
          };
        } else {
          String mMessage=body["Message"];
          return {
            'errorCode': -1,
            'value': mMessage.toString(),
          };
        }
      } else {
        return {'errorCode': "-1", 'value': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'value': "$e"};
    }
  }
}