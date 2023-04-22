import 'package:flutter_test/flutter_test.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

void main() {
  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  test('PaymentDiscountInfo: test getDiscountedServiceFee', () {
    const double serviceFeePercent = 2;
    const discountInfo = PaymentDiscountInfo(
      discountFeePercent: 1, // discount on total of amount
      deductAmount: 1000,
    );

    doTest({
      required double amount,
      required bool useToko,
      required double expected,
    }) {
      expect(
        discountInfo.getDiscountedServiceFee(
          serviceFeePercent: serviceFeePercent,
          amount: amount,
          useToko: useToko,
        ),
        expected,
      );
    }

    doTest(amount: 0, useToko: false, expected: 0);
    doTest(amount: 0, useToko: true, expected: 0);
    doTest(amount: 100, useToko: false, expected: 2);
    doTest(amount: 100, useToko: true, expected: 1);
    doTest(amount: 10000, useToko: false, expected: 200);
    doTest(amount: 10000, useToko: true, expected: 100);
  });

  test(
      'PaymentDiscountInfo: test getDiscountedServiceFee without serviceFeePercent',
      () {
    const double serviceFeePercent = 0;
    const discountInfo = PaymentDiscountInfo(
      discountFeePercent: 2,
      deductAmount: 1000,
    );

    expect(
      discountInfo.getDiscountedServiceFee(
        serviceFeePercent: serviceFeePercent,
        amount: 100,
        useToko: true,
      ),
      0,
    );
  });

  test(
      'PaymentDiscountInfo: test getDiscountedServiceFee when discountFeePercent >= serviceFeePercent',
      () {
    const double serviceFeePercent = 2;
    const discountInfo = PaymentDiscountInfo(
      discountFeePercent: 2,
      deductAmount: 1000,
    );

    expect(
      discountInfo.getDiscountedServiceFee(
        serviceFeePercent: serviceFeePercent,
        amount: 100,
        useToko: false,
      ),
      2,
    );
    expect(
      discountInfo.getDiscountedServiceFee(
        serviceFeePercent: serviceFeePercent,
        amount: 100,
        useToko: true,
      ),
      0,
    );

    const discountInfo2 = PaymentDiscountInfo(
      discountFeePercent: 4,
      deductAmount: 1000,
    );

    expect(
      discountInfo2.getDiscountedServiceFee(
        serviceFeePercent: serviceFeePercent,
        amount: 100,
        useToko: false,
      ),
      2,
    );
    expect(
      discountInfo2.getDiscountedServiceFee(
        serviceFeePercent: serviceFeePercent,
        amount: 100,
        useToko: true,
      ),
      0,
    );
  });
}
