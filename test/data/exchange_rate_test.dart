import 'package:flutter_test/flutter_test.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/const.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/exchange_rate.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

void main() {
  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  test('ExchangeRate - test calculateAssetAmount', () {
    const exToko = 0.0031312488078522826;
    const exBnb = 327.54587667254754;
    const exBusd = 0.9993735346545763;
    const exUsdt = 1.0010710336417492;
    const exIdr = 0.00006544502617801048;
    final exchangeRate = ExchangeRate({
      "BNB": exBnb,
      "BUSD": exBusd,
      "IDR": exIdr,
      "TOKO": exToko,
      "USDT": exUsdt,
    });

    // token
    final toko = Asset.createAsset(shortName: CONST.kAssetNameTOKO)!;
    final bnb = Asset.createAsset(shortName: CONST.kAssetNameBNB)!;
    final usdt = Asset.createAsset(shortName: CONST.kAssetNameUSDT)!;
    final busd = Asset.createAsset(shortName: CONST.kAssetNameBUSD)!;

    // token that doesn't exist in exchangeRate
    final unsupportedToken = Asset.createAsset(shortName: 'TKO');

    doTest(
      Currency currency, {
      required double amount,
      required Asset? asset,
      required double? expected,
    }) {
      if (asset == null) {
        expect(expected, null);
        return;
      }

      expect(
        exchangeRate.calculateAssetAmount(
          amountCurrency: amount,
          currency: currency,
          asset: asset,
        ),
        expected,
      );
    }

    // usd
    doTest(Currency.usd, amount: 0, asset: toko, expected: 0);
    doTest(Currency.usd, amount: 11, asset: toko, expected: 11 / exToko);
    doTest(Currency.usd, amount: 100, asset: toko, expected: 100 / exToko);
    doTest(Currency.usd, amount: 100, asset: bnb, expected: 100 / exBnb);
    doTest(Currency.usd, amount: 100, asset: usdt, expected: 100 / exUsdt);
    doTest(Currency.usd, amount: 100, asset: busd, expected: 100 / exBusd);
    doTest(Currency.usd, amount: 100, asset: unsupportedToken, expected: null);

    // idr
    doTest(Currency.idr, amount: 0, asset: toko, expected: 0);
    doTest(Currency.idr,
        amount: 11, asset: toko, expected: 11 * exIdr / exToko);
    doTest(Currency.idr,
        amount: 100, asset: toko, expected: 100 * exIdr / exToko);
    doTest(Currency.idr,
        amount: 100, asset: bnb, expected: 100 * exIdr / exBnb);
    doTest(Currency.idr,
        amount: 100, asset: usdt, expected: 100 * exIdr / exUsdt);
    doTest(Currency.idr,
        amount: 100, asset: busd, expected: 100 * exIdr / exBusd);
    doTest(Currency.idr, amount: 100, asset: unsupportedToken, expected: null);
  });
}
