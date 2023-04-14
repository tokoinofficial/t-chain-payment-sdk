// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transaction_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTransactionBody _$CreateTransactionBodyFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionBody(
      walletAddress: json['wallet_address'] as String,
      merchantId: json['merchant_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      tokenName: json['token_name'] as String,
      chainId: json['chain_id'] as String,
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$CreateTransactionBodyToJson(
        CreateTransactionBody instance) =>
    <String, dynamic>{
      'wallet_address': instance.walletAddress,
      'merchant_id': instance.merchantId,
      'amount': instance.amount,
      'currency': instance.currency,
      'token_name': instance.tokenName,
      'chain_id': instance.chainId,
      'notes': instance.notes,
    };
