import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mixins/mixins.dart';

class TextInputTransparent extends StatelessWidget {
  final String? hint;
  final TextInputType? keyboard;
  final TextInputAction? inputAction;
  final Function(String)? onSubmit, onChanged;
  final bool autofocus, enabled, obsecure, showMaxLength;
  final FocusNode? node;
  final TextEditingController? controller;
  final TextAlign? textAlign;
  final int? maxLength, maxLines;
  final List<TextInputFormatter> formatters;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle, hintStyle;
  final TextSelectionControls? selectionControls;

  const TextInputTransparent(
      {Key? key,
      this.hint,
      this.keyboard,
      this.inputAction,
      this.onSubmit,
      this.obsecure = false,
      this.onChanged,
      this.autofocus = false,
      this.showMaxLength = false,
      this.node,
      this.controller,
      this.textAlign,
      this.enabled = true,
      this.maxLength = 255,
      this.formatters = const [],
      this.contentPadding,
      this.maxLines,
      this.textStyle,
      this.hintStyle,
      this.selectionControls})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget textField = TextField(
      style: textStyle ?? Theme.of(context).textTheme.bodyText2,
      keyboardType: keyboard,
      textInputAction: inputAction,
      onSubmitted: onSubmit,
      onChanged: onChanged,
      autofocus: autofocus,
      focusNode: node,
      obscureText: obsecure,
      enabled: enabled,
      textAlign: textAlign ?? TextAlign.start,
      controller: controller,
      maxLines: maxLines ?? 1,
      minLines: 1,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength), ...formatters],
      selectionControls: selectionControls,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding ?? Ei.sym(v: 13.5),
        hintText: hint,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black38),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );

    return textField;
  }
}

/* --------------------------------------------------------------------------
| TextInput
| -------------------------------------------------------- */

class TextInput extends StatelessWidget {
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

  const TextInput(
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

    List<TextInputFormatter> formatters = [LengthLimitingTextInputFormatter(maxLength), ...this.formatters];

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
                border: border ?? Border.all(color: Colors.black12, width: .7), color: Colors.white, borderRadius: borderRadius ?? Br.radius(2)),
            child: Col(children: [
              Container(
                margin: Ei.only(b: 2, l: 0),
                child: Row(
                  mainAxisAlignment: Maa.spaceBetween,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14)),
                    indicator ? TextInputBadgeLabel(controller: controller, maxLength: maxLength) : const None(),
                  ],
                ),
              ),
              SizedBox(
                  child: Row(
                children: [
                  Expanded(
                    child: Row(children: [
                      icon.isNull ? const None() : Iconr(icon!, color: Colors.white38, margin: Ei.only(r: 15, b: 15)),
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
}

class TextInputBadgeLabel extends StatefulWidget {
  final TextEditingController? controller;
  final int maxLength;
  const TextInputBadgeLabel({Key? key, this.controller, this.maxLength = 0}) : super(key: key);

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
    return Text('$text/$maxLength', style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14));
  }
}

/* --------------------------------------------------------------------------
| SelectInput
| -------------------------------------------------------- */

class Option {
  final String? option;
  final dynamic value;

  const Option({this.option, this.value});

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(option: map['option'], value: map['value']);
  }
}

class SelectInput extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? hint;
  final bool enabled;
  final int? maxLines;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Function(TextEditingController? form, Option? option)? onSelect;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final List<Option> options;

  const SelectInput({
    Key? key,
    required this.label,
    this.icon,
    this.hint,
    this.maxLines,
    this.enabled = true,
    this.borderRadius,
    this.border,
    this.margin,
    this.onSelect,
    this.controller,
    this.textStyle,
    this.options = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin ?? Ei.only(b: 15),
        child: ClipRRect(
          borderRadius: borderRadius ?? Br.radius(2),
          child: InkW(
            onTap: () {
              open(context);
            },
            color: Colors.white,
            child: Container(
              padding: Ei.only(l: 15, r: 15, t: 15, b: 10),
              decoration: BoxDecoration(border: border ?? Border.all(color: Colors.black12, width: .7), borderRadius: borderRadius ?? Br.radius(2)),
              child: Col(children: [
                Container(
                  margin: Ei.only(b: 2, l: 0),
                  child: Row(
                    mainAxisAlignment: Maa.spaceBetween,
                    children: [
                      Text(label, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14)),
                    ],
                  ),
                ),
                SizedBox(
                    child: Row(
                  children: [
                    Expanded(
                      child: Row(children: [
                        icon.isNull ? const None() : Iconr(icon!, color: Colors.white38, margin: Ei.only(r: 15, b: 15)),
                        Expanded(
                            child: TextInputTransparent(
                          hint: hint,
                          enabled: false,
                          controller: controller,
                          maxLines: maxLines,
                          hintStyle: const TextStyle(color: Colors.black45),
                          textStyle: textStyle,
                          contentPadding: Ei.sym(v: 5),
                        )),
                      ]),
                    ),
                    const Icon(
                      La.angle_down,
                    )
                  ],
                ))
              ]),
            ),
          ),
        ));
  }

  Future open(BuildContext context) async {
    if (options.isEmpty) return;
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: ((context) => SelectInputPicker(
            options: options,
            onSelect: (option) {
              controller?.text = option.option ?? '';
              onSelect?.call(controller, option);
            })));
  }
}

