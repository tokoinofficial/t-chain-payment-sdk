import 'dart:math';

import 'package:equatable/equatable.dart';

class PaymentDiscountInfo extends Equatable {
  const PaymentDiscountInfo({
    required this.discountFeePercent,
    required this.deductAmount,
  });

  final double discountFeePercent;
  final double deductAmount;

  num getDiscountedServiceFee({
    required double serviceFeePercent,
    required num amount,
    required bool useToko,
  }) {
    if (serviceFeePercent == 0) return 0;

    final total = amount * serviceFeePercent / 100;

    if (!useToko) return total;

    double adjustment = discountFeePercent / serviceFeePercent;
    adjustment = max(0, min(1, adjustment));
    return total * (1 - adjustment);
  }

  @override
  List<Object?> get props => [
        discountFeePercent,
        deductAmount,
      ];
}
