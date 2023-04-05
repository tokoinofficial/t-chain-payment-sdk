import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/const.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset extends Equatable {
  const Asset({
    required this.assetId,
    required this.contractAddress,
    this.balance = 0.0,
  });

  static Asset? createAssetFrom({required int assetId}) {
    switch (assetId) {
      case CONST.ASSET_ID_BNB:
        return Asset(
            assetId: assetId, contractAddress: Config.bnbContractAddress);
      case CONST.ASSET_ID_TOKO:
        return Asset(
            assetId: assetId, contractAddress: Config.bscTokoinContractAddress);
      case CONST.ASSET_ID_USDT:
        return Asset(
            assetId: assetId, contractAddress: Config.bscUsdtContractAddress);
      case CONST.ASSET_ID_CAKE:
        return Asset(
            assetId: assetId, contractAddress: Config.bscCakeContractAddress);
      case CONST.ASSET_ID_BUSD:
        return Asset(
            assetId: assetId,
            contractAddress: Config.bscBinanceUsdContractAddress);
      case CONST.ASSET_ID_TKO:
        return Asset(
            assetId: assetId, contractAddress: Config.bscTkoContractAddress);
      case CONST.ASSET_ID_SZO:
        return Asset(
            assetId: assetId, contractAddress: Config.bscSzoContractAddress);
      case CONST.ASSET_ID_DEP:
        return Asset(
            assetId: assetId, contractAddress: Config.bscDepContractAddress);
      case CONST.ASSET_ID_DOT:
        return Asset(
            assetId: assetId, contractAddress: Config.bscDotContractAddress);
      case CONST.ASSET_ID_DOGE:
        return Asset(
            assetId: assetId, contractAddress: Config.bscDogeContractAddress);
      case CONST.ASSET_ID_C98:
        return Asset(
            assetId: assetId, contractAddress: Config.bscC98ContractAddress);
    }

    return null;
  }

  final int assetId;
  final String contractAddress;
  final num balance;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);

  @override
  List<Object?> get props => [
        assetId,
        contractAddress,
        balance,
      ];

  String fullName() => CONST.ASSET_FULLNAME[assetId.toString()]!;
  String shortName() => CONST.ASSET_SHORTNAME[assetId.toString()]!;
  String iconName() => CONST.ASSET_ICON_NAME[assetId.toString()]!;

  bool get isStableCoin =>
      contractAddress == Config.bscUsdtContractAddress ||
      contractAddress == Config.bscBinanceUsdContractAddress;
  bool get isBnb => contractAddress == Config.bnbContractAddress;
  bool get isToko => contractAddress == Config.bscTokoinContractAddress;
  bool get isNotToko => contractAddress != Config.bscTokoinContractAddress;
}
