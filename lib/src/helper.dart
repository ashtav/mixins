import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mixins/src/extensions/datetime_extension.dart';
import 'package:mixins/src/log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';

class Mixins {
  /// ``` dart
  /// Mixins.hex('fff'); // white
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
    logg('-- Error on $errorLocation (Line $errorLine), $e');
  }

  // SYSTEM CHROME ============================================

  /// ``` dart
  /// Mixins.setSystemUI();
  /// ```
  static setSystemUI({Brightness brightness = Brightness.dark, Color? statusBarColor, Color? navDividerColor, Color? navBarColor}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarColor: statusBarColor ?? Colors.transparent,
        systemNavigationBarDividerColor: navDividerColor,
        systemNavigationBarColor: navBarColor));
  }

  /// ``` dart
  /// Mixins.statusBar(true); // set false to hide
  /// ```
  static void statusBar([bool show = true]) => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: show ? SystemUiOverlay.values : []);

  // CLIPBOARD =============================================

  /// ```dart
  /// Mixins.copy('YOUR TEXT');
  /// ```
  static Future<bool> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  }

  /// ```dart
  /// Timer timer = Mixins.timer((){
  ///   // do something...
  /// }, 100);
  /// ```
  static Timer timer(void Function() then, [int ms = 50]) => Timer(Duration(milliseconds: ms), then);

  /// ``` dart
  /// Mixins.msToDateTime(1625386377499, format: 'D, d F Y h:i:s'); // Sabtu, 20 Maret 2021
  /// ```
  static String msToDateTime(int ms, {String format = 'dd/MM/yyyy'}) => DateTime.fromMillisecondsSinceEpoch(ms).format(format);

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

  /// ``` dart
  /// Mixins.randNum(18); // generate random int value, max length is 18
  /// ```
  static int randNum([int length = 10]) {
    if (length > 18) length = 18;

    String rand = '';
    for (int i = 0; i < length - 1; i++) {
      while (rand == '' || rand[0] == '0') {
        rand = Random().nextInt(10).toString();
      }

      rand += Random().nextInt(10).toString();
    }
    return int.parse(rand);
  }

  /// ``` dart
  /// Mixins.randString(10); // generate random string value
  /// ```
  static String randString(int length, {bool withSymbol = false, List<String> customChar = const []}) {
    String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    if (customChar.isNotEmpty) {
      chars = customChar.join();
    }

    if (withSymbol) {
      chars += '!@#\$%^&*()_+-=[]{}|;:<>?,./';
    }

    if (length < 1) length = 1;

    String rand = '';
    for (int i = 0; i < length; i++) {
      rand += chars[Random().nextInt(chars.length)];
    }
    return rand;
  }

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

  ///
  /// ```dart
  /// ListView(
  ///   controller: yourScrollController,
  ///   children: [
  ///     YourWidget(
  ///       key: yourGlobalKey
  ///     )
  ///   ]
  /// )
  ///
  /// onTap: (){
  ///   Mixins.scrollToWidget(yourGlobalKey, yourScrollController, MediaQuery.of(context).size.width);
  /// }
  /// ```

  static void scrollToWidget(GlobalKey key, ScrollController controller, double screenWidth) {
    if (key.currentContext != null) {
      RenderBox box = key.currentContext?.findRenderObject() as RenderBox;

      // get width of widget
      double w = box.size.width;

      // get horizontal position of widget
      double dx = box.localToGlobal(Offset.zero).dx;

      // get max scroll of List
      double ms = controller.position.maxScrollExtent;

      // get pixel of scroll position
      double pixel = controller.position.pixels;

      // result, the center position of widget
      double pos = (pixel + dx) - (screenWidth / 2) + (w / 2);

      // scroll to position
      controller.animateTo(
          pos < 0
              ? 0
              : pos > ms
                  ? ms
                  : pos,
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease);
    }
  }

  /// This function will set scroll to default position when user scroll to max position
  /// ``` dart
  /// List max = [10, 50]; // [top, bottom]
  /// double max = 50; // this value will set to top and bottom
  ///
  /// bool hasMax = scrollHasMax(scrollController, max);
  ///
  /// // for example:
  /// void yourScrollListener() {
  ///   double pixel = scrollController.position.pixels;
  ///
  ///   if (scrollHasMax(scrollController, [20, 50])) {
  ///     scrollController.animateTo(pixel, duration: const Duration(milliseconds: 250), curve: Curves.easeInBack);
  ///   }
  /// }
  /// ```
  static bool scrollHasMax(ScrollController scrollController, dynamic max) {
    bool isMaxList = max is List;

    // if max is integer or double
    max = max is int ? max.toDouble() : max;

    if (isMaxList) {
      if (max.length == 1) max.add(max[0]);
      max = max.map((e) => e is int ? e.toDouble() : e).toList();
    }

    double maxT = isMaxList ? max[0] : max;
    double maxB = isMaxList ? max[1] : max;

    double pixel = scrollController.position.pixels;
    double maxPixel = scrollController.position.maxScrollExtent;
    return (pixel < -maxB || pixel > (maxPixel + maxT));
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
  @Deprecated('Use await <your-file>.toBase64()')
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
  @Deprecated('Use File file = await \'<base64-string>\'.base64ToFile()')
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
}
