import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

const kEthPowExponent = 18;
final currencyNumberFormat = NumberFormat("#,##0", "en_US");

/// TokoinNumber class is created to
/// - wrap BigInt to use for floating point number
/// - use for calculating TokoinNumber directly (support +, -, *, /, <, <=, >, >=, ==)
///
/// Usage
/// To Create:
/// - [TokoinNumber.fromNumber]: requires a num and an exponent if it has been multiplying exponents, the default value of the exponent is [kEthPowExponent]
/// - [TokoinNumber.fromBigInt]: required a BigInt and its exponent
///
/// To calculate:
/// - use operator +, -, *, /, <, <=, >, >=, == normally
///
/// To display its value:
/// - use [getFormalizedString] if you want to display it in human readable format
/// - use [getClosestStringValue(decimals)] if you want to display it with maximum of n decimal places
/// - otherwise, use [stringValue]
class TokoinNumber {
  late BigInt bigIntValue;
  final int exponent;

  TokoinNumber.fromBigInt(
    BigInt? bigInt, {
    required this.exponent,
  }) {
    bigIntValue = bigInt ?? BigInt.zero;
  }

  TokoinNumber.fromNumber(
    num? value, {
    this.exponent = kEthPowExponent,
  }) {
    bigIntValue = (value ?? 0).toBigIntBasedOnDecimal(decimals: exponent);
  }

  // [numberValue] is an approximate number
  double get doubleValue => bigIntValue / BigInt.from(pow(10, exponent));

// Get closest double value of [doubleValue]
// The parameter [decimals] must be an integer satisfying: 0 <= fractionDigits <= 20.
// Examples: doubleValue is 4321.12345678
// (4321.12345678).toStringAsFixed(3);  // 4321.123
// (4321.12345678).toStringAsFixed(5);  // 4321.12346
  double getClosestDoubleValue({int decimals = kEthPowExponent}) {
    return double.parse(doubleValue.toStringAsFixed(decimals));
  }

  String get stringValue {
    final txt = bigIntValue.toString();

    String result = '0';

    if (txt.length > exponent) {
      String result = txt.substring(0, txt.length - exponent);

      String decimalNumber = txt
          .substring(txt.length - exponent, txt.length)
          .replaceAll(RegExp(r'0*$'), '');

      if (decimalNumber.isNotEmpty) {
        result += '.' + decimalNumber;
      }

      return result;
    }

    result =
        '0.' + List.generate(exponent - txt.length, (index) => 0).join() + txt;

    return result.replaceAll(RegExp(r'0*$'), '');
  }

// Get closest string representation
// The parameter [decimals] must be an integer satisfying: 0 <= fractionDigits <= 20.
// Examples: doubleValue is 4321.12345678
// (4321.12345678).toStringAsFixed(3);  // 4321.123
// (4321.12345678).toStringAsFixed(5);  // 4321.12346
  String getClosestStringValue({int decimals = kEthPowExponent}) {
    final txt = bigIntValue.toString();

    if (txt.length > exponent) {
      String result = txt.substring(0, txt.length - exponent);

      String decimalNumber = txt.substring(txt.length - exponent, txt.length);
      decimalNumber = decimalNumber
          .substring(0, min(decimals, decimalNumber.length))
          .replaceAll(RegExp(r'0*$'), '');

      if (decimalNumber.isNotEmpty) {
        result += '.' + decimalNumber;
      }

      return result;
    }

    String decimalNumber =
        List.generate(exponent - txt.length, (index) => 0).join() + txt;
    decimalNumber = decimalNumber
        .substring(0, min(decimals, decimalNumber.length))
        .replaceAll(RegExp(r'0*$'), '');

    if (decimalNumber.isNotEmpty) {
      return '0.' + decimalNumber;
    }

    return '0';
  }

// Get closest string representation in human readable format
// The parameter [decimals] must be an integer satisfying: 0 <= fractionDigits <= 20.
// Examples: doubleValue is 4321.12345678
// (4321.12345678).toStringAsFixed(3);  // 4,321.123
// (4321.12345678).toStringAsFixed(5);  // 4,321.12346
  String getFormalizedString({int decimals = kEthPowExponent}) {
    String string = stringValue;
    if (string.contains('e')) {
      string = doubleValue.toStringAsFixed(
          exponent + 1); // + 1: to make sure the number is not rounded
    }

    final strings = string.split('.');
    var mainNumber = strings.first;
    var formattedNumber = currencyNumberFormat.format(double.parse(mainNumber));

    // decimal number
    if (strings.length > 1) {
      String decimalNumber = strings.last
          .substring(0, min(decimals, strings.last.length))
          .replaceAll(RegExp(r'0*$'), '');

      if (decimalNumber.isNotEmpty) {
        formattedNumber += '.' + decimalNumber;
      }
    }

    return formattedNumber;
  }

