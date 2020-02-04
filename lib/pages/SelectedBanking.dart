import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/CartProductListModel.dart';
import 'package:i_am_a_student/pages/HomeScreen.dart';
import 'package:i_am_a_student/pages/OrderPlacedSuccess.dart';
import 'package:i_am_a_student/parser/InsertPaymentMethodParser.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ConfirmOrderScreen.dart';

class SelectedBanking extends StatefulWidget {

  final String mTitle;
  final String orderId;
  final String mCartProductInfo;
  final String strShippingMethodName;
  final double orderTotalDecimal;
  final String systemName;
  final List<CartProductListModel> cartItemList;
  final List<String> creditcardtypes = ["Visa","Master card","Discover","Amex"];
  final List<String> debitcardtypes = ["Visa","Master card","Discover","Amex"];


  SelectedBanking(
      {this.mTitle,
        this.mCartProductInfo,
        this.orderId,
        this.strShippingMethodName,
        this.orderTotalDecimal,
        this.cartItemList, this.systemName});
  @override
  _SelectedBankingState createState() => _SelectedBankingState();
}

class _SelectedBankingState extends State<SelectedBanking> {

  static const platform = const MethodChannel("Payment_SeamLess_With_PayuBizz");

  List<String> mBankList;
  List<String> mCardList;
  PageController controller;
  int currentpage = 0;

  TextEditingController cardHolderNameController = new TextEditingController();
  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController cardExpireMonthController = new TextEditingController();
  TextEditingController cardExpireYearController = new TextEditingController();
  TextEditingController cardCVVController = new TextEditingController();

  var formValidationKeyForCreditDebit = new GlobalKey<FormState>();

  int customerId;

  bool isCreditCard = true;

  Map<String, String> cardDetail;

  var Cardtype="Visa";

  var currentPage;

