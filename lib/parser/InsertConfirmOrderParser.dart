import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/utils/Config.dart';

class InsertConfirmOrderParser {
  static Future callApi(String url) async {
//    final response = await http.post(url, headers: Config.httpPostHeader);
    final response = await http.post(url, headers: Config.httpPostHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body["Success"] == "0") {
          Map dd = body["dd"];
          Map checkoutCompleteResponses = dd["CheckoutCompleteResponses"];
          var orderId = checkoutCompleteResponses["OrderId"];
          return {
            'errorCode': 0,
            'value': orderId,
          };
        } else if(body.containsKey("errorsList")){
          Map bodyError=body["errorsList"];
          List errorList=bodyError['Warnings'];
          String messageError=errorList[0].toString();
          return {
            'errorCode': -1,
            'value': messageError,
          };
        } else {
          return {
            'errorCode': -1,
            'value': "Something want wrong",
          };
        }
      } else {
        return {'errorCode': -1, 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': -1, 'msg': "$e"};
    }
  }

  static Future callApiForReOrder(String url) async {
    final response = await http.get(url, headers: Config.  httpPostHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body["Success"] == "0") {
          return {
            'errorCode': 0,
            'value': "",
          };
        } else {
          return {
            'errorCode': -1,
            'value': "",
          };
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
