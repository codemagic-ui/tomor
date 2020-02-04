import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class ContactUsParser {
  static Future callApi(String url,String strJson) async {
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

        if (body["Success"] == "0") {
          Map mContacUsModel = body['ContacUsModel'];

          String mMessage = mContacUsModel["Result"];

          return {
            'errorCode': 0,
            'value': mMessage.toString(),
          };
        } else {
          Map mContacUsModel = body['ContacUsModel'];

          String mMessage = mContacUsModel["Result"];
          return {
            'errorCode': -1,
            'value': mMessage.toString(),
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
