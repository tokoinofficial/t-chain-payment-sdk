import 'dart:typed_data';
import 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The returning data when you perform [generateQrCode]. It contains a [qrData]
/// which is being used for generating QR image
class TChainPaymentQRResult extends TChainPaymentResult {
  TChainPaymentQRResult({
    required TChainPaymentStatus status,
    required String notes,
    String? transactionID,
    String? errorMessage,
    this.qrData,
  }) : super(
          status: status,
          notes: notes,
          transactionID: transactionID,
          errorMessage: errorMessage,
        );

  /// Used for generating QR image
  final ByteData? qrData;
}

extension TChainPaymentQRResultExt on TChainPaymentQRResult {
  /// Generate QR image from QR data
  Image? get qrImage {
    if (qrData == null) return null;

    final image = Image.memory(qrData!.buffer.asUint8List());
    return image;
  }
}
