import 'package:flutter/material.dart';
import 'package:i_am_a_student/utils/flutter_range_slider.dart' as slider;

class RangeSliderData {
  double min;
  double max;
  double lowerValue;
  double upperValue;
  int divisions;
  bool showValueIndicator;
  int valueIndicatorMaxDecimals;
  String currency;
  bool forceValueIndicator;
  Color overlayColor;
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color thumbColor;
  Color valueIndicatorColor;
  Color activeTickMarkColor;

  static const Color defaultActiveTrackColor = const Color(0xFF0175c2);

//  static const Color defaultInactiveTrackColor = const Color(0x3d0175c2);
  static const Color defaultActiveTickMarkColor = const Color(0x8a0175c2);
  static const Color defaultThumbColor = const Color(0xFF0175c2);
  static const Color defaultValueIndicatorColor = const Color(0xFF0175c2);

//  static const Color defaultOverlayColor = const Color(0x290175c2);

  RangeSliderData({
    this.min,
    this.max,
    this.lowerValue,
    this.upperValue,
    this.divisions,
    this.currency,
    this.showValueIndicator: true,
    this.valueIndicatorMaxDecimals: 1,
    this.forceValueIndicator: false,
    this.overlayColor: defaultActiveTrackColor,
    this.activeTrackColor: defaultActiveTrackColor,
    this.inactiveTrackColor: defaultActiveTrackColor,
    this.thumbColor: defaultThumbColor,
    this.valueIndicatorColor: defaultValueIndicatorColor,
    this.activeTickMarkColor: defaultActiveTickMarkColor,
  });

  // Returns the values in text format, with the number
  // of decimals, limited to the valueIndicatedMaxDecimals
  //
  String get lowerValueText =>
      lowerValue.toStringAsFixed(valueIndicatorMaxDecimals);

  String get upperValueText =>
      upperValue.toStringAsFixed(valueIndicatorMaxDecimals);

  // Builds a RangeSlider and customizes the theme
  // based on parameters
  //
  Widget build(BuildContext context, slider.RangeSliderCallback callback) {
    return Center(
      child: new Container(
        width: double.infinity,
        child: new Row(
          children: <Widget>[
            Center(
              child: new Text(
                currency.toString() + " " + lowerValueText.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            new Expanded(
              child: new SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayColor: overlayColor,
                  activeTickMarkColor: activeTickMarkColor,
                  activeTrackColor: activeTrackColor,
                  inactiveTrackColor: inactiveTrackColor,
                  thumbColor: thumbColor,
                  disabledThumbColor: defaultActiveTrackColor,
                  thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.0, disabledThumbRadius: 8.0),
                  valueIndicatorColor: valueIndicatorColor,
                  showValueIndicator: showValueIndicator
                      ? ShowValueIndicator.always
                      : ShowValueIndicator.onlyForDiscrete,
                ),
                child: new slider.RangeSlider(
                  min: min,
                  max: max,
                  lowerValue: lowerValue,
                  upperValue: upperValue,
                  divisions: divisions,
                  showValueIndicator: showValueIndicator,
                  valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                  onChanged: (double lower, double upper) {
                    callback(lower, upper);
                  },
                ),
              ),
            ),
            Center(
              child: new Text(
                currency.toString() + " " + upperValueText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
