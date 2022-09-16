import 'dart:typed_data';
import 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TChainPaymentQRResult extends TChainPaymentResult {
  TChainPaymentQRResult({
    required TChainPaymentStatus status,
    required String orderID,
    String? transactionID,
    String? errorMessage,
    this.qrData,
  }) : super(
          status: status,
          orderID: orderID,
          transactionID: transactionID,
          errorMessage: errorMessage,
        );

  final ByteData? qrData;
}

extension TChainPaymentQRResultExt on TChainPaymentQRResult {
  Image? get qrImage {
    if (qrData == null) return null;

    final image = Image.memory(qrData!.buffer.asUint8List());
    return image;
  }
}
