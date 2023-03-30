// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen_qr_code_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenQrCodeBody _$GenQrCodeBodyFromJson(Map<String, dynamic> json) =>
    GenQrCodeBody(
      notes: json['notes'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
      chainId: json['chain_id'] as String,
    );

Map<String, dynamic> _$GenQrCodeBodyToJson(GenQrCodeBody instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'amount': instance.amount,
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'chain_id': instance.chainId,
    };

const _$CurrencyEnumMap = {
  Currency.usd: 'USD',
  Currency.idr: 'IDR',
};
