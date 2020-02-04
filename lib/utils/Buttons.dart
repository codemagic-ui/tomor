import 'package:flutter/material.dart';
import 'package:i_am_a_student/utils/AppColor.dart';


class RaisedBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final double elevation;


  RaisedBtn({@required this.onPressed, @required this.text, this.elevation});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(

      elevation: elevation==null?8.0:elevation,
      padding: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class FlatBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Color color;

  FlatBtn({@required this.onPressed, @required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    if (color != null) {
      return FlatButton(
        textColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Text(text),
        onPressed: onPressed,
      );
    }
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}

class BorderBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;

  BorderBtn({@required this.onPressed, @required this.text});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      onPressed: onPressed,
      borderSide: BorderSide(color: AppColor.appColor),
      textColor: AppColor.appColor,
      child: Text(text),
    );
  }
}

class MaterialBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Color color;
  final double padding;

  MaterialBtn({@required this.onPressed, @required this.text, @required this.color,this.padding});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: AppColor.appColor,
      child: Padding(
        padding: padding!=null? EdgeInsets.all(padding):EdgeInsets.all(0.0),
        child: Text(text),
      ),
      color: color,
    );
  }
}
