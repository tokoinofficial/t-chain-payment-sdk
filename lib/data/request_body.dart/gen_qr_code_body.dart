import 'package:json_annotation/json_annotation.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

part 'gen_qr_code_body.g.dart';

@JsonSerializable()
class GenQrCodeBody {
  GenQrCodeBody({
    required this.notes,
    required this.amount,
    required this.currency,
    required this.chainId,
  });

  final String notes;
  final double amount;
  final Currency currency;

  @JsonKey(name: 'chain_id')
  final String chainId;

  factory GenQrCodeBody.fromJson(Map<String, dynamic> json) =>
      _$GenQrCodeBodyFromJson(json);
  Map<String, dynamic> toJson() => _$GenQrCodeBodyToJson(this);
}
