import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi;

import 'package:flutter/widgets.dart';
class Sizes {
  static const double defaultTitleImageHeight = 80.0;
  static const double defaultTitleImageWidth = 80.0;
  static const double defaultTitleIconSize = 80.0;

  static const double padding10 = 10.0;

  static const double padding20 = 20.0;

  static const double padding15 = 15.0;

  static const double mediumImageSize = 30.0;

  /*static height(double height, BuildContext context) {
    return height * MediaQuery.of(context).size.height / MediaQuery.of(context).size.height;
  }

  static width(double width, BuildContext context) {
    return width * MediaQuery.of(context).size.width / MediaQuery.of(context).size.width;
  }*/
}




class DelayTween extends Tween<double> {
  DelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class AngleDelayTween extends Tween<double> {
  AngleDelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp(math.sin((t - delay) * math.pi * 0.5));

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}