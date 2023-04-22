import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'merchant_transaction.g.dart';

@JsonSerializable()
class MerchantTransaction extends Equatable {
  const MerchantTransaction({
    required this.merchantId,
    required this.transactionId,
    required this.offchain,
    required this.amount,
    required this.amountUint256,
    required this.fee,
    required this.feeUint256,
    required this.signedHash,
    required this.expiredTime,
    required this.rate,
  });

  @JsonKey(name: 'merchant_id', defaultValue: '')
  final String merchantId;
  @JsonKey(name: 'transaction_id', defaultValue: '')
  final String transactionId;
  @JsonKey(name: 'offchain', defaultValue: '')
  final String offchain;
  @JsonKey(name: 'amount', defaultValue: 0)
  final double amount;
  @JsonKey(name: 'amount_usd_big', defaultValue: '')
  final String amountUint256;
  @JsonKey(name: 'fee', defaultValue: 0)
  final double fee;
  @JsonKey(name: 'fee_uint_256', defaultValue: '')
  final String feeUint256;
  @JsonKey(name: 'signed_hash', defaultValue: '')
  final String signedHash;
  @JsonKey(name: 'expired_time', defaultValue: 0)
  final int expiredTime;
  @JsonKey(name: 'rate', defaultValue: 0)
  final double rate;

  factory MerchantTransaction.fromJson(Map<String, dynamic> json) =>
      _$MerchantTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantTransactionToJson(this);

  @override
  List<Object?> get props => [
        merchantId,
        transactionId,
        offchain,
        amount,
        amountUint256,
        fee,
        feeUint256,
        signedHash,
        expiredTime,
        rate,
      ];
}
