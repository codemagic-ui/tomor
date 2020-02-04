import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/ShippingCartAttributeModel.dart';
import 'package:i_am_a_student/models/ShoppingModel/ShoppingCartAttributeModel.dart';
import 'package:i_am_a_student/utils/Config.dart';

class AddProductIntoCartParser {
  static String msg;

  static Future callApi(String url,String strJson) async {
    final response = await http.post(url, body: strJson, headers: Config.httpPostHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
//        Map body = json.decode(response.body);
        return {'errorCode' : 0,'value' : "",};
      } else {
        return {'errorCode': -1, 'value': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': -1, 'value': "$e"};
    }
  }

  static Future callApi2(String url) async {
    final response = await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if(body.containsKey("Success")){
          if(body["Success"]){
            if(body["Message"]!=null)
              {
                 msg = body["Message"].toString();
              }
            else{
               msg = body["message"].toString();
            }
            return {'errorCode' : "0",'value' : msg,};
          }else{
            if(body['Message']!=null)
            {
              msg = body["Message"].toString();

            }
            else if(body['message']!=null){
              msg = body["message"].toString();
            }
            return {'errorCode' : "-1",'value' : msg,};
          }
        }else{
          if(body['Message']!=null)
          {
            msg = body["Message"].toString();

          }
          else if(body['message']!=null){
            msg = body["message"].toString();
          }
          return {'errorCode' : "-1",'value' : msg,};
          //${msg[0]},${msg[1]}
        }
      } else {
        return {'errorCode': "-1", 'value': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'value': "$e"};
    }
  }

  static Future callApi3(String url) async {
    final response = await http.get(Uri.encodeFull(url), headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if(body.containsKey("Success")){
          if(body["Success"]){
            String msg = body["Message"];
            return {'errorCode' : "0",'value' : msg,};
          }else{
            List msg = body["Message"];
            return {'errorCode' : "-1",'msg' : "${msg[0]},${msg[1]}",};
          }
        }else{
          List msg = body["Message"];
          return {'errorCode' : "-1",'msg' : "${msg[0]},${msg[1]}",};
        }
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future callApiCartItemIncrese(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        if (body.containsKey("Success")) {
          return {
            'errorCode': "0",
            'value': "",
          };
        } else {
          List message = body["message"];
          return {
            'errorCode': "-1",
            'msg': "${message[0]},${message[1]}",
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

  static Future callApiDelete(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        String msg = body["message"];
        return {'errorCode' : "0",'value' : msg,};
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future callApiDecrease(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
//        Map body = json.decode(response.body);
        return {'errorCode' : "0",'value' : "",};
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future callApiGiftWrap(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
       Map body = json.decode(response.body);
        return {'errorCode' : "0",'value' : body["isApplied"],};
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future callApiForGetCartItemTotal(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;

    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);
        List message = body["shopping_carts"];
        return {'errorCode': "0", 'value': message.length};
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future callApiForGetShoppingAttributes(String url) async {
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
          Map list = body["ShoppingCartSettings"];
          ShoppingCartAttributeModel mShoppingCartAttributeModel = ShoppingCartAttributeModel.fromMapShopping(list);
          return {
            'errorCode': "0",
            'value': mShoppingCartAttributeModel,
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

  static Future callApiForGetShippingAttributes(String url) async {
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
          Map list = body["ShippingSetting"];
          ShippingCartAttributeModel mShoppingCartAttributeModel = ShippingCartAttributeModel.fromMapShipping(list);
          return {
            'errorCode': "0",
            'value': mShoppingCartAttributeModel,
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
