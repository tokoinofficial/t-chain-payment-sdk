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
    switch (shortName) {
      case CONST.kAssetNameBNB:
        contractAddress = Config.bnbContractAddress;
        break;
      case CONST.kAssetNameTOKO:
        contractAddress = Config.bscTokoinContractAddress;
        break;
      case CONST.kAssetNameUSDT:
        contractAddress = Config.bscUsdtContractAddress;
        break;
      case CONST.kAssetNameCAKE:
        contractAddress = Config.bscCakeContractAddress;
        break;
      case CONST.kAssetNameBUSD:
        contractAddress = Config.bscBinanceUsdContractAddress;
        break;
      case CONST.kAssetNameTKO:
        contractAddress = Config.bscTkoContractAddress;
        break;
      case CONST.kAssetNameSZO:
        contractAddress = Config.bscSzoContractAddress;
        break;
      case CONST.kAssetNameDEP:
        contractAddress = Config.bscDepContractAddress;
        break;
      case CONST.kAssetNameDOT:
        contractAddress = Config.bscDotContractAddress;
        break;
      case CONST.kAssetNameDOGE:
        contractAddress = Config.bscDogeContractAddress;
        break;
      case CONST.kAssetNameC98:
        contractAddress = Config.bscC98ContractAddress;
        break;
    }

    if (contractAddress == null) return null;

    final fullName = CONST.kAssetFullnameMap[shortName] ?? shortName;
    final iconName = CONST.kAssetIconMap[shortName] ?? '';

    return Asset(
      contractAddress: contractAddress,
      shortName: shortName,
      fullName: fullName,
      iconName: iconName,
    );
  }

  final String contractAddress;
  final String shortName;
  final String fullName;
  final String iconName;
  final num balance;

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
  bool get isBnb => contractAddress == Config.bnbContractAddress;
  bool get isToko => contractAddress == Config.bscTokoinContractAddress;
  bool get isNotToko => contractAddress != Config.bscTokoinContractAddress;
}
