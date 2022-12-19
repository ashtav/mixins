import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
      char.take(length).forEach((e) => result += firstUppercase ? e[0].ucwords : e[0]);
      return result;
    } catch (e) {
      return '!';
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.removeStringBefore('ipsum'); // ipsum dolor
  /// ```
  String removeStringBefore(String pattern, {bool includePattern = false}) {
    try {
      return !includePattern ? substring(lastIndexOf(pattern)) : substring(lastIndexOf(pattern) + pattern.length);
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.removeStringAfter('ipsum'); // lorem ipsum
  /// ```
  String removeStringAfter(String pattern, {bool includePattern = false}) {
    try {
      if (indexOf(pattern) == -1) return this;
      return substring(0, !includePattern ? indexOf(pattern) + pattern.length : indexOf(pattern));
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.removeStringBetween('lorem','ipsum'); // lorem dolor
  /// ```
  String removeStringBetween(String start, String end) {
    try {
      int startIndex = indexOf(start);
      int endIndex = indexOf(end);

      String beforeBracket = substring(0, startIndex);
      String afterBracket = substring(endIndex + end.length);

      return beforeBracket + afterBracket;
    } catch (e) {
      return this;
    }
  }

  /// ``` dart
  /// 'lorem ipsum dolor'.getStringBetween('lorem','dolor'); // ipsum
  /// ```
  String getStringBetween(String start, String end) {
    try {
      int startIndex = indexOf(start);
      int endIndex = indexOf(end);

      return substring(startIndex + start.length, endIndex);
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

  /// ``` dart
  /// File file = await '<base64-string>'.base64ToFile();
  /// ```
  Future<File> base64ToFile() async {
    Uint8List uint8list = base64Decode(this);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.png");
    return await file.writeAsBytes(uint8list);
  }

  /// ``` dart
  /// Image file = await '<base64-string>'.base64ToImage();
  /// ```
  Future<Image> base64ToImage() async {
    Uint8List uint8list = base64Decode(this);
    return Image.memory(uint8list);
  }

  /// ``` dart
  /// File file = await '<image-url>'.urlToFile();
  /// ```
  Future<File> urlToFile({String format = 'png'}) async {
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();

    // get temporary path from temporary directory.
    String tempPath = tempDir.path;

    // create a new file in temporary path with random file name.
    File file = File('$tempPath${DateTime.now().millisecondsSinceEpoch}.$format');

    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(this));

    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);

    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  /// ``` dart
  /// File file = await 'images/avatar.png'.imageToFile(); // from assets
  /// ```
  Future<File> imageToFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    var bytes = await rootBundle.load('assets/${this}');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/$fileName.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  bool get isEmail => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);

  bool get isUrl => RegExp(r'^(http|https|ftp):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$').hasMatch(this);
}
