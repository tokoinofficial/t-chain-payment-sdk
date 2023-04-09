import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:web3dart/crypto.dart';

class Utils {
  /// ethereum address: contains 0x and 42 characters long
  ///
  static bool isValidEthereumAddress(String address) {
    RegExp exp = RegExp(r"^(0x)?([0-9a-fA-F]){40}$");
    return exp.hasMatch(address);
  }

  static bool isEmptyString(String? amountStr) {
    return amountStr == null || amountStr.isEmpty;
  }

  static String getErrorMsg(e) {
    try {
      if (e is DioError) {
        return e.message ??
            TChainPaymentLocalizationsEn()
                .something_went_wrong_please_try_later;
      }

      return e.message;
    } catch (_) {
      return TChainPaymentLocalizationsEn()
          .something_went_wrong_please_try_later;
    }
  }

  static toast(dynamic str) {
    Fluttertoast.showToast(
        msg: str.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  static errorToast(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 3,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red.shade400,
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }
}

extension StringExt on String {
  Uint8List toBytes32() {
    if (startsWith('0x')) {
      return hexToBytes(this);
    }

    if (length < 32) {
      return ascii.encode(padRight(32, ' '));
    }

    return ascii.encode(this);
  }

  List<int> toBytes() {
    return utf8.encode(this);
  }

  String get shortAddress {
    if (length <= 10) {
      return this;
    }

    return '${substring(0, 6)}...${substring(length - 4, length)}';
  }

  String get shortTransaction {
    if (length <= 10) {
      return this;
    }

    return '${substring(0, 8)}...';
  }
}

extension DoubleExt on double {
  String removeTrailingZeros({int? fractionDigits}) {
    if (this % 1 == 0) {
      return toInt().toString();
    }

    final strValue = toString();
    if (fractionDigits == null) {
      return strValue;
    }

    final parts = strValue.split('.');
    if (parts.length == 2) {
      return toStringAsFixed(min(fractionDigits, parts[1].length));
    }

    return strValue;
  }

  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
