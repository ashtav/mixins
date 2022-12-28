import 'package:flutter/material.dart';

class Forms {
  /// ```dart
  /// Map<String, TextEditingController> forms = Forms.create(['name', {'qty': 1}]) // Only String and Map are allowed
  /// ```
  static Map<String, TextEditingController> create(List keys) {
    Map<String, TextEditingController> res =
        Map.fromEntries(List.generate(keys.length, (i) {
      bool isString = keys[i] is String;
      bool isMap = keys[i] is Map;

      if (!isString && !isMap) {
        throw 'Only String and Map are allowed';
      }

      return MapEntry(
          isString ? keys[i] : (keys[i] as Map).keys.first,
          TextEditingController(
              text: isString ? '' : (keys[i] as Map).values.first.toString()));
    }));

    return res;
  }

  /// ```dart
  /// Map<String, FocusNode> nodes = Forms.createNodes(['name', 'qty'])
  /// ```
  static Map<String, FocusNode> createNodes(List<String> keys) {
    Map<String, FocusNode> res =
        Map.fromEntries(List.generate(keys.length, (i) {
      return MapEntry(keys[i], FocusNode());
    }));

    return res;
  }
}
