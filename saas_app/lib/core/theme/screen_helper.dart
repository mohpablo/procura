import 'package:flutter/material.dart';

class ScreenHelper {
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double scaleWidth(BuildContext context, double factor) =>
      width(context) * (factor / _designWidth);

  static double scaleHeight(BuildContext context, double factor) =>
      height(context) * (factor / _designHeight);

  static double radius(BuildContext context, double r) =>
      scaleWidth(context, r);

  static bool isTablet(BuildContext context) => width(context) >= 600;

  @Deprecated('Use width(context) instead')
  static double staticWidth = 0;
  @Deprecated('Use height(context) instead')
  static double staticHeight = 0;

  static void init(BuildContext context) {
    staticWidth = width(context);
    staticHeight = height(context);
  }
}

extension ScreenHelperExtension on BuildContext {
  double get screenWidth => ScreenHelper.width(this);
  double get screenHeight => ScreenHelper.height(this);
  double sw(double factor) => ScreenHelper.scaleWidth(this, factor);
  double sh(double factor) => ScreenHelper.scaleHeight(this, factor);
}
