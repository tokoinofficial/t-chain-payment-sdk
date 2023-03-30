import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/request_body.dart/gen_qr_code_body.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/services/t_chain_api.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

abstract class BasePaymentRepository {
  // Future<MerchantInfo?> getMerchantInfo(String qrString, double amount);

  // Future<Map<String, dynamic>?> getExchangeRate();

  // Future<MerchantTransaction?> createMerchantTransaction(
  //   String address,
  //   double amount,
  //   Currency currency,
  //   String notes,
  //   String tokenName,
  //   String merchantID,
  //   String chainID,
  // );
}

class PaymentRepository extends BasePaymentRepository {
  final TChainAPI api;

  PaymentRepository({
    required this.api,
  });

  // use bundleID to callback after having transaction result
  // in case generating QR code, let the bundleID be empty
  Future<Uri?> generateDeeplink({
    required String apiKey,
    required TChainPaymentEnv env,
    required TChainPaymentAction action,
    required String notes,
    required double amount,
    required Currency currency,
    required String chainId,
    String? bundleID,
  }) async {
    final body = GenQrCodeBody(
      notes: notes,
      amount: amount,
      currency: currency,
      chainId: chainId,
    );
    try {
      final response = await api.generateQrCode(apiKey: apiKey, body: body);

      final qrCode = response.result?.qrCode;
      if (qrCode == null) return null;

      final Map<String, dynamic> params = {
        'qr_code': qrCode,
      };

      if (bundleID != null) {
        params['bundle_id'] = bundleID;
      }

      final Uri uri = Uri(
        scheme: env.scheme,
        host: 'app',
        path: action.path,
        queryParameters: params,
      );

      return uri;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  // @override
  // Future<Map<String, dynamic>?> getExchangeRate() async {
  //   ApiResponse response = await handleResponse(api.getExchangeRate());
  //   if (!response.success) return null;

  //   return response.data as Map<String, dynamic>?;
  // }

  // @override
  // Future<MerchantInfo?> getMerchantInfo(String qrString, double? amount) async {
  //   ApiResponse response =
  //       await handleResponse(api.getMerchantInfo(qrString, amount));
  //   if (!response.success) return null;

  //   final data = response.data as Map<String, dynamic>?;
  //   if (data == null) return null;

  //   return MerchantInfo.fromMap(data);
  // }

  // @override
  // Future<MerchantTransaction?> createMerchantTransaction(
  //   String address,
  //   double amount,
  //   Currency currency,
  //   String notes,
  //   String tokenName,
  //   String merchantID,
  //   String chainID,
  // ) async {
  //   ApiResponse response = await handleResponse(api.createMerchantTransaction(
  //     address,
  //     amount,
  //     currency,
  //     notes,
  //     tokenName.toLowerCase(),
  //     merchantID,
  //     chainID,
  //   ));
  //   if (!response.success) return null;

  //   final data = response.data as Map<String, dynamic>?;
  //   if (data == null) return null;

  //   return MerchantTransaction.fromMap(data);
  // }
}
