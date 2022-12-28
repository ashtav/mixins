import 'package:intl/intl.dart';

extension DynamicExtension on dynamic {
  /// ```dart
  /// 1500.idr() // Rp1.500
  /// 2500.7.idr() // Rp2.500,7
  /// '3500.4'.idr() // Rp3.500,4
  /// ```
  String idr({String symbol = 'Rp', int decimalDigits = 0}) {
    try {
      String num = '0', digits = '';

      switch (runtimeType) {
        case int:
          num = toString();
          break;

        case double:
          if (toString().contains('.')) {
            num = toString().split('.')[0];
            digits = toString().split('.')[1];
          } else {
            num = toString();
          }
          break;

        case String:
          if (contains('.')) {
            num = split('.')[0];
            digits = split('.')[1];
          } else {
            num = toString();
          }
          break;
        default:
      }

      bool allowDecimal = runtimeType == int || runtimeType == String && !contains('.');

      String result = NumberFormat.currency(locale: 'id_ID', decimalDigits: allowDecimal ? decimalDigits : 0, symbol: symbol).format(int.parse(num));

      return digits.isEmpty ? result : '$result,${digits.split('').take(decimalDigits).join('')}';
    } catch (e) {
      return 'Rp?';
    }
  }

  /// ``` dart
  /// print('a4'.isNumeric); // false
  /// print('99'.isNumeric); // true
  /// ```
  bool get isNumeric => double.tryParse('${this}') != null;

  /// ``` dart
  /// String? data;
  /// print(data.isNull); // true
  /// ```
  get isNull => (this == null);

  /// ``` dart
  /// String? data;
  /// print(data.isNotNull); // false
  /// ```
  get isNotNull => (this != null);

  /// ``` dart
  /// String? name;
  /// name.orIf('-', [null, '']) // it's mean if name is null or empty, then return '-'
  /// ```
  ///
  dynamic orIf([dynamic value = '-', List conditions = const [null, '']]) {
    return conditions.contains(this) ? value : this;
  }
}
