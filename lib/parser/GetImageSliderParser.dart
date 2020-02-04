import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ImageSliderModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class GetImageSliderParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        Map mapSliderImages = body['NivoSliderImages'];
        ImageSliderModel mSliderImages = new ImageSliderModel.fromMap(mapSliderImages)   ;
        return {
          'errorCode': "0",
          'value': mSliderImages,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
