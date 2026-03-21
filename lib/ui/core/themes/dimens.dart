import 'package:flutter/material.dart';

abstract final class Dimens {
  const Dimens();

  /// General horizontal padding used to separate UI items
  static const paddingHorizontal = 20.0;

  /// General vertical padding used to separate UI items
  static const paddingVertical = 20.0;
  static const longPaddingVertical = 25.0;

  static const commonFontSize = 18.0;

  /// Get dimensions of screen size
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
      
}