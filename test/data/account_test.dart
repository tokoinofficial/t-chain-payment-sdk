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
    final account = Account.fromPrivateKeyHex(
      hex: '0097ad7d1294e0268bbaaf4642c6ccb4c4a76421bff0285023716e354c605513ee',
    );

    // automatically create valid asset
    final toko = account.getAsset(name: CONST.kAssetNameTOKO);
    expect(toko, isNotNull);

    // update balance
    account.updateAsset(toko!.copyWith(balance: 100));

    // get existing token
    final toko2 = account.getAsset(name: CONST.kAssetNameTOKO);
    expect(toko2?.balance, 100);

    // invalid asset
    final nullAsset = account.getAsset(name: 'abc');
    expect(nullAsset, null);
  });
}
