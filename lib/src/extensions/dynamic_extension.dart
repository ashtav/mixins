import 'package:intl/intl.dart';

extension DynamicExtension on dynamic {
  String idr({String symbol = 'Rp', int decimalDigits = 0}) {
    try {
      String num = '0', digits = '';

      switch (runtimeType) {
        case int:
          num = toString();
          break;

        case double:
          num = toStringAsFixed(0);

          // check how many decimal digits
          if (toString().contains('.')) {
            digits = toString().split('.')[1];
          }
          break;
        default:
      }

      print(num);
      print(digits);

      // String numberStr = toString();
      // int number = numberStr.isEmpty ? 0 : numberStr.getNumberOnly;
      return NumberFormat.currency(locale: 'id_ID', decimalDigits: decimalDigits, symbol: symbol).format(1500.40);
    } catch (e) {
      return 'Rp?';
    }
  }
}
