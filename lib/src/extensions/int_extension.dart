import 'dart:math';

extension IntExtension on int {
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
}
