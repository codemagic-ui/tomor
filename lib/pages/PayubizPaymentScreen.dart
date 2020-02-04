import 'package:flutter/material.dart';
import 'package:i_am_a_student/pages/SelectedBanking.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';

class PayubizPaymentScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PayubizPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: layoutMain(),
    );
  }

  Widget layoutMain() {
    return Scaffold(
      appBar: AppBar(
        title: Text("payUbiz"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          new Container(
            color: Colors.pinkAccent,
            height: 200.0,
            child: Center(
              child: new Text(
                "Ammount: \$1400",
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                Card(
                  child: new ListTile(
                      onTap: () {
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/net_banking.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "NetBanking",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                      //  navigatePush(SelectedBanking("CreditCard",));
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/craditcard.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "CreditCard",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                     //   navigatePush(SelectedBanking("DebitCard",));
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/dabitcard.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "DebitCard",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/cashcard.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "CashCard",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/wallet.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "Wallet",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/upi.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "UPI",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/tez.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "GoogleTEZ",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/emi.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "EMI",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
                Card(
                  child: new ListTile(
                      onTap: () {
                      },
                      trailing: Icon(Icons.navigate_next),
                      leading: Image.asset("images/neft.png",
                          height: 35.0, width: 35.0),
                      title: new Text(
                        "IMPS / NEFT",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  navigatePush(Widget page) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }
}
