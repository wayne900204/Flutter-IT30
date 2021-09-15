import 'package:flutter/material.dart';

/// text 的樣式
/// https://medium.com/@najeira/control-text-height-using-strutstyle-4b9b5151668b
class Helper {
  Helper._internal();

  static StrutStyle buildStrutStyle(TextStyle? textStyle) {
    return StrutStyle(
      forceStrutHeight: true,
      fontWeight: textStyle?.fontWeight,
      fontSize: textStyle?.fontSize,
      fontFamily: textStyle?.fontFamily,
      fontStyle: textStyle?.fontStyle,
      fontFamilyFallback: textStyle?.fontFamilyFallback,
      debugLabel: textStyle?.debugLabel,
    );
  }
}
