import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/config/const.dart';

class ErrorMessage extends Equatable {
  const ErrorMessage({
    required this.error,
    this.toFix = '',
    this.nextAction = '',
  });

  final String error;
  final String toFix;
  final String nextAction;

  getMessage(BuildContext context) {
    List<String> list = [];

    if (error.endsWith('.')) {
      list.add(error);
    } else {
      list.add('$error.');
    }

    final toFixMsg = toFix.isNotEmpty
        ? toFix
        : Utils.getLocalizations(context).to_fix_please_try_again;
    if (toFixMsg.endsWith('.')) {
      list.add(toFixMsg);
    } else {
      list.add('$toFix.');
    }

    final nextActionMsg = nextAction.isNotEmpty
        ? nextAction
        : Utils.getLocalizations(context)
            .still_not_working_contact_email_for_customer_support(
                CONST.supportEmail);
    if (nextActionMsg.endsWith('.')) {
      list.add(nextActionMsg);
    } else {
      list.add('$nextActionMsg.');
    }

    return list.join(' ');
  }

  String toJsonString() {
    return '{"error": "$error", "toFix":"$toFix", "nextAction":"$nextAction"}';
  }

  factory ErrorMessage.fromString(String data) {
    String? error, toFix, nextAction;

    try {
      final map = jsonDecode(data) as Map<String, dynamic>?;
      error = map?['error'];
      toFix = map?['toFix'];
      nextAction = map?['nextAction'];
    } catch (_) {}

    if (error != null) {
      return ErrorMessage(
        error: error,
        toFix: toFix ?? '',
        nextAction: nextAction ?? '',
      );
    }
    return ErrorMessage(error: data);
  }

  @override
  List<Object?> get props => [
        error,
        toFix,
        nextAction,
      ];
}
