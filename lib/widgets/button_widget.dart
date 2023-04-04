import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';

class ButtonWidget extends StatefulWidget {
  static const kDefaultHeight = 35.0;
  static const kDefaultBorderWidth = 1.0;
  static const kDefaultMargin = EdgeInsets.symmetric(horizontal: 0);

  final Function() onPressed;
  final String title;

  final TextStyle? textStyle;
  final EdgeInsetsGeometry margin;
  final bool loading;
  final bool enabled;
  final bool upperCase;
  final double height;
  final BorderRadius borderRadius;
  final double borderWidth;
  final bool fullWidth;
  final bool noPadding;
  final Color? customBorderColor;

  const ButtonWidget({
    Key? key,
    required this.onPressed,
    required this.title,
    this.fullWidth = true,
    this.loading = false,
    this.enabled = true,
    this.upperCase = true,
    this.height = kDefaultHeight,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.textStyle,
    this.noPadding = false,
    this.margin = kDefaultMargin,
    this.borderWidth = kDefaultBorderWidth,
    this.customBorderColor,
  }) : super(key: key);

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.fullWidth) return button();

    return Row(
      children: <Widget>[
        Expanded(flex: 1, child: Container()),
        button(),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  Widget button() {
    Color borderColor = oldThemeColors.primary;
    Color backgroundColor = oldThemeColors.primary;
    Color textColor = oldThemeColors.text1;

    borderColor = widget.customBorderColor ?? borderColor;

    TextStyle textStyle =
        widget.textStyle ?? themeTextStyles.button1.copyWith(color: textColor);

    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: widget.borderWidth),
          borderRadius: widget.borderRadius,
          color: backgroundColor),
      child: TextButton(
        onPressed: canPress() ? widget.onPressed : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.noPadding ? 0 : 35),
          child: Center(
            child: widget.loading
                ? const CircularProgressIndicator()
                : Text(
                    widget.title,
                    style: textStyle,
                  ),
          ),
        ),
      ),
    );
  }

  canPress() {
    return widget.enabled && !widget.loading;
  }
}
