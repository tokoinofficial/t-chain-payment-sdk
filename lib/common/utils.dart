import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/data/error_message.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/crypto.dart';

const kMerchant = 'merchant';

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
      if (e is DioError && e.message != null) {
        return e.message!;
      }

      return e.message;
    } catch (_) {
      return TChainPaymentLocalizationsEn()
          .something_went_wrong_please_try_later;
    }
  }

  static late final _defaultLocalization = TChainPaymentLocalizationsEn();
  static TChainPaymentLocalizations getLocalizations(BuildContext context) {
    return TChainPaymentLocalizations.of(context) ?? _defaultLocalization;
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

  static errorToast(BuildContext context, {required String data}) {
    final errorMsg = ErrorMessage.fromString(data);
    errorToastForErrorMessage(context, errorMsg);
  }

  static errorToastForErrorMessage(
      BuildContext context, ErrorMessage errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage.getMessage(context),
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 3,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: themeColors.errorDark,
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  // User has already paid/has already withdrawn, calling this function to send back to merchant app
  // Required transaction ID because the transaction's status doesn't update immediately
  // Merchant app would check it manually once it has tnx
  static void success({
    String? bundleID,
    String? notes,
    required String txn,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'success',
      queryParameters: {
        if (notes != null) 'notes': notes,
        'txn': txn,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static void fail({
    String? bundleID,
    String? notes,
    required String txn,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'fail',
      queryParameters: {
        if (notes != null) 'notes': notes,
        'txn': txn,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static void proceeding({
    String? bundleID,
    String? notes,
    required String txn,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'proceeding',
      queryParameters: {
        if (notes != null) 'notes': notes,
        'txn': txn,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // User cancels action, calling this function to send back to merchant app
  static void cancel({
    String? bundleID,
    String? notes,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'cancelled',
      queryParameters: {
        if (notes != null) 'notes': notes,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
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