  TokoinNumber toTokoinNumberWithExponent(int destinationExponent) {
    if (exponent <= destinationExponent) {
      return TokoinNumber.fromBigInt(
        bigIntValue * BigInt.from(pow(10, destinationExponent - exponent)),
        exponent: destinationExponent,
      );
    }

    return TokoinNumber.fromNumber(
      bigIntValue / BigInt.from(pow(10, exponent - destinationExponent)),
      exponent: destinationExponent,
    );
  }

  TokoinNumber operator +(TokoinNumber other) {
    if (other.exponent == exponent) {
      return TokoinNumber.fromBigInt(bigIntValue + other.bigIntValue,
          exponent: exponent);
    }

    final newExponent = max(exponent, other.exponent);
    return TokoinNumber.fromBigInt(
      toTokoinNumberWithExponent(newExponent).bigIntValue +
          other.toTokoinNumberWithExponent(newExponent).bigIntValue,
      exponent: newExponent,
    );
  }

  TokoinNumber operator -(TokoinNumber other) {
    if (other.exponent == exponent) {
      return TokoinNumber.fromBigInt(bigIntValue - other.bigIntValue,
          exponent: exponent);
    }

    final newExponent = max(exponent, other.exponent);
    return TokoinNumber.fromBigInt(
      toTokoinNumberWithExponent(newExponent).bigIntValue -
          other.toTokoinNumberWithExponent(newExponent).bigIntValue,
      exponent: newExponent,
    );
  }

  TokoinNumber operator *(TokoinNumber other) {
    return TokoinNumber.fromBigInt(bigIntValue * other.bigIntValue,
        exponent: exponent + other.exponent);
  }

  double operator /(TokoinNumber other) {
    if (other.exponent == exponent) {
      return bigIntValue / other.bigIntValue;
    }

    final newExponent = max(exponent, other.exponent);
    return toTokoinNumberWithExponent(newExponent).bigIntValue /
        other.toTokoinNumberWithExponent(newExponent).bigIntValue;
  }

  bool operator >(TokoinNumber other) {
    return (this - other).doubleValue > 0;
  }

  bool operator >=(TokoinNumber other) {
    return (this - other).doubleValue >= 0;
  }

  @override
  bool operator ==(other) {
    if (other is! TokoinNumber) return false;
    return (this - other).doubleValue == 0;
  }

  bool operator <(TokoinNumber other) {
    return (this - other).doubleValue < 0;
  }

  bool operator <=(TokoinNumber other) {
    return (this - other).doubleValue <= 0;
  }

  @override
  int get hashCode => bigIntValue.hashCode + exponent.hashCode;
}

extension DoubleExt on num {
  // 0.06527841242900972
  // expected: 65278412429009720
  // if you use `toBigInt`, the result will be 65278412429009728
  BigInt toBigIntBasedOnDecimal({decimals = kEthPowExponent}) {
    String string = Decimal.tryParse(toString())?.toString() ?? '0';
    final strings = string.split('.');

    // decimal number
    if (strings.length == 2) {
      String decimalNumber = strings.last;

      if (decimalNumber.length <= decimals) {
        final strValue = strings.first + decimalNumber;
        return BigInt.parse(strValue) *
            BigInt.from(pow(10, decimals - decimalNumber.length));
      } else {
        final strValue = strings.first + decimalNumber.substring(0, decimals);
        return BigInt.parse(strValue);
      }
    }

    // integer number
    return BigInt.from(this) * BigInt.from(pow(10, decimals));
  }
}
