import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationPageRoute extends CupertinoPageRoute {
  final page;
  BuildContext context;
  AnimationPageRoute({@required this.page,@required this.context}) : super(builder: (BuildContext context) => page);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      body: page/*new AnimationBetweenPage(
//          animation: animation,
//          page: page,
//        )*/
////      body: AnimatedContainer(duration: Duration(milliseconds: 0),child: page,),
//    );
    return page;
  }
}

class AnimationBetweenPage extends StatefulWidget {
  final animation;
  final page;

  AnimationBetweenPage({@required this.animation, @required this.page});

  @override
  _AnimationBetweenPageState createState() => _AnimationBetweenPageState();
}

class _AnimationBetweenPageState extends State<AnimationBetweenPage> {
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.animation,
      child: new FadeTransition(opacity: widget.animation, child: widget.page),
    );
  }
}
