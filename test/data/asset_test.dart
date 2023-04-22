import 'package:flutter_test/flutter_test.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

void main() {
  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  test('Asset - create asset', () {
    // test uppercase name
    final toko = Asset.createAsset(shortName: 'TOKO');
    expect(toko, isNotNull);

    // test lowercase name
    final bnb = Asset.createAsset(shortName: 'bnb');
    expect(bnb, isNotNull);

    // invalid asset name
    final nullAsset = Asset.createAsset(shortName: 'abc');
    expect(nullAsset, null);
  });
}
