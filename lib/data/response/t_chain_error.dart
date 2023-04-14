import 'package:json_annotation/json_annotation.dart';

part 't_chain_error.g.dart';

@JsonSerializable()
class TChainError {
  TChainError({
    required this.code,
    required this.message,
  });

  @JsonKey(name: 'code')
  final int code;

  @JsonKey(name: 'message')
  final String message;

  factory TChainError.fromJson(Map<String, dynamic> json) =>
      _$TChainErrorFromJson(json);
  Map<String, dynamic> toJson() => _$TChainErrorToJson(this);
}