class SelectInputPicker extends StatelessWidget {
  final List<Option> options;
  final Function(Option)? onSelect;
  final Option? initialValue;

  const SelectInputPicker({Key? key, this.options = const [], this.onSelect, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = this.options.indexWhere((e) => e == initialValue);
    i = i == -1 ? 0 : i;

    List<String> options = this.options.map((e) => e.option ?? '').toList();
    List values = this.options.map((e) => e.value).toList();

    Map<String, dynamic> result = values.isEmpty
        ? {'option': options.isEmpty ? null : options[i]}
        : {'option': options.isEmpty ? null : options[i], 'value': values.isEmpty ? null : values[i]};

    Color primaryColor = MixinConfig.getConfig.primaryColor;
    double radius = MixinConfig.getConfig.radius;
    BorderRadiusGeometry borderRadius = Br.radiusOnly({'tl': radius, 'tr': radius});

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: NoScrollGlow(),
            child: Container(
              height: 300,
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                          magnification: 1,
                          useMagnifier: false,
                          itemExtent: 40,
                          offAxisFraction: 0,
                          diameterRatio: 1,
                          scrollController: FixedExtentScrollController(initialItem: i),
                          selectionOverlay: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(border: Br.only(['b'])),
                          ),

                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            if (onSelect != null) {
                              if (values.isNotEmpty) {
                                result = {'option': options[selectedItem], 'value': values.length < selectedItem ? null : values[selectedItem]};
                              } else {
                                result = {'option': options[selectedItem]};
                              }
                            }
                          },
                          children: List<Widget>.generate(options.length, (int index) {
                            return Center(
                              child: Text(
                                options[index],
                                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
                              ),
                            );
                          })),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 25,
                    blurRadius: 20,
                    offset: Offset(0, -4), // changes position of shadow
                  ),
                ],
              ),
              child: InkW(
                  onTap: () {
                    if (onSelect != null) {
                      onSelect?.call(Option.fromMap(result));
                      Navigator.pop(context);
                    }
                  },
                  margin: Ei.only(b: 20),
                  borderRadius: Br.radius(50),
                  padding: Ei.sym(v: 10, h: 45),
                  color: Mixins.hex('f1f5f9'),
                  child: Text('Select',
                      textAlign: Ta.center,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(color: primaryColor, fontWeight: Fw.bold, letterSpacing: 1))),
            ),
          )),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Touch(
                    onTap: () => Navigator.pop(context),
                    child: Iconr(
                      La.bars,
                      color: Colors.black54,
                      padding: Ei.all(20),
                    ),
                  )))
        ],
      ),
    );
  }
}

/* --------------------------------------------------------------------------
| RadioInput
| -------------------------------------------------------- */

class RadioInput extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<int> disabled;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const RadioInput({super.key, required this.label, this.options = const [], this.disabled = const [], this.controller, this.onChanged});

  @override
  State<RadioInput> createState() => _RadioInputState();
}

class _RadioInputState extends State<RadioInput> {
  String selected = '';

  @override
  void initState() {
    super.initState();
    selected = widget.options.first;
    widget.controller?.text = selected;
  }

  @override
  Widget build(BuildContext context) {
    String label = widget.label;
    List<String> options = widget.options;

    void onChanged(String value) {
      setState(() {
        selected = value;
        widget.controller?.text = value;
      });

      widget.onChanged?.call(value);
    }

    return Container(
      padding: Ei.only(l: 15, r: 15, t: 15, b: 10),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black12, width: .7), borderRadius: Br.radius(2)),
      child: Col(
        children: [
          Container(
            margin: Ei.only(b: 8),
            child: Row(
              mainAxisAlignment: Maa.spaceBetween,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14)),
              ],
            ),
          ),
          Wrap(
            children: List.generate(options.length, (i) {
              bool isDisabled = widget.disabled.contains(i);

              return InkW(
                onTap: isDisabled ? null : () => onChanged(options[i]),
                margin: Ei.only(r: 10, b: 5),
                padding: Ei.only(r: 10),
                borderRadius: Br.radius(15),
                child: Opacity(
                  opacity: isDisabled ? .5 : 1,
                  child: IgnorePointer(
                    ignoring: isDisabled,
                    child: Row(
                      mainAxisSize: Mas.min,
                      children: [
                        Radio(
                          value: options[i],
                          groupValue: selected,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                          onChanged: (value) => onChanged((value ?? options.first) as String),
                        ),
                        Textr(
                          widget.options[i],
                          margin: Ei.only(l: 10),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
