import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/const.dart';

part 'asset.g.dart';

@CopyWith()
@JsonSerializable()
class Asset extends Equatable {
  const Asset({
    required this.contractAddress,
    required this.fullName,
    required this.shortName,
    required this.iconName,
    this.balance = 0.0,
  });

  static Asset? createAsset({required String shortName}) {
    String? contractAddress;
    switch (shortName.toUpperCase()) {
      case CONST.kAssetNameBNB:
        contractAddress = '';
        break;
      case CONST.kAssetNameTOKO:
        contractAddress = Config.bscTokoinContractAddress;
        break;
      case CONST.kAssetNameUSDT:
        contractAddress = Config.bscUsdtContractAddress;
        break;
      case CONST.kAssetNameBUSD:
        contractAddress = Config.bscBinanceUsdContractAddress;
        break;
    }

    if (contractAddress == null) return null;

    final fullName = CONST.kAssetFullnameMap[shortName] ?? shortName;
    final iconName = CONST.kAssetIconMap[shortName] ?? '';

    return Asset(
      contractAddress: contractAddress,
      shortName: shortName.toUpperCase(),
      fullName: fullName,
      iconName: iconName,
    );
  }

  final String contractAddress;
  final String shortName;
  final String fullName;
  final String iconName;
  final double balance;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);

  @override
  List<Object?> get props => [
        contractAddress,
        shortName,
        fullName,
        iconName,
        balance,
      ];

  bool get isStableCoin =>
      contractAddress == Config.bscUsdtContractAddress ||
      contractAddress == Config.bscBinanceUsdContractAddress;
  bool get isBnb => contractAddress == '';
  bool get isToko => contractAddress == Config.bscTokoinContractAddress;
  bool get isNotToko => contractAddress != Config.bscTokoinContractAddress;
  bool get isUsdt => contractAddress == Config.bscUsdtContractAddress;
}
