import 'package:equatable/equatable.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/currency.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';

class TransferData extends Equatable {
  const TransferData({
    required this.asset,
    this.tokoAsset,
    this.discountInfo,
    this.gasFee,
    this.serviceFeePercent,
    this.exchangeRate,
    this.amount,
    required this.currency,
  });

  final Asset asset;
  final Asset? tokoAsset;
  final PaymentDiscountInfo? discountInfo;
  final GasFee? gasFee;
  final double? serviceFeePercent;
  final double? exchangeRate;
  final double? amount;
  final Currency currency;

  double? get transferAmount =>
      amount != null && exchangeRate != null ? amount! / exchangeRate! : null;

  @override
  List<Object?> get props => [
        asset,
        tokoAsset,
        discountInfo,
        gasFee,
        serviceFeePercent,
        exchangeRate,
        amount,
        currency,
      ];
}