  String paymentinfo;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.mTitle)),
        body: layouts(),
        bottomSheet: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: MaterialBtn(
            onPressed: (){
              onClickPayNow();
            },
            text: widget.mTitle!="Check / Money Order"?"Pay Now".toUpperCase():"Next".toUpperCase(),
            padding: 20.0,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    callApi();
    SystemChrome.setEnabledSystemUIOverlays([]);
    controller = new PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 0.5,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  layouts() {
    switch (widget.mTitle) {
      case "NetBanking":
        {

        }
        break;
      case "Credit Card":
        {
          return mCreditCard();
        }
        break;
      case "Check / Money Order":
        {
          return mOneyOrder();
        }
        break;
      case "DebitCard":
        {}
        break;
      case "CashCard":
        {}
        break;
      case "Wallet":
        {}
        break;
      case "UPI":
        {}
        break;
      case "GoogleTEZ":
        {}
        break;
      case "EMI":
        {}
        break;
      case "IMPS / NEFT":
        {}
        break;
    }
  }

  callApi() async {
 //   await banking();
 //   await cardList();
    if(widget.mTitle=="Check / Money Order"){
      callAPIforpaymentInfo();
    }
  }


  Widget mCreditCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom:60.0),
      child: ListView(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            new Container(
              color: AppColor.appColor,
              height: 120.0,
              width: double.infinity,
              child: new Center(
                child: new Container(
                  child: new PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentpage = value;
                          isCreditCard = !isCreditCard;
                        });
                      },
                      controller: controller,
                      itemCount: 2,
                      itemBuilder: (context, index) => builder(index)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Body1Text(text: "Card Type"),
            ),
            new Card(
              child: Container(
                height: 60.0,
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    isExpanded: true,
                    hint: new Text("Choose card"),
                    value: Cardtype,
                    onChanged: (String newValue) {
                      setState(() {
                        Cardtype = newValue;
                      });
                    },
                    items: <String>["Visa","Master card","Discover","Amex"]
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value,
                          style: new TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: formValidationKeyForCreditDebit,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Body1Text(
                      text: currentpage == 0
                          ? "CREDIT CARD DETAILS"
                          : "DEBIT CARD DETAIL"),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 60.0,
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: TextFormField(
                        controller: cardHolderNameController,
                        decoration:
                            InputDecoration.collapsed(hintText: "Card Holder Name"),
                        validator: (value){
                          if(value.isEmpty){
                            return "Enter Card Holer Name";
                          }
                         // return "";
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 60.0,
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: TextFormField(
                        controller: cardNumberController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: new InputDecoration(
                          suffixIcon: new Image.asset(
                            "images/craditcard.png",
                            height: 25.0,
                            width: 25.0,
                          ),
                          border: InputBorder.none,
                          hintText: "Card Number",
                          hintStyle: const TextStyle(fontSize: 15.0),
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return "Enter Card Number";
                          }else if(value.length != 16){
                            return "Enter Valid Card Number";
                          }
                         // return "";
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 60.0,
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child: TextFormField(
                                    controller: cardExpireMonthController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    decoration: InputDecoration.collapsed(hintText: "Month"),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Enter Month";
                                      }else if(int.parse(value) == 0 || int.parse(value) > 12){
                                        return "Enter Valid Month";
                                      }
                                     // return "";
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TitleText(text: "/"),
                            ),
                            Expanded(
                              child: Container(
                                height: 60.0,
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child: TextFormField(
                                    controller: cardExpireYearController,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecoration.collapsed(hintText: "Year"),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Enter Year";
                                      }
                                    //  return "";
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 60.0,
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: TextFormField(
                        controller: cardCVVController,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          suffixIcon: Icon(Icons.album),
                          border: InputBorder.none,
                          hintText: "CVV Code",
                          hintStyle: const TextStyle(fontSize: 15.0),
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return "Enter CVV Code";
                          }
                         // return "";
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }

  Widget builder(int index) {
    return new AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return new Center(
          child: new SizedBox(
            height: Curves.easeOut.transform(value) * 150,
            width: Curves.easeOut.transform(value) * 250,
            child: Center(
                child: TitleText(
              text: index == 0 ? "CREDIT CARD" : "DEBIT CARD",
              color: AppColor.white,
            )),
          ),
        );
      },
      child: new Container(
        margin: const EdgeInsets.all(8.0),
        color: index % 2 == 0 ? Colors.blue : Colors.red,
      ),
    );
  }

  Future banking() async {
    mBankList = new List<String>();
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/AB.png");

    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/AXIS.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/CANARA.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/CITI.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/HDFC.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/ICICI.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/IDBI.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/IOB.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/KMB.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/PNB.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/SBI.png");
    mBankList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/YES BANK.png");
  }

  Future cardList() async {
    mCardList = new List<String>();
    mCardList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/visa master.png");
    mCardList.add(
        "https://www.imastudent.com/Plugins/Payments.Payubiz/Content/images/AEX.png");
  }

  void onClickPayNow(){
     creditDebitCard();
     if(widget.mTitle=="Check / Money Order"){
       callAPIforpaymentInfoPayNow();
     }
  }

  void creditDebitCard() async{
    if ((formValidationKeyForCreditDebit.currentState.validate())) {
      String cardName = cardHolderNameController.text;
      String cardNumber = cardNumberController.text;
      String cardExpireMonth = cardExpireMonthController.text;
      String cardExpireYear = cardExpireYearController.text;
      String cardCVV = cardCVVController.text;

      Map<String, dynamic> paymentParams = {
        "merchantKey": "ZM01iJ",
        "salt": "mBWYbX6P",
        "isInProductionMode": false,
        "firstName": "Vithani",
        "email": "abc@gmail.com",
        "phone": "1234567890",
        "productInfo": "T-Shirt",
        "amount": 10.0,
        "sUrl": "https://payu.herokuapp.com/success",
        "fUrl": "https://payu.herokuapp.com/failure",
        "UTF1": "",
        "UTF2": "",
        "UTF3": "",
        "UTF4": "",
        "UTF5": "",
        "txnId": "abc1011",
      };

      if (isCreditCard) {
        cardDetail = {
          "cardName": "Visa",
          "cardHolderName": cardName,
          "cardNumber": cardNumber,
          "cardExpireMonth": cardExpireMonth,
          "cardExpireYear": cardExpireYear,
          "cardCVV": cardCVV,
        };
      } else {
        cardDetail = {
          "cardName": "Visa",
          "cardHolderName": cardName,
          "cardNumber": cardNumber,
          "cardExpireMonth": cardExpireMonth,
          "cardExpireYear": cardExpireYear,
          "cardCVV": cardCVV,
        };
      }
      Map<String, dynamic> productDetail = {
        "Name": "Product Name",
        "Price": 10.0,
        "Id": "abc1010"
      };

      await onClickPay(
          widget.systemName, isCreditCard ? "CreditCard" : "DabitCard");

      var result = await platform.invokeMethod(
          'creditDebitCard', [cardDetail, productDetail, paymentParams]);
      print(result);
      Map getResponse = result;

      if (getResponse.containsKey("cancel")) {
        navigatePushAndRemoveUntil(HomeScreen());
      } else {
        if (getResponse.containsKey("response")) {
          String response = getResponse['response'];
        }
        if (getResponse.containsKey("id")) {
          String id = getResponse['id'];
        }
        if (getResponse.containsKey("key")) {
          String key = getResponse['key'];
        }
        if (getResponse.containsKey("txnId")) {
          String txnId = getResponse['txnId'];
        }
        if (getResponse.containsKey("transaction_fee")) {
          String transaction_fee = getResponse['transaction_fee'];
        }
        if (getResponse.containsKey("hash")) {
          String hash = getResponse['hash'];
        }
        if (getResponse.containsKey("status")) {
          String status = getResponse['status'];
        }
        if (getResponse.containsKey("productInfo")) {
          String productInfo = getResponse['productInfo'];
        }
        if (getResponse.containsKey("amount")) {
          String amount = getResponse['amount'];
        }
        if (getResponse.containsKey("bank_ref_no")) {
          String bank_ref_no = getResponse['bank_ref_no'];
        }
        if (getResponse.containsKey("payment_source")) {
          String payment_source = getResponse['payment_source'];
        }
      }
    }
}
  Future onClickPay(String paymentMethodSystemName, String name) async {
    await getPreferences();
    Map encode = {"paymentmethod": paymentMethodSystemName};
    String strJson = json.encode(encode);
    Map result = await InsertPaymentMethodParser.callApi(
        "${Config.strBaseURL}checkouts/selectpaymentmethod?paymentmethod=$paymentMethodSystemName&UseRewardPoints=false&customerId=$customerId",
        strJson);
    if (result["errorCode"] == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ConfirmOrderScreen(
        systemName: paymentMethodSystemName,
        strShippingMethodName: widget.strShippingMethodName,
        strPaymentMethodName: "$name",
        cartItemList: widget.cartItemList,
      )));
      /*navigatePushforConfirm(ConfirmOrderScreen(
        systemName: paymentMethodSystemName,
        strShippingMethodName: widget.strShippingMethodName,
        strPaymentMethodName: "$name",
        cartItemList: widget.cartItemList,
      ));*/
    } else {
      Fluttertoast.showToast(msg: result["value"]);
    }
  }



    void navigatePushAndRemoveUntil(HomeScreen homeScreen) {
  navigatePushAndRemoveUntil(homeScreen);}


  Future getPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
  }

 /* void navigatePushforConfirm(ConfirmOrderScreen confirmOrderScreen) {
    navigatePushforConfirm(confirmOrderScreen);
  }*/

  Widget forCreditCard() {
    return ListView(shrinkWrap: true, primary: false, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Body1Text(text: "Card Type"),
      ),
      new Card(
        child: Container(
          height: 60.0,
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              isExpanded: true,
              hint: new Text("Choose card"),
              value: Cardtype,
              onChanged: (String newValue) {
                setState(() {
                  Cardtype = newValue;
                });
              },
              items: <String>["Visa","Master card","Discover","Amex"]
                  .map((String user) {
                return new DropdownMenuItem<String>(
                  value: user,
                  child: new Text(user,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      Form(
        key: formValidationKeyForCreditDebit,
        child: new ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            Body1Text(
                text: currentPage == 0
                    ? "CREDIT CARD DETAILS"
                    : "DEBIT CARD DETAIL"),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 60.0,
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Center(
                child: TextFormField(
                  controller: cardHolderNameController,
                  decoration:
                  InputDecoration.collapsed(hintText: "Card Holder Name"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Card Holer Name";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 60.0,
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Center(
                child: TextFormField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: new InputDecoration(
                    suffixIcon: new Image.asset(
                      "images/payment/craditcard.png",
                      height: 25.0,
                      width: 25.0,
                    ),
                    border: InputBorder.none,
                    hintText: "Card Number",
                    hintStyle: const TextStyle(fontSize: 15.0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Card Number";
                    } else if (value.length != 16) {
                      return "Enter Valid Card Number";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 60.0,
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                            child: TextFormField(
                              controller: cardExpireMonthController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration:
                              InputDecoration.collapsed(hintText: "Month"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter Month";
                                } else if (int.parse(value) == 0 ||
                                    int.parse(value) > 12) {
                                  return "Enter Valid Month";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TitleText(text: "/"),
                      ),
                      Expanded(
                        child: Container(
                          height: 60.0,
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                            child: TextFormField(
                              controller: cardExpireYearController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration:
                              InputDecoration.collapsed(hintText: "Year"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter Year";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 60.0,
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Center(
                child: TextFormField(
                  controller: cardCVVController,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    suffixIcon: Icon(Icons.album),
                    border: InputBorder.none,
                    hintText: "CVV Code",
                    hintStyle: const TextStyle(fontSize: 15.0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter CVV Code";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height / 4),
    ]);
  }

   Widget mOneyOrder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Scaffold(
        body: Html(
          data: paymentinfo!=null? paymentinfo: "",
        ),
      ),
    );
  }

  Future callAPIforpaymentInfo() async {
      await getPreferences();
      Map result = await InsertPaymentMethodParser.callApiforInfo(
          "${Config.strBaseURL}checkouts/getpaymentinfo?systemname=Payments.CheckMoneyOrder&customerId="+customerId.toString());
      if (result["errorCode"] == 0) {
        paymentinfo = result["value"];
        setState(() {

        });
      } else {
        Fluttertoast.showToast(msg: result["value"]);
      }
    }

  void callAPIforpaymentInfoPayNow() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ConfirmOrderScreen(
      systemName: widget.systemName,
      strShippingMethodName: widget.strShippingMethodName,
      strPaymentMethodName: widget.mTitle,
      cartItemList: widget.cartItemList,
    )));

  }
}

