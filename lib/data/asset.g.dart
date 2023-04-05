// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      assetId: json['assetId'] as int,
      contractAddress: json['contractAddress'] as String,
      balance: json['balance'] as num? ?? 0.0,
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'assetId': instance.assetId,
      'contractAddress': instance.contractAddress,
      'balance': instance.balance,
    };
