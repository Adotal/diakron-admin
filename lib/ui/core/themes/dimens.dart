import 'package:flutter/material.dart';

abstract final class Dimens {
  const Dimens();

  /// General horizontal padding used to separate UI items
  static const paddingHorizontal = 20.0;

  /// General vertical padding used to separate UI items
  static const paddingVertical = 24.0;

  /// Get dimensions of screen size
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
      
}