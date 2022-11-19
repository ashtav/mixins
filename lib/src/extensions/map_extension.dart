import 'package:flutter/material.dart';

extension MapTECExtension on Map<String, TextEditingController> {
  /// ``` dart
  /// Map<String, TextEditingController> data = {'name': TextEditingController(text: 'John Doe')};
  /// Map<String, dynamic> map = data.tecToMap(); // { "name": "John Doe" }
  /// ```
  Map<String, dynamic> tecToMap() => map((key, value) => MapEntry(key, value.text));
}
