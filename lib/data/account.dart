import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:web3dart/web3dart.dart';

class Account {
  Account({required this.privateKey});

  final EthPrivateKey privateKey;
  final Map<String, Asset> _assets = {};

  Asset? getAsset({required String name}) {
    final asset = _assets[name];
    if (asset != null) return asset;

    final newAsset = Asset.createAsset(shortName: name);
    if (newAsset == null) return null;

    _assets[name] = newAsset;
    return newAsset;
  }

  updateAsset(Asset asset) {
    _assets[asset.shortName] = asset;
  }

  factory Account.fromPrivateKeyHex({required String hex}) {
    return Account(privateKey: EthPrivateKey.fromHex(hex));
  }
}
