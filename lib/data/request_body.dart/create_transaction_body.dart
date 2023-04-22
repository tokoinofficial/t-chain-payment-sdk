import 'package:json_annotation/json_annotation.dart';

part 'create_transaction_body.g.dart';

@JsonSerializable()
class CreateTransactionBody {
  CreateTransactionBody({
    required this.walletAddress,
    required this.externalMerchantId,
    required this.amount,
    required this.currency,
    required this.tokenName,
    required this.chainId,
    required this.notes,
  });

  @JsonKey(name: 'wallet_address')
  final String walletAddress;

  @JsonKey(name: 'external_merchant_id')
  final String externalMerchantId;

  final double amount;

  final String currency;

  @JsonKey(name: 'token_name')
  final String tokenName;

  @JsonKey(name: 'chain_id')
  final String chainId;

  final String notes;

  factory CreateTransactionBody.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionBodyFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionBodyToJson(this);
}
