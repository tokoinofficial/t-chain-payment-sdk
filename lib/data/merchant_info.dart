import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'merchant_info.g.dart';

@CopyWith(copyWithNull: true)
@JsonSerializable()
class MerchantInfo {
  MerchantInfo({
    this.id,
    required this.merchantId,
    this.fullname = '',
    this.amount,
    required this.currency,
    this.expiredTime,
    required this.qrCode,
    required this.status,
    this.notes,
    this.chainId,
  });

  final String? id;

  @JsonKey(name: 'merchant_id')
  final String merchantId;

  final String fullname;

  final double? amount;

  final String currency;
  @JsonKey(name: 'expired_time')
  final String? expiredTime;

  @JsonKey(name: 'qr_code')
  final String qrCode;

  final int status;

  final String? notes;

  @JsonKey(name: 'chain_id')
  final String? chainId;

  bool get isDynamic => amount == null || amount! <= 0;

  factory MerchantInfo.fromJson(Map<String, dynamic> json) =>
      _$MerchantInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantInfoToJson(this);
}
