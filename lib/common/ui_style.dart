import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';

mixin UIStyle {
  Widget buildLabel(BuildContext context, {required String title}) {
    return Text(
      title,
      style: TextStyles.subhead1.copyWith(
        color: themeColors.textSecondary,
      ),
    );
  }

  Widget buildTextFormField(
    BuildContext context, {
    Key? key,
    String? hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputAction? textInputAction,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextAlign textAlign = TextAlign.start,
    TextStyle? style,
    EdgeInsets? contentPadding,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final borderRadius = BorderRadius.circular(8);
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: themeColors.fillBgSecondary),
      borderRadius: borderRadius,
    );
    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: themeColors.errorMain),
      borderRadius: borderRadius,
    );
    final disableBorder = OutlineInputBorder(
      borderSide: BorderSide(color: themeColors.fillBgQuarternary),
      borderRadius: borderRadius,
    );

    return TextFormField(
      key: key,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      textInputAction: textInputAction,
      autofocus: false,
      style: style ??
          TextStyles.subhead1.copyWith(
            color: themeColors.textPrimary,
          ),
      obscureText: obscureText,
      obscuringCharacter: '*',
      keyboardType: keyboardType,
      focusNode: focusNode,
      onEditingComplete: () {
        if (textInputAction == TextInputAction.next) {
          if (nextFocusNode != null) {
            nextFocusNode.requestFocus();
          } else {
            FocusScope.of(context).nextFocus();
          }
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        border: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        enabledBorder: border,
        disabledBorder: disableBorder,
        helperText: ' ',
        isCollapsed: true,
        isDense: true,
        fillColor: themeColors.mainBgPrimary,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
        hintStyle: TextStyles.subhead1.copyWith(
          color: themeColors.textTertiary,
        ),
        helperStyle: TextStyles.footnote.copyWith(
          color: themeColors.errorMain,
        ),
        errorStyle: TextStyles.footnote.copyWith(
          color: themeColors.errorMain,
        ),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabled: enabled,
      ),
    );
  }

  Widget buildElevatedButton(
    BuildContext context, {
    Key? key,
    String? title,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    Function()? onPressed,
    Size? minimumSize,
  }) {
    assert(title != null || child != null);

    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: minimumSize ?? const Size.fromHeight(42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: backgroundColor ?? themeColors.primaryBlue,
        foregroundColor: foregroundColor ?? themeColors.textAccent,
        disabledBackgroundColor: themeColors.fillBgQuarternary,
        disabledForegroundColor: themeColors.textQuarternary.withOpacity(0.18),
      ),
      child: child ??
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyles.subhead2,
          ),
    );
  }

  Widget buildTextButton(
    BuildContext context, {
    Key? key,
    String? title,
    Widget? child,
    Function()? onPressed,
    bool isWarning = false,
  }) {
    assert(title != null || child != null);

    return TextButton(
      key: key,
      onPressed: onPressed,
      style: TextButton.styleFrom(
        elevation: 0,
        minimumSize: const Size.fromHeight(42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor:
            isWarning ? themeColors.errorMain : themeColors.primaryBlue,
      ),
      child: child ??
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyles.subhead2,
          ),
    );
  }

  Widget buildOutlinedButton(
    BuildContext context, {
    Key? key,
    String? title,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Function()? onPressed,
    bool isWarning = false,
    BorderRadius? borderRadius,
  }) {
    assert(title != null || child != null);

    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: BorderSide(
          width: 1,
          color: onPressed == null
              ? themeColors.textQuarternary
              : (borderColor ?? themeColors.primaryBlue),
        ),
        minimumSize: const Size.fromHeight(42),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        backgroundColor: backgroundColor ?? Colors.white,
        foregroundColor: foregroundColor ?? themeColors.primaryBlue,
        padding: const EdgeInsets.all(0),
      ),
      child: child ??
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyles.subhead2,
          ),
    );
  }
}
