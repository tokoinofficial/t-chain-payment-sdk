import 'package:flutter/services.dart';

enum TChainPaymentStatus {
  success,
  cancelled,
  failed,
  proceeding,
  waiting,
  error,
}

class TChainPaymentResult {
  TChainPaymentResult({
    required this.status,
    this.transactionID,
    this.orderID,
    this.errorMessage,
  });

  final TChainPaymentStatus status;
  final String? orderID;
  final String? transactionID;
  final String? errorMessage;
}
