import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:i_am_a_student/models/AddressModel/AddressModel.dart';
import 'package:i_am_a_student/models/CouponCodeModel.dart';
import 'package:i_am_a_student/models/ShoppingModel/EstimateShippingMethod.dart';
import 'package:i_am_a_student/models/ShoppingModel/GiftCodeCard.dart';
import 'package:i_am_a_student/utils/Config.dart';

class CustomerAddressListParser {
  static Future callApi(String url) async {
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
          List list = body["Addresses"];
          List<AddressModel> addressModelList =
              list.map((c) => new AddressModel.fromMap(c)).toList();
          return {
            'errorCode': "0",
            'value': addressModelList,
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

  static Future callApiForDeleteAddress(String url) async {
    final response = await http.get(url, headers: Config.httpGetHeader);
    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        return {
          'errorCode': "0",
          'value': "done",
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future callApiForGetStates(String url) async {
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
          List stateList = body["StateList"];
          return {
            'errorCode': "0",
            'value': stateList,
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

  static Future callApiForGetContry(String url) async {
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
          Map countryMap = body['AddressAttributeList'];
          Map addressMap = countryMap['Address'];
          List availableCountriesList = addressMap["AvailableCountries"];

          return {
            'errorCode': "0",
            'value': availableCountriesList,
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

  static Future insertIntoAddress(String url, var strJson) async {
    var client = new http.Client();
    Map body = json.decode(strJson);
    http.Response response = await client.post(url, headers: Config.httpPostHeaderForEncode, body: body);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        return {
          'errorCode': "0",
          'value': "done",
        };
      } else {
        return {
          'errorCode': "1",
          'value': "fail",
        };
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future insertIntoEditAddress(String url, var strJson) async {
    var client = new http.Client();
    Map body = json.decode(strJson);
    http.Response response = await client.post(url, headers: Config.httpPostHeaderForEncode, body: body);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        return {
          'errorCode': "0",
          'value': "done",
        };
      } else {
        return {
          'errorCode': "1",
          'value': "fail",
        };
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future estimateShippingClick(String url) async {
    var client = new http.Client();

    http.Response response =
        await client.get(url, headers: Config.httpPostHeader);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        Map mEstimateShippingMethod = body['EstimateShippingMethod'];
        List mShippingOptions = mEstimateShippingMethod['ShippingOptions'];

        List<EstimateShippingMethod> estimateShippingList = mShippingOptions
            .map((c) =>
                new EstimateShippingMethod.fromMapEstimateShippingMethod(c))
            .toList();

        return {
          'errorCode': 0,
          'value': estimateShippingList,
        };
      } else {
        return {'errorCode': "-1", 'msg': "Status Code Error"};
      }
    } catch (e) {
      print(e);
      return {'errorCode': "-1", 'msg': "$e"};
    }
  }

  static Future applyCouponCode(String url) async {
    var client = new http.Client();

    http.Response response =
        await client.get(url, headers: Config.httpPostHeader);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body["Success"] == "0") {
          List mCurrentCode = body["CurrentCode"];

          List<CouponCodeModel> addCouponList = mCurrentCode
              .map((c) => new CouponCodeModel.fromMapCoupon(c))
              .toList();

          return {
            'errorCode': 0,
            'value': addCouponList,
          };
        } else {
          return {
            'errorCode': -1,
            'value': "",
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

  static Future applyGiftCode(String url) async {
    var client = new http.Client();

    http.Response response =
    await client.get(url, headers: Config.httpPostHeader);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body["Success"] == "0") {
          String errorMessage= body["Message"] ;

          return {
            'errorCode': 0,
            'value': errorMessage.toString(),
          };
        } else {
          String errorMessage= body["Message"] ;
          return {
            'errorCode': -1,
            'value': errorMessage,
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


  static Future appliedCouponCode(String url) async {
    var client = new http.Client();

    http.Response response =
        await client.get(url, headers: Config.httpPostHeader);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body["Success"] == "0") {
          List mCurrentCode = body["CurrentCode"];

          List<CouponCodeModel> addCouponList = mCurrentCode
              .map((c) => new CouponCodeModel.fromMapCoupon(c))
              .toList();

          return {
            'errorCode': 0,
            'value': addCouponList,
          };
        } else {
          return {
            'errorCode': -1,
            'value': "",
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

  static Future appliedGiftCard(String url) async {
    var client = new http.Client();

    http.Response response = await client.get(url, headers: Config.httpPostHeader);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body["Success"] == "0") {
          List mCurrentCode = body["GiftCardCode"];

          List<GiftCodeCard> addGiftCodeCard = mCurrentCode
              .map((c) => new GiftCodeCard.fromMapGiftCodeCard(c))
              .toList();

          return {
            'errorCode': 0,
            'value': addGiftCodeCard,
          };
        } else {
          String errorMessage= body["Message"].toString();
          return {
            'errorCode': -1,
            'value': errorMessage.toString(),
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


  static Future removeCouponCode(String url) async {
    var client = new http.Client();

    http.Response response =
        await client.get(url, headers: Config.httpPostHeader);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body["Success"] == "0") {
          String mCurrentCode = body["Message"];



          return {
            'errorCode': 0,
            'value': mCurrentCode,
          };
        } else {
          return {
            'errorCode': -1,
            'value': "",
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
  static Future removeGiftCode(String url) async {
    var client = new http.Client();

    http.Response response =
    await client.get(url, headers: Config.httpPostHeader);

    final statusCode = response.statusCode;
    try {
      if (statusCode == 200) {
        Map body = json.decode(response.body);

        if (body["Success"] == "0") {

          String mCurrentCode = body["Message"];



          return {
            'errorCode': 0,
            'value': mCurrentCode,
          };
        } else {
          String mCurrentCode = body["Message"];
          return {
            'errorCode': -1,
            'value': mCurrentCode.toString(),
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
