import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mixins/src/log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';

class Mixins {
  /// ``` dart
  /// Mixins.hex('#fff'); // white
  /// ```
  static Color hex(String code) {
    String cc = code.replaceAll('#', '');

    // if color code length is 3, make complete color code
    if (cc.length == 3) {
      cc = '${cc[0]}${cc[0]}${cc[1]}${cc[1]}${cc[2]}${cc[2]}';
    }

    return Color(int.parse('0xff$cc'));
  }

  /// ``` dart
  /// catch (e, s){
  ///   Mixins.errorCatcher(e, s);
  /// }
  /// ```
  static errorCatcher(e, StackTrace s) {
    List frames = Trace.current().frames, terseFrames = Trace.from(s).terse.frames;
    Frame frame = Trace.current().frames[frames.length > 1 ? 1 : 0], trace = Trace.from(s).terse.frames[terseFrames.length > 1 ? 1 : 0];

    String errorLocation = '${frame.member}', errorLine = '${trace.line}';
    clog('-- Error on $errorLocation (Line $errorLine), $e');
  }

  // STATUS BAR ============================================

  /// ``` dart
  /// Mixins.statusBar();
  /// ```
  static statusBar({Brightness brightness = Brightness.dark, Color background = Colors.transparent}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: background, statusBarIconBrightness: brightness));
  }

  /// ``` dart
  /// Mixins.hideStatusBar();
  /// ```
  static void hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  /// ``` dart
  /// Mixins.showStatusBar();
  /// ```
  static void showStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

  // CLIPBOARD =============================================

  /// ```dart
  /// Mixins.copy('YOUR TEXT');
  /// ```
  static Future<bool> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  }

  // DATE & TIME ============================================

  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  /// ```dart
  /// String date = Mixins.dateFormat(DateTime.now(), format: 'dd/MM/yyyy');
  /// ```
  static String dateFormat(DateTime? dateTime, {String format = 'dd/MM/yyyy'}) {
    return dateTime == null ? '-' : DateFormat(format).format(dateTime);
  }

  /// ```dart
  /// Timer timer = Mixins.timer((){
  ///   // do something...
  /// }, 100);
  /// ```
  static timer(void Function() then, [int ms = 50]) => Timer(Duration(milliseconds: ms), then);

  /// ``` dart
  /// Mixins.msToDateTime(1625386377499, format: 'D, d F Y h:i:s'); // Sabtu, 20 Maret 2021
  /// ```
  static String msToDateTime(int ms, {String format = 'dd/MM/yyyy'}) => Mixins.dateFormat(DateTime.fromMillisecondsSinceEpoch(ms), format: format);

  /// ```dart
  /// String timeElapsed = Mixins.timeElapsed('2021-02-24 11:12:30', inDay: 'day ago');
  /// // put value with String or DateTime only
  /// // only for 1 month calculation
  /// ```
  static String timeElapsed(dynamic dateTime, {String? inDay, String? inHour, String? inMinute, String justNow = 'just now'}) {
    try {
      Duration compare(DateTime x, DateTime y) => Duration(microseconds: (x.microsecondsSinceEpoch - y.microsecondsSinceEpoch).abs());

      DateTime date = dateTime is String ? DateTime.parse(dateTime) : dateTime;

      DateTime x = DateTime.now();
      DateTime y = DateTime(date.year, date.month, date.day, date.hour, date.minute, date.second);

      Duration diff = compare(x, y);
      String h = '${date.hour}'.padLeft(2, '0'), m = '${date.minute}'.padLeft(2, '0'), s = '${date.second}'.padLeft(2, '0');

      String dateTimeStr = '${date.year}-${'${date.month}'.padLeft(2, '0')}-${'${date.day}'.padLeft(2, '0')} $h:$m:$s';

      // if init value more then current time
      if (y.millisecondsSinceEpoch > x.millisecondsSinceEpoch) {
        return '-';
      }

      String textInDay(int value) => inDay ?? (value > 1 ? 'days ago' : 'day ago');
      String textInHour(int value) => inHour ?? (value > 1 ? 'hours ago' : 'hour ago');
      String textInMinute(int value) => inMinute ?? (value > 1 ? 'minutes ago' : 'minute ago');

      if (diff.inSeconds >= 60) {
        if (diff.inMinutes >= 60) {
          if (diff.inHours >= 24) {
            return diff.inDays > 31 ? dateTimeStr : '${diff.inDays} ${textInDay(diff.inDays)}';
          } else {
            return '${diff.inHours} ${textInHour(diff.inHours)}';
          }
        } else {
          return '${diff.inMinutes} ${textInMinute(diff.inMinutes)}';
        }
      } else {
        return justNow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // NUMBER =================================================

  /// ``` dart
  /// Mixins.doubleInRange(10, 100); // generate random double value between 10 - 100
  /// ```
  static double doubleInRange(num start, num end) => Random().nextDouble() * (end - start) + start;

  /// ``` dart
  /// Mixins.intInRange(100); // generate random int value with max 100
  /// ```
  static int intInRange(int max) => Random().nextInt(max);

  /// ``` dart
  /// Mixins.randNum(19); // generate random int value, max value is 19
  /// ```
  static int randNum([int length = 12]) => int.parse(List.generate(length, (i) => '${intInRange(9)}').join(''));

  // CURSOR =================================================

  /// ```dart
  /// TextEditingController name = TextEditingController();
  /// Mixins.setCursorToLastPosition(name);
  /// ```
  static setCursorToLastPosition(TextEditingController controller, [int time = 0]) {
    Timer(Duration(milliseconds: time), () => controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length)));
  }

  // SCROLL =================================================

  /// ```dart
  /// ScrollController scroll = ScrollController();
  /// Mixins.scrollTo(scroll);
  /// ```
  static scrollTo(ScrollController scrollController, {int duration = 300, int delay = 50, AxisDirection to = AxisDirection.up}) {
    Timer? timer;

    try {
      if (scrollController.hasClients) {
        timer = Timer(Duration(milliseconds: delay), () {
          scrollController.animateTo(
            to == AxisDirection.down ? scrollController.position.maxScrollExtent : 0,
            curve: Curves.easeOut,
            duration: Duration(milliseconds: duration),
          );

          timer?.cancel();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // SCREEN =================================================

  /// ```dart
  /// Mixins.orientation([DeviceOrientation.landscapeLeft]);
  /// ```
  static void orientation([List<DeviceOrientation> orientations = const [DeviceOrientation.portraitUp]]) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  // IMAGES =================================================

  /// ```dart
  /// File file = await Mixins.urlToFile('FILE-URL');
  /// ```
  static Future<File> urlToFile(String imageUrl) async {
    try {
      // get temporary directory of device.
      Directory tempDir = await getTemporaryDirectory();

      // get temporary path from temporary directory.
      String tempPath = tempDir.path;

      // create a new file in temporary path with random file name.
      File file = File('$tempPath${DateTime.now().millisecondsSinceEpoch}.png');

      // call http.get method and pass imageUrl into it to get response.
      http.Response response = await http.get(Uri.parse(imageUrl));

      // write bodyBytes received in response to file.
      await file.writeAsBytes(response.bodyBytes);

      // now return the file which is created with random name in
      // temporary directory and image bytes from response is written to // that file.
      return file;
    } catch (e) {
      rethrow;
    }
  }

  /// ```dart
  /// String base64 = await Mixins.fileToBase64(file);
  /// ```
  static Future<String> fileToBase64(File file) async {
    try {
      String base64Image = base64Encode(file.readAsBytesSync());
      return base64Image;
    } catch (e) {
      rethrow;
    }
  }

  /// ```dart
  /// File file = await Mixins.base64ToFile('BASE64-STRING');
  /// ```
  static Future<File> base64ToFile(String base64) async {
    try {
      Uint8List uint8list = base64Decode(base64);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.png");
      return await file.writeAsBytes(uint8list);
    } catch (e) {
      rethrow;
    }
  }

  /// ```dart
  /// Image image = await Mixins.base64ToImage('BASE64-STRING');
  /// ```
  static Future<Image> base64ToImage(String base64) async {
    try {
      Uint8List uint8list = base64Decode(base64);
      return Image.memory(uint8list);
    } catch (e) {
      rethrow;
    }
  }

  /// ```dart
  /// File file = await Mixins.imageToFile('avatar.png');
  /// ```
  static Future<File> imageToFile(String imageName) async {
    var bytes = await rootBundle.load('assets/$imageName');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  /// ```dart
  /// File result = await Mixins.resize(file);
  /// // params: size = const [width, height]
  /// ```
  static Future<File> resize(File file, {int quality = 90, List<int> size = const [500, 500]}) async {
    try {
      File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 90, targetWidth: size[0], targetHeight: size[1]);
      return compressedFile;
    } catch (e) {
      rethrow;
    }
  }

  /// ```dart
  /// // get image info
  /// Map info = await Mixins.imageProperties(file);
  /// // this function will return map
  /// Map info = {"width": 300, "height": 300, "orientation": ImageOrientation}
  /// ```
  static Future<Map> imageProperties(File file) async {
    try {
      ImageProperties properties = await FlutterNativeImage.getImageProperties(file.path);
      return {'width': properties.width, 'height': properties.height, 'orientation': properties.orientation};
    } catch (e) {
      return {'width': null, 'height': null, 'orientation': null};
    }
  }

  static bool isEmail(String value) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value);
}
