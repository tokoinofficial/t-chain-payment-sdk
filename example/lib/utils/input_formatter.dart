import 'package:flutter/services.dart';

class InputFormatter {
  static List<TextInputFormatter> positiveNumberAndZero() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
      TextInputFormatter.withFunction((oldValue, newValue) {
        try {
          String text = newValue.text;

          if (text.isNotEmpty) double.parse(text);

          return TextEditingValue(
            text: text,
            selection: newValue.selection,
            composing: newValue.composing,
          );
        } catch (_) {}

        return oldValue;
      })
    ];
  }
}
