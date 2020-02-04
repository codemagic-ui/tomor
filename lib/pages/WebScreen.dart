import 'package:flutter/material.dart';
import 'package:i_am_a_student/pages/LoadingScreen.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebScreen extends StatefulWidget {
  final url;
  WebScreen(this.url);
  @override
  createState() => _WebScreenState(this.url);
}

class _WebScreenState extends State < WebScreen > {
  var _url;
  final _key = UniqueKey();
  _WebScreenState(this._url);
  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(),
          body: IndexedStack(
            index: _stackToView,
            children: [
              Column(
                children: < Widget > [
                  Expanded(
                      child: WebView(
                        key: _key,
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: _url,
                        onPageFinished: _handleLoad,
                      )
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Center(
                  child: LoadingScreen(),
                ),
              ),
            ],
          )
      ),
    );
  }
}
