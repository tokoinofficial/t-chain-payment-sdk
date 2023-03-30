// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantInfo _$MerchantInfoFromJson(Map<String, dynamic> json) => MerchantInfo(
      id: json['id'] as String?,
      merchantId: json['merchant_id'] as String,
      fullname: json['fullname'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      expiredTime: json['expired_time'] as String?,
      qrCode: json['qr_code'] as String,
      status: json['status'] as int,
      notes: json['notes'] as String?,
      chainId: json['chain_id'] as String? ?? '$kTestnetChainID',
    );

Map<String, dynamic> _$MerchantInfoToJson(MerchantInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchant_id': instance.merchantId,
      'fullname': instance.fullname,
      'amount': instance.amount,
      'currency': instance.currency,
      'expired_time': instance.expiredTime,
      'qr_code': instance.qrCode,
      'status': instance.status,
      'notes': instance.notes,
      'chain_id': instance.chainId,
    };
