import 'package:flutter/material.dart';

// ========================================
// BORDER
// ========================================

class Br {
  /// ``` dart
  /// border: Br.all(Colors.black12)
  /// ```
  static BoxBorder all(Color color, {double width = .7, BorderStyle style = BorderStyle.solid}) =>
      Border.all(color: color, width: width, style: style);

  /// ``` dart
  /// border: Br.only(['t'])
  /// ```
  static BoxBorder only(List<String> only,
          {Color color = Colors.black12, double width = .7, bool except = false, BorderStyle style = BorderStyle.solid}) =>
      Border(
          top: !only.contains('t') || except ? BorderSide.none : Br.side(color, width: width, style: style),
          bottom: !only.contains('b') || except ? BorderSide.none : Br.side(color, width: width, style: style),
          left: !only.contains('l') || except ? BorderSide.none : Br.side(color, width: width, style: style),
          right: !only.contains('r') || except ? BorderSide.none : Br.side(color, width: width, style: style));

  /// ``` dart
  /// border: Br.except(['t'])
  /// ```
  static BoxBorder except(List<String> except, {Color color = Colors.black12, double width = .7, BorderStyle style = BorderStyle.solid}) => Border(
      top: except.contains('t') ? BorderSide.none : Br.side(color, width: width, style: style),
      bottom: except.contains('b') ? BorderSide.none : Br.side(color, width: width, style: style),
      left: except.contains('l') ? BorderSide.none : Br.side(color, width: width, style: style),
      right: except.contains('r') ? BorderSide.none : Br.side(color, width: width, style: style));

  /// ``` dart
  /// Border(left: Br.side(C.black1))
  /// ```
  static BorderSide side(Color color, {double width = .7, BorderStyle style = BorderStyle.solid}) =>
      BorderSide(color: color, width: width, style: style);

  /// ``` dart
  /// borderRadius: Br.radius(15)
  /// ```
  static BorderRadius radius(double value) => BorderRadius.circular(value);

  /// ``` dart
  /// borderRadius: Br.radiusOnly()
  /// ```
  static BorderRadiusGeometry radiusOnly({double? tl, double? tr, double? bl, double? br}) => BorderRadius.only(
      topLeft: Radius.circular(tl ?? 2),
      topRight: Radius.circular(tr ?? 2),
      bottomLeft: Radius.circular(bl ?? 2),
      bottomRight: Radius.circular(br ?? 2));

  /// ``` dart
  /// borderRadius: Br.circle
  /// ```
  static final circle = BorderRadius.circular(99999);

  /// ``` dart
  /// borderRadius: Br.zero
  /// ```
  static get zero => BorderRadius.zero;
}

// ========================================
// EDGE INSETS
// ========================================

class Ei {
  static const none = EdgeInsets.all(0);

  static only({double? b, double? t, double? l, double? r, double? v, double? h, double others = 0}) =>
      EdgeInsets.only(bottom: v ?? b ?? others, top: v ?? t ?? others, left: h ?? l ?? others, right: h ?? r ?? others);

  static all(double value) => EdgeInsets.all(value);

  static sym({double v = 0, double h = 0}) => EdgeInsets.symmetric(vertical: v, horizontal: h);

  /// ``` dart
  /// // set all values is 15 except top
  /// Ei.except(['t'], 15);
  /// ```
  static except(List<String> except, [double padding = 15]) => EdgeInsets.only(
      bottom: !except.contains('b') ? padding : 0,
      top: !except.contains('t') ? padding : 0,
      left: !except.contains('l') ? padding : 0,
      right: !except.contains('r') ? padding : 0);
}

// ========================================
// MAIN AXIS SIZE
// ========================================

class Mas {
  static const max = MainAxisSize.max;
  static const min = MainAxisSize.min;
}

// ========================================
// MAIN AXIS ALIGNMENT
// ========================================

class Maa {
  static const start = MainAxisAlignment.start;
  static const center = MainAxisAlignment.center;
  static const end = MainAxisAlignment.end;
  static const spaceAround = MainAxisAlignment.spaceAround;
  static const spaceBetween = MainAxisAlignment.spaceBetween;
  static const spaceEvenly = MainAxisAlignment.spaceEvenly;
}

// ========================================
// CROSS AXIS ALIGNMENT
// ========================================

class Caa {
  static const start = CrossAxisAlignment.start;
  static const center = CrossAxisAlignment.center;
  static const end = CrossAxisAlignment.end;
  static const baseline = CrossAxisAlignment.baseline;
  static const stretch = CrossAxisAlignment.stretch;
}

// ========================================
// WRAP AXIS ALIGNMENT
// ========================================

class Wca {
  static const start = WrapCrossAlignment.start;
  static const center = WrapCrossAlignment.center;
  static const end = WrapCrossAlignment.end;
}

// ========================================
// WRAP ALIGNMENT
// ========================================

class Wa {
  static const start = WrapAlignment.start;
  static const center = WrapAlignment.center;
  static const end = WrapAlignment.end;
  static const spaceAround = WrapAlignment.end;
  static const spaceBetween = WrapAlignment.end;
  static const spaceEvenly = WrapAlignment.end;
}

// ========================================
// TEXT ALIGN
// ========================================

class Ta {
  static const start = TextAlign.start;
  static const left = TextAlign.left;
  static const right = TextAlign.right;
  static const end = TextAlign.end;
  static const justify = TextAlign.justify;
  static const center = TextAlign.center;
}

// ========================================
// TEXT OVERFLOW
// ========================================

class Tof {
  static const clip = TextOverflow.clip;
  static const ellipsis = TextOverflow.ellipsis;
  static const fade = TextOverflow.fade;
  static const visible = TextOverflow.visible;
}

// ========================================
// FONT WEIGHT
// ========================================

class Fw {
  static const normal = FontWeight.normal;
  static const bold = FontWeight.bold;
  static const w100 = FontWeight.w100;
  static const w200 = FontWeight.w200;
  static const w300 = FontWeight.w300;
  static const w400 = FontWeight.w400;
  static const w500 = FontWeight.w500;
  static const w600 = FontWeight.w600;
  static const w700 = FontWeight.w700;
  static const w800 = FontWeight.w800;
  static const w900 = FontWeight.w900;
}

// ========================================
// TEXT INPUT TYPE
// ========================================

class Tit {
  static const datetime = TextInputType.datetime;
  static const emailAddress = TextInputType.emailAddress;
  static const multiline = TextInputType.multiline;
  static const name = TextInputType.name;
  static const number = TextInputType.number;
  static const phone = TextInputType.phone;
  static const streetAddress = TextInputType.streetAddress;
  static const text = TextInputType.text;
  static const url = TextInputType.url;
  static const visiblePassword = TextInputType.visiblePassword;
}
