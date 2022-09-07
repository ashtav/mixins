import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension CustomExtension on Map<String, TextEditingController> {
  /// ``` dart
  /// Map<String, TextEditingController> mapTec = {'name': TextEditingController(text: 'John Doe')};
  /// Map<String, dynamic> map = mapTec.tecToMap();
  ///
  /// // result:
  /// {
  ///   "name": "John Doe"
  /// }
  /// ```
  Map<String, dynamic> tecToMap() =>
      map((key, value) => MapEntry(key, value.text));
}

// CUSTOM STRING EXTENSION ===============

extension CustomStringExtension on String {
  bool get isEmail => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);

  /// ``` dart
  /// print('john doe'.ucwords); // John Doe
  /// ```
  String get ucwords {
    try {
      String str = this;

      if (str.trim() == '') return '';

      List<String> split = str.split(' ');
      for (int i = 0; i < split.length; i++) {
        if (split[i] != '') {
          split[i] = split[i][0].toUpperCase() + split[i].substring(1);
        }
      }

      return split.join(' ');
    } catch (e) {
      return '';
    }
  }

  /// ``` dart
  /// print('lipsum99'.getNumberOnly); // 99
  /// ```
  int get getNumberOnly {
    try {
      if (trim().isEmpty) return 0;

      return int.parse(replaceAll(RegExp(r'[^0-9-]'), ''));
    } catch (e) {
      return 0;
    }
  }

  /// ``` dart
  /// print('John Doe', length: 3); // JD
  /// ```
  String charName({bool firstUppercase = true, int length = 2}) {
    String result = '';

    try {
      List<String> char = split(' ');
      char
          .take(length)
          .forEach((e) => result += firstUppercase ? e[0].ucwords : e[0]);
      return result;
    } catch (e) {
      return '!';
    }
  }

  /// ``` dart
  /// print('lorem ipsum dolor'.removeStringBefore('ipsum')); // dolor
  /// ```
  String removeStringBefore(String pattern) {
    try {
      return substring(lastIndexOf(pattern));
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// print('lorem ipsum dolor'.removeStringAfter('ipsum')); // lorem
  /// ```
  String removeStringAfter(String pattern) {
    try {
      return substring(0, indexOf(pattern));
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// print('<body>'.removeHtmlTag); // body
  /// ```
  String get removeHtmlTag {
    try {
      RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      return replaceAll(exp, '').replaceAll('&nbsp;', '');
    } catch (e) {
      return '!';
    }
  }

  /// check is string is json format
  bool get isJson {
    try {
      json.decode(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}

// CUSTOM DYNAMIC EXTENSION ===============

extension CustomDynamicExtension on dynamic {
  /// check if value is null
  /// ``` dart
  /// String? data;
  /// print(data.isNulll); // true
  ///
  /// // because can not use isNull in dart (deprecated)
  /// ```
  get isNulll => (this == null);

  /// ``` dart
  /// print('a4'.isNumeric); // false
  /// print('99'.isNumeric); // true
  /// ```
  bool get isNumeric => double.tryParse('${this}') != null;

  /// ``` dart
  /// print('9500'.idr()); // Rp9.500
  /// print(9500.idr()); // Rp9.500
  /// ```
  String idr({String symbol = 'Rp', int decimalDigits = 0}) {
    try {
      String numberStr = toString();
      int number = numberStr.isEmpty ? 0 : numberStr.getNumberOnly;
      return NumberFormat.currency(
              locale: 'id_ID', decimalDigits: decimalDigits, symbol: symbol)
          .format(number);
    } catch (e) {
      return 'Rp?';
    }
  }

  /// ``` dart
  /// print(99025.formatBytes()); // 96.7 KB
  /// ```
  String formatBytes([int decimals = 1]) {
    int bytes = int.parse(toString());
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// ``` dart
  /// var group = data.groupBy('gender', wrapWith: (data){
  ///   return [...data.map((e) => YourModel.fromJson(e))];
  /// }, addKeys: ['gender']);
  /// ```
  List<Map<dynamic, dynamic>> groupBy(String key,
      {String? setKeyAs,
      Function(dynamic)? wrapWith,
      List<String> addKeys = const []}) {
    if (this is! List) throw Exception('groupBy only works on List');

    try {
      List<Map<dynamic, dynamic>> result = [];
      List keys = [];

      this.forEach((f) => keys.add(f[key]));

      for (var k in [...keys.toSet()]) {
        List data = [...this.where((e) => e[key] == k)];
        Map map = {};

        if (addKeys.isNotEmpty) {
          for (var k in addKeys) {
            map[k] = data.first[k];
          }
        }

        if (wrapWith != null) {
          data = wrapWith(data);
        }

        if (setKeyAs != null) map['group_by'] = k;

        //remove key (group_by)
        //data.forEach((w) => w.removeWhere((k, v) => k == key));
        map[setKeyAs ?? k] = data;

        result.add(map);
      }

      return result;
    } catch (e) {
      throw Exception('$e');
    }
  }
}

// DATETIME EXTENSION ===============

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var wom = 0;
    var date = this;

    while (date.month == month) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }

    return wom;
  }

  int get weekOfYear {
    var wom = 0;
    var date = this;

    while (date.year == year) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }

    return wom;
  }
}

extension CustomListExtension on List {
  dynamic random() {
    return this[Random().nextInt(length)];
  }
}
