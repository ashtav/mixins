import 'dart:convert';

extension StringExtension on String {
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
  /// 'John Doe'.firstChar(length = 2); // JD
  /// ```
  String firstChar({bool firstUppercase = true, int length = 2}) {
    String result = '';

    try {
      List<String> char = trim().split(' ');
      char
          .take(length)
          .forEach((e) => result += firstUppercase ? e[0].ucwords : e[0]);
      return result;
    } catch (e) {
      return '!';
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.removeStringBefore('ipsum'); // ipsum dolor
  /// ```
  String removeStringBefore(String pattern) {
    try {
      return substring(lastIndexOf(pattern));
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.removeStringAfter('ipsum'); // ipsum lorem
  /// ```
  String removeStringAfter(String pattern) {
    try {
      if (indexOf(pattern) == -1) return this;
      return substring(0, indexOf(pattern) + pattern.length);
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.removeStringBetween('lorem','ipsum); // dolor
  /// ```
  String removeStringBetween(String start, String end) {
    try {
      return replaceAll(RegExp('$start.*$end'), '');
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.getStringBetween('lorem','ipsum); // lorem ipsum
  /// ```
  String getStringBetween(String start, String end) {
    try {
      return RegExp('$start(.*)$end').stringMatch(this) ?? '';
    } catch (e) {
      return '';
    }
  }

  /// ``` dart
  /// '<h1>Hello World</h1>'.removeHtmlTag; // Hello World
  /// ```
  String get removeHtmlTag {
    try {
      RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      return replaceAll(exp, '').replaceAll('&nbsp;', '');
    } catch (e) {
      return '!';
    }
  }

  /// ``` dart
  /// '{}'.isJson; // true
  /// ```
  bool get isJson {
    try {
      json.decode(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool get isEmail => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);

  bool get isUrl => RegExp(
          r'^(http|https|ftp):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$')
      .hasMatch(this);
}
