import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/RewardPointModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class ProductReviewListParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        Map downloadAbleProduct = body["ProductReviews"];

        RewardPointModel mRewardPointModel = RewardPointModel.fromMapForProductReviewList(downloadAbleProduct);

        return {'errorCode' : "0",'value' : mRewardPointModel,};
      }else{
        return {'errorCode' : "-1",'msg':"Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode' : "-1",'msg':"$e"};
    }
  }
}
