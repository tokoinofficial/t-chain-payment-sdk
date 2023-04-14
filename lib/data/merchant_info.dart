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
// class MerchantInfo {
  

  // static const KEY_ID = 'id';
  // static const KEY_MERCHANT_ID = 'merchant_id';
  // static const KEY_FULLNAME = 'fullname';
  // static const KEY_AMOUNT = 'amount';
  // static const KEY_CURRENCY = 'currency';
  // static const KEY_EXPIRED_TIME = 'expired_time';
  // static const KEY_QR_CODE = 'qr_code';
  // static const KEY_STATUS = 'status';
  // static const KEY_NOTES = 'notes';
  // static const KEY_CHAIN_ID = 'chain_id';

  // factory MerchantInfo.fromMap(Map<String, dynamic> map) => MerchantInfo(
  //       id: map[KEY_ID] as String? ?? '',
  //       merchantID: map[KEY_MERCHANT_ID] as String? ?? '',
  //       fullname: map[KEY_FULLNAME] as String? ?? '',
  //       amount: double.tryParse(map[KEY_AMOUNT].toString()),
  //       currency: map[KEY_CURRENCY] as String? ?? '',
  //       expiredTime: map[KEY_EXPIRED_TIME] as String? ?? '',
  //       qrCode: map[KEY_QR_CODE] as String? ?? '',
  //       status: map[KEY_STATUS] as int? ?? 0,
  //       notes: map[KEY_NOTES] as String?,
  //       chainID: int.tryParse(map[KEY_CHAIN_ID] as String? ?? ''),
  //     );

  // MerchantInfo copyWith({
  //   String? id,
  //   String? merchantID,
  //   String? fullname,
  //   double? amount,
  //   String? currency,
  //   String? expiredTime,
  //   String? qrCode,
  //   int? status,
  //   String? notes,
  //   int? chainID,
  // }) =>
  //     MerchantInfo(
  //       id: id ?? this.id,
  //       merchantID: merchantID ?? this.merchantID,
  //       fullname: fullname ?? this.fullname,
  //       amount: amount ?? this.amount,
  //       currency: currency ?? this.currency,
  //       expiredTime: expiredTime ?? this.expiredTime,
  //       qrCode: qrCode ?? this.qrCode,
  //       status: status ?? this.status,
  //       notes: notes ?? this.notes,
  //       chainID: chainID ?? this.chainID,
  //     );

  // Map<String, dynamic> toJson() => {
  //       KEY_ID: id,
  //       KEY_MERCHANT_ID: merchantID,
  //       KEY_FULLNAME: fullname,
  //       KEY_AMOUNT: amount,
  //       KEY_CURRENCY: currency,
  //       KEY_EXPIRED_TIME: expiredTime,
  //       KEY_QR_CODE: qrCode,
  //       KEY_STATUS: status,
  //       KEY_NOTES: notes,
  //       KEY_CHAIN_ID: chainID,
  //     };
// }
