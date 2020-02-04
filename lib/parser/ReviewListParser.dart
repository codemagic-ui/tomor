import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ProductReviewModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class ReviewListParser {
  static Future callApi(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map mProductReviewsListBody = json.decode(response.body);
        Map mProductReviewsList=mProductReviewsListBody['ProductReviewsList'];
        List reviewItems = mProductReviewsList["Items"];
        List<ProductReviewModel> addCartProductList = reviewItems.map((c) => new ProductReviewModel.fromMapForReviewList(c)).toList();
        return {
          'errorCode': "0",
          'value': addCartProductList,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future callApiPostReview(String url ,String strJson) async {
    Map body = json.decode(strJson);
//    final response = await http.post(url,headers: Config.httpPostHeader);
    final response = await http.post(url, body: body,headers: Config.httpPostHeaderForEncode);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if(body["Success"] == "0"){
          String msg = body["Message"];
          return {'errorCode' : 0,'value' : msg,};
        }else {
          String msg = body["Message"];
          return {'errorCode' : -1,'value' : msg,};
        }
      } else {
        return {'errorCode': -1, 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': -1, 'msg': "$e"};
    }
  }

  static Future callApiForLike(String url ) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if(body["Success"] == "0"){

          String mResult=body['Result'];
          return {'errorCode' : 0,'value' : mResult.toString(),};
        }else {
          String mResult=body['Result'];
          return {'errorCode' : -1,'value' : mResult.toString(),};
        }
      } else {
        return {'errorCode': -1, 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': -1, 'msg': "$e"};
    }
  }
}
