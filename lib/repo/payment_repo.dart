import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/data/request_body.dart/gen_qr_code_body.dart';
import 'package:t_chain_payment_sdk/data/response/data_response.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/services/t_chain_api.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class PaymentRepository {
  final TChainAPI api;

  PaymentRepository({
    required this.api,
  });

  // use bundleID to callback after having transaction result
  // in case generating QR code, let the bundleID be empty
  Future<Uri?> generateDeeplink({
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
      final response = await api.generateQrCode(
        apiKey: TChainPaymentSDK.instance.apiKey,
        body: body,
      );

      final qrCode = response.result?.qrCode;
      if (qrCode == null) return null;

      final Map<String, dynamic> params = {
        'qr_code': qrCode,
      };

      if (bundleID != null) {
        params['bundle_id'] = bundleID;
      }

      final Uri uri = Uri(
        scheme: TChainPaymentSDK.instance.env.scheme,
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

  Future<DataResponse<MerchantInfo>?> getMerchantInfo({
    required String qrCode,
    double? amount,
  }) async {
    try {
      final response = await api.getMerchantInfo(
        apiKey: TChainPaymentSDK.instance.apiKey,
        qrCode: qrCode,
        amount: amount,
      );

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<DataResponse<Map>?> getExchangeRate() async {
    try {
      final response = await api.getExchangeRate(
        apiKey: TChainPaymentSDK.instance.apiKey,
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

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
