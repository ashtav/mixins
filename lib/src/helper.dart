import 'package:flutter/material.dart';

class Short {
  /// ``` dart
  /// Short.hex('#fff') // white
  /// ```
  ///
  static Color hex(String code) {
    String cc = code.replaceAll('#', '');

    // if color code length is 3, make complete color code
    if (cc.length == 3) {
      cc = '${cc[0]}${cc[0]}${cc[1]}${cc[1]}${cc[2]}${cc[2]}';
    }

    return Color(int.parse('0xff$cc'));
  }
}
