import 'package:flutter/material.dart';
import 'package:mixins/src/extension.dart';

// MAP VALIDATOR
// It is used to validate the data of a Map<String, dynamic>

/// ``` dart
/// // MAP VALIDATOR
/// // It is used to validate the data of a Map<String, dynamic>
///
/// // All input is required
/// Mv input = await Mv.validate(map, 'required.all');
///
/// // All input is required except phone and address
/// Mv input = await Mv.validate(map, 'required.all|phone,address');
///
/// // Set rule to specific input
/// Mv input = await Mv.validate(map, {
///   'name': 'required',
///   'email': 'required|email',
///   'phone': 'required|numeric|min:10|max:15',
/// });
///
/// // check result
/// bool ok = input.ok;
/// String? error = input.error;
/// Map<String, dynamic> result = input.result; // details
///
/// ```

class Mv {
  final bool ok;
  final String? error;
  final Map result;

  Mv({this.ok = false, this.error, this.result = const {}});

  // ===== INPUT VALIDATION
  static Future<Mv> validate(Map<String, dynamic> request, dynamic rule) async {
    try {
      // accept rule in Map & String only
      if (rule is! Map && rule is! String) {
        throw Exception('Rule must be Map or String');
      }

      List<String> errors = [], errKeys = [], types = [];

      // function to put error message to errors and error keys to errKeys
      void _addError(String key, String message) {
        errors.add(message);
        errKeys.add(key);
      }

      // check if request is Map<String, TextEditingController>
      bool isMapTec = request is Map<String, TextEditingController>;

      // turn request into map
      Map<String, dynamic> map = isMapTec
          ? request.map((key, value) => MapEntry(key, value.text))
          : request;

      if (rule is String && rule.contains('required.all')) {
        List<String> except = rule.split('|');

        map.forEach((k, v) {
          if (v == null || '$v'.trim().isEmpty) {
            if (except.length > 1) {
              List excepts = except[1].split(',');

              if (!excepts.contains(k)) {
                _addError(k, '$k is required');
                types.add('required');
              }
            } else {
              _addError(k, '$k is required');
              types.add('required');
            }
          }
        });
      } else {
        // check request configuration
        List<String> rules = rule.keys.toList().cast<String>();

        // remove where rules key is not in map
        rules.removeWhere((k) => !map.containsKey(k));

        // check configuration
        for (var k in rules) {
          List<String> rules = rule[k].split('|');

          // check required
          if (rules.contains('required')) {
            if (map[k] == null || '${map[k]}'.trim().isEmpty) {
              _addError(k, '$k is required');
              types.add('required');
            }
          }

          // check email validation
          if (rules.contains('email')) {
            if (!'${map[k]}'.isEmail) {
              _addError(k, '$k is not valid email');
              types.add('email');
            }
          }

          // check numeric
          if (rules.contains('numeric')) {
            if (map[k] != null && !RegExp(r'^[0-9]+$').hasMatch('${map[k]}')) {
              _addError(k, '$k must be numeric');
              types.add('numeric');
            }
          }

          // check min length
          if (rule[k].contains('min')) {
            // get string between 'min:' and '|'
            String min = rule[k].split('min:')[1].split('|')[0];
            if (map[k] == null || '${map[k]}'.length < int.parse(min)) {
              _addError(k, 'min length of $k is $min');
              types.add('min');
            }
          }

          // check max length
          if (rule[k].contains('max')) {
            // get string between 'max:' and '|'
            String max = rule[k].split('max:')[1].split('|')[0];
            if (map[k] == null || '${map[k]}'.length > int.parse(max)) {
              _addError(k, 'max length of $k is $max');
              types.add('max');
            }
          }
        }
      }

      Map<String, dynamic> result = {};

      // take first error
      if (errors.isNotEmpty && errKeys.isNotEmpty) {
        String error = errors.first;

        result = {
          'key': errKeys.first,
          'type': types.isEmpty ? '' : types.first,
          'message': error,
          'errors': {
            'messages': errors,
            'keys': errKeys,
          }
        };
      }

      return Mv(ok: errors.isEmpty, error: result['message'], result: result);
    } catch (e) {
      return Mv(ok: false);
    }
  }
}
