import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixins/mixins.dart';

/* --------------------------------------------------------------------------
| TextInput
| -------------------------------------------------------- */

class Input extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? hint;
  final bool obsecure, autofocus, enabled, indicator;
  final Widget? suffixIcon;
  final TextInputType? keyboard;
  final int maxLength;
  final int? maxLines;
  final FocusNode? node;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Function(String)? onSubmit, onChanged;
  final Function(bool)? onFocus;
  final TextEditingController? controller;
  final List<TextInputFormatter> formatters;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const Input(
      {Key? key,
      required this.label,
      this.icon,
      this.hint,
      this.obsecure = false,
      this.autofocus = false,
      this.suffixIcon,
      this.keyboard,
      this.maxLength = 50,
      this.maxLines,
      this.node,
      this.enabled = true,
      this.indicator = false,
      this.borderRadius,
      this.border,
      this.margin,
      this.onSubmit,
      this.onChanged,
      this.onFocus,
      this.controller,
      this.backgroundColor,
      this.textStyle,
      this.formatters = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      onFocus?.call(node?.hasFocus ?? false);
    });

    List<TextInputFormatter> formatters = [
      LengthLimitingTextInputFormatter(maxLength),
      ...this.formatters
    ];

    if (keyboard == Tit.number) {
      formatters.add(InputFormat.numeric);
    }

    return Container(
        margin: margin ?? Ei.only(b: 15),
        child: ClipRRect(
          borderRadius: borderRadius ?? Br.radius(2),
          child: Container(
            padding: Ei.only(l: 15, r: 15, t: 15, b: 10),
            decoration: BoxDecoration(
                border: border ?? Border.all(color: Colors.black12, width: .7),
                color: Colors.white,
                borderRadius: borderRadius ?? Br.radius(2)),
            child: Col(children: [
              Container(
                margin: Ei.only(b: 2, l: 0),
                child: Row(
                  mainAxisAlignment: Maa.spaceBetween,
                  children: [
                    Text(label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 14)),
                    indicator
                        ? TextInputBadgeLabel(
                            controller: controller, maxLength: maxLength)
                        : const None(),
                  ],
                ),
              ),
              SizedBox(
                  child: Row(
                children: [
                  Expanded(
                    child: Row(children: [
                      icon.isNull
                          ? const None()
                          : Iconr(icon!,
                              color: Colors.white38,
                              margin: Ei.only(r: 15, b: 15)),
                      Expanded(
                          child: Focus(
                        onFocusChange: onFocus,
                        child: TextInputTransparent(
                          hint: hint,
                          keyboard: keyboard ?? Tit.text,
                          maxLength: maxLength,
                          node: node,
                          enabled: enabled,
                          obsecure: obsecure,
                          autofocus: autofocus,
                          onSubmit: onSubmit,
                          onChanged: onChanged,
                          controller: controller,
                          formatters: formatters,
                          maxLines: maxLines,
                          hintStyle: const TextStyle(color: Colors.black45),
                          textStyle: textStyle,
                          contentPadding: Ei.sym(v: 5),
                        ),
                      )),
                    ]),
                  ),
                  suffixIcon ?? const None(),
                ],
              ))
            ]),
          ),
        ));
  }

  Input copyWith(
      {EdgeInsetsGeometry? margin,
      BoxBorder? border,
      BorderRadius? borderRadius,
      TextEditingController? controller}) {
    return Input(
        label: label,
        icon: icon,
        hint: hint,
        obsecure: obsecure,
        autofocus: autofocus,
        suffixIcon: suffixIcon,
        keyboard: keyboard,
        maxLength: maxLength,
        maxLines: maxLines,
        node: node,
        enabled: enabled,
        indicator: indicator,
        borderRadius: borderRadius,
        border: border,
        margin: margin,
        onSubmit: onSubmit,
        onChanged: onChanged,
        onFocus: onFocus,
        controller: controller,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        formatters: formatters);
  }
}

class TextInputBadgeLabel extends StatefulWidget {
  final TextEditingController? controller;
  final int maxLength;
  const TextInputBadgeLabel({Key? key, this.controller, this.maxLength = 0})
      : super(key: key);

  @override
  State<TextInputBadgeLabel> createState() => _TextInputBadgeLabelState();
}

class _TextInputBadgeLabelState extends State<TextInputBadgeLabel> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        widget.controller?.addListener(() {
          if (mounted) setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int maxLength = widget.maxLength;
    int text = (widget.controller?.text ?? '').length;
    return Text('$text/$maxLength',
        style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14));
  }
}
