import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mixins/src/extension.dart';

class MixinsFormatter {
  static TextInputFormatter get numberOnly =>
      FilteringTextInputFormatter.allow(RegExp("[0-9]"));
  static TextInputFormatter get lettersOnly =>
      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"));
  static TextInputFormatter get lettersAndNumberOnly =>
      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]"));

  static TextInputFormatter get lowercase => LowerCaseTextFormatter();
  static TextInputFormatter get uppercase => UpperCaseTextFormatter();
  static TextInputFormatter get ucwords => UcwordsFormatter();

  /// ```dart
  /// formatters: [
  ///   MixinsFormatter.regExp('[a-zA-Z]')
  /// ]
  /// ```
  static TextInputFormatter regExp(String pattern) =>
      FilteringTextInputFormatter.allow(RegExp(pattern));
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// UCWORDS FORMATTER
class UcwordsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      String newString = newValue.text.ucwords;

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

// THOUSAND FORMATTER
class ThousandFormatter extends TextInputFormatter {
  final String sparator;
  ThousandFormatter({this.sparator = ','});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int max = 19;
      bool isMax = newValue.text.length >= max;

      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;

      String convert(String value) =>
          NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '')
              .format(int.parse(value));
      String newString =
          convert(isMax ? newValue.text.substring(0, max) : newValue.text);

      return TextEditingValue(
        text: newString.replaceAll('.', sparator.isEmpty ? ',' : sparator),
        selection: TextSelection.collapsed(
          offset: isMax
              ? newString.length
              : newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
