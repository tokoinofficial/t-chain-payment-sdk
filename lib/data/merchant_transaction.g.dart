// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantTransaction _$MerchantTransactionFromJson(Map<String, dynamic> json) =>
    MerchantTransaction(
      transactionID: json['transaction_id'] as String? ?? '',
      offchain: json['offchain'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      amountUint256: json['amount_usd_big'] as String? ?? '',
      fee: (json['fee'] as num?)?.toDouble() ?? 0,
      feeUint256: json['fee_uint_256'] as String? ?? '',
      signedHash: json['signed_hash'] as String? ?? '',
      expiredTime: json['expired_time'] as int? ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$MerchantTransactionToJson(
        MerchantTransaction instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionID,
      'offchain': instance.offchain,
      'amount': instance.amount,
      'amount_usd_big': instance.amountUint256,
      'fee': instance.fee,
      'fee_uint_256': instance.feeUint256,
      'signed_hash': instance.signedHash,
      'expired_time': instance.expiredTime,
      'rate': instance.rate,
    };
