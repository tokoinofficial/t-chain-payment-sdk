// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_chain_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TChainError _$TChainErrorFromJson(Map<String, dynamic> json) => TChainError(
      code: json['code'] as int,
      message: json['message'] as String,
    );

Map<String, dynamic> _$TChainErrorToJson(TChainError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
