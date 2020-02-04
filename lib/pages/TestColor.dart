import 'package:flutter/material.dart';
import 'package:i_am_a_student/utils/AppColor.dart';

class TestColor extends StatefulWidget {
  @override
  _TestColorState createState() => _TestColorState();
}

class _TestColorState extends State<TestColor> {
  var tt = "وإن لم يكن";

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Demo"),
        ),
        body: new Text(tt,style: new TextStyle(fontSize: 24.0)),
      ),
    );
  }
}
