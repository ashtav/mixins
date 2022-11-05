import 'dart:math';

extension ListExtension on List {
  /// ```dart
  /// ['a', 'b', '4', 'e', '1'].getRandom() // 'e'
  /// ```
  dynamic getRandom([int length = 1]) {
    List result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[Random().nextInt(this.length)]);
    }
    return result;
  }
}
