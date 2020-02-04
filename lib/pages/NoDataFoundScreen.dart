import 'package:flutter/material.dart';


class NoDataFoundScreen extends StatefulWidget {
  @override
  _NoDataFoundScreenState createState() => _NoDataFoundScreenState();
}

class _NoDataFoundScreenState extends State<NoDataFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "images/notdatafound.png",
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
