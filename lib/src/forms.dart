import 'package:flutter/material.dart';
import 'package:mixins/src/extensions/string_extension.dart';
import 'package:mixins/src/helper.dart';

class Forms {
  final bool ok;
  final Map<String, dynamic> errors;
  Forms({this.ok = false, this.errors = const {}});

  /// ```dart
  /// Map<String, TextEditingController> forms = Forms.create(['name', {'qty': 1}]) // Only String and Map are allowed
  /// ```
  static Map<String, TextEditingController> create(List keys) {
    Map<String, TextEditingController> res = Map.fromEntries(List.generate(keys.length, (i) {
      bool isString = keys[i] is String;
      bool isMap = keys[i] is Map;

      if (!isString && !isMap) {
        throw 'Only String and Map are allowed';
      }

      return MapEntry(
          isString ? keys[i] : (keys[i] as Map).keys.first, TextEditingController(text: isString ? '' : (keys[i] as Map).values.first.toString()));
    }));

    return res;
  }

  /// ```dart
  /// Map<String, FocusNode> nodes = Forms.createNodes(['name', 'qty'])
  /// ```
  static Map<String, FocusNode> createNodes(List<String> keys) {
    Map<String, FocusNode> res = Map.fromEntries(List.generate(keys.length, (i) {
      return MapEntry(keys[i], FocusNode());
    }));

    return res;
  }

  static void reset(Map<String, TextEditingController> forms) {
    forms.forEach((key, value) {
      value.clear();
    });
  }

  static void fill(Map<String, TextEditingController> forms, Map<String, String?> data, {List<String> except = const []}) {
    forms.forEach((key, value) {
      if (!except.contains(key)) {
        value.text = data[key] ?? '';
      }
    });
  }

  /// ```dart
  /// XForms form = XForms.validate(forms);
  ///
  /// @params
  /// required: ['*'] // required all
  /// required: ['address', 'phone'] // required only address and phone
  /// required: ['*', 'address', 'phone'] // required all except address and phone
  ///
  /// min: ['phone:10', 'address:5']
  /// max: ['phone:15', 'address:100']
  /// email: ['email']
  ///
  /// ```

  static Forms validate(Map<String, TextEditingController> forms,
      {List<String> required = const [], List<String> min = const [], List<String> max = const [], List<String> email = const []}) {
    Forms form = Forms(ok: true, errors: {});

    try {
      List<Map<String, dynamic>> keys = []; // problematic keys, stored here

      bool isRequiredAll = required.length == 1 && required.contains('*');
      bool isRequiredAllExcept = required.length > 1 && required.contains('*');

      /* ------------------------------------------------------------------------
      | Required
      | ------------------------------------ */

      if (isRequiredAll) {
        required = forms.keys.toList();
      } else if (isRequiredAllExcept) {
        required.remove('*');
        required = forms.keys.toList()..removeWhere((e) => required.contains(e));
      }

      for (var e in required) {
        if (forms[e] != null && forms[e]!.text.trim().isEmpty) {
          keys.add({'key': e, 'type': 'required', 'message': '$e is required'});
        }
      }

      /* ------------------------------------------------------------------------
      | Minimum Length
      | ------------------------------------ */

      // index 0 and 1 will always be there, if index 1 is not a number, it will be 0
      List splitter(String str) {
        List<String> split = str.split(':');
        return [split[0], split.length < 2 ? 0 : split[1].getNumberOnly];
      }

      for (var e in min) {
        List split = splitter(e);
        String key = split[0];
        int length = split[1];

        if (forms[key] != null && forms[key]!.text.trim().length < length) {
          keys.add({'key': key, 'type': 'min', 'message': '$key must be at least $length characters'});
        }
      }

      /* ------------------------------------------------------------------------
      | Maximum Length
      | ------------------------------------ */

      for (var e in max) {
        List split = splitter(e);
        String key = split[0];
        int length = split[1];

        if (forms[key] != null && forms[key]!.text.trim().length > length) {
          keys.add({'key': key, 'type': 'max', 'message': '$key must be at most $length characters'});
        }
      }

      /* ------------------------------------------------------------------------
      | Email
      | ------------------------------------ */

      for (var e in email) {
        if (forms[e] != null && !forms[e]!.text.trim().toString().isEmail) {
          keys.add({'key': e, 'type': 'email', 'message': '$e is not a valid email'});
        }
      }

      // if problematic keys is not empty, then return error
      if (keys.isNotEmpty) {
        form = Forms(ok: false, errors: keys.isEmpty ? {} : keys.first);
      }
    } catch (e, s) {
      Mixins.errorCatcher(e, s);
    }

    return form;
  }
}
