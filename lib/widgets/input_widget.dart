import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';

const kDefaultHeight = 70.0;

class InputWidget extends StatefulWidget {
  final double? height;
  final String title;
  final bool isPwd;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final TextStyle? errorStyle;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function? onSaved;
  final Widget? appendChild;
  final Widget? prefixWidget;
  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool autoFocus;
  final String? initialValue;
  final double contentPaddingRight;
  final double contentPaddingTop;
  final double contentPaddingBottom;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget Function(BuildContext, Widget)? widgetBuilder;

  const InputWidget(
      {Key? key,
      required this.title,
      this.textInputAction = TextInputAction.done,
      this.height = kDefaultHeight,
      this.initialValue,
      this.prefixWidget,
      this.autoFocus = false,
      this.focusNode,
      this.onChanged,
      this.maxLines = 1,
      this.minLines = 1,
      this.isPwd = false,
      this.enabled = true,
      this.hintText = '',
      this.titleStyle,
      this.textStyle,
      this.errorStyle,
      this.keyboardType = TextInputType.emailAddress,
      this.validator,
      this.appendChild,
      this.onSaved,
      this.inputFormatters,
      this.controller,
      this.contentPaddingRight = 60,
      this.contentPaddingTop = 15,
      this.contentPaddingBottom = 15,
      this.maxLength,
      this.suffixIcon,
      this.widgetBuilder})
      : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late bool _isShowPwd;
  final _textController = TextEditingController();

  @override
  void initState() {
    _isShowPwd = false;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: widget.appendChild == null && !widget.isPwd
          ? _buildTextField()
          : Stack(
              children: [
                _buildTextField(),
                widget.appendChild ??
                    Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(
                          top: kDefaultHeight / 4, right: 15),
                      child: _showPwd(),
                    ),
              ],
            ),
    );
  }

  Widget _buildTextField() {
    TextStyle textStyle = widget.textStyle ??
        themeTextStyles.body1.copyWith(color: oldThemeColors.text1);
    TextStyle titleStyle = widget.titleStyle ??
        themeTextStyles.subTitle1.copyWith(color: oldThemeColors.text9);
    Color borderColor = oldThemeColors.primary;
    final child = TextFormField(
      initialValue: widget.initialValue,
      controller: widget.initialValue != null
          ? null
          : widget.controller ?? _textController,
      key: Key(widget.title),
      inputFormatters: widget.inputFormatters,
      onEditingComplete: () => {
        widget.textInputAction == TextInputAction.done
            ? FocusScope.of(context).unfocus()
            : FocusScope.of(context).nextFocus()
      },
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      autofocus: widget.autoFocus,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onSaved: (value) {
        if (widget.onSaved != null) widget.onSaved!(value!.trim());
      },
      style: textStyle,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      obscureText: (widget.isPwd) ? ((_isShowPwd) ? false : true) : false,
      decoration: InputDecoration(
        counterText: "",
        fillColor: oldThemeColors.primary,
        filled: !widget.enabled,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.fromLTRB(20, widget.contentPaddingTop,
            widget.contentPaddingRight, widget.contentPaddingBottom),
        border: InputBorder.none,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.3),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.3),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.3),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.3),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.3),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        prefixIcon: widget.prefixWidget,
        labelText: widget.title,
        labelStyle: titleStyle,
        errorStyle: widget.errorStyle ??
            themeTextStyles.body4.copyWith(color: oldThemeColors.statusError),
        suffixIcon: widget.suffixIcon,
      ),
      enabled: widget.enabled,
    );

    return widget.widgetBuilder?.call(context, child) ?? child;
  }

  _showPwd() {
    if (widget.isPwd) {
      return InkWell(
          onTap: () {
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
          child: Icon(_isShowPwd
              ? CupertinoIcons.eye_fill
              : CupertinoIcons.eye_slash_fill));
    }
    return Container();
  }
}
