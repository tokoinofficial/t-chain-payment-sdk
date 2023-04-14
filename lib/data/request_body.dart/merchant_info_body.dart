import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'merchant_info_body.g.dart';

@JsonSerializable()
class MerchantInfoBody extends Equatable {
  const MerchantInfoBody({
    required this.qrCode,
  });

  @JsonKey(name: 'qr_code')
  final String qrCode;

  factory MerchantInfoBody.fromJson(Map<String, dynamic> json) =>
      _$MerchantInfoBodyFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantInfoBodyToJson(this);

  @override
  List<Object?> get props => [qrCode];
}
