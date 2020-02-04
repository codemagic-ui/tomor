import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/RewardPointModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class RewardListParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map rewardPointProductsBody = json.decode(response.body);
        Map rewardPointProductsMap = rewardPointProductsBody["RewardPointList"];
        RewardPointModel featureProductMap = new RewardPointModel.fromMapForRewardPointList(rewardPointProductsMap);
        return {
          'errorCode': "0",
          'value': featureProductMap,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }
}
