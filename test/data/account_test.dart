// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/const.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

void main() {
  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  test('Account - get asset', () {
    final account = Account(privateKeyHex: 'privateKeyHex');

    // automatically create valid asset
    final toko = account.getAsset(name: CONST.kAssetNameTOKO);
    expect(toko, isNotNull);

    // update balance
    account.updateAsset(toko.copyWith(balance: 100));

    // get existing token
    final toko2 = account.getAsset(name: CONST.kAssetNameTOKO);
    expect(toko2.balance, 100);

    // invalid asset
    final nullAsset = account.getAsset(name: 'abc');
    expect(nullAsset, null);
  });
}
