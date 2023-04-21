import 'package:flutter_test/flutter_test.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';

void main() {
  setUp(() {});

  test('test tokoin number initial', () {
    final num1 = TokoinNumber.fromNumber(1);
    expect(num1.stringValue, '1');

    final num2 = TokoinNumber.fromNumber(444);
    expect(num2.stringValue, '444');

    final num3 = TokoinNumber.fromNumber(999999999999999);
    expect(num3.stringValue, '999999999999999');

    // max exponent is 20
    final num4 = TokoinNumber.fromNumber(
      0.00000000000000000001,
      exponent: 20,
    );
    expect(num4.stringValue, '0.00000000000000000001');

    final num5 = TokoinNumber.fromBigInt(BigInt.from(1), exponent: 0);
    expect(num5.stringValue, '1');

    final num6 = TokoinNumber.fromBigInt(BigInt.from(9999), exponent: 0);
    expect(num6.stringValue, '9999');

    final num7 = TokoinNumber.fromBigInt(BigInt.from(1000), exponent: 3);
    expect(num7.stringValue, '1');

    final num8 = TokoinNumber.fromNumber(
      0.00000000000000000000001,
      exponent: 23,
    );
    expect(num8.stringValue, '0.00000000000000000000001');

    final num9 = TokoinNumber.fromBigInt(
      BigInt.parse('100000000000000000000000'),
      exponent: 23,
    );
    expect(num9.stringValue, '1');
  });

  test('test tokoin number calculation', () {
    final n_1 = TokoinNumber.fromNumber(1);
    final n_2 = TokoinNumber.fromNumber(2);
    final n_11 = TokoinNumber.fromNumber(11);

    final n_999999999999999 = TokoinNumber.fromNumber(999999999999999);
    final n2_999999999999999 = TokoinNumber.fromNumber(999999999999999);

    final n_0_000000000000000001 =
        TokoinNumber.fromNumber(0.000000000000000001);

    expect((n_1 + n_999999999999999).stringValue, '1000000000000000');
    expect((n_999999999999999 - n_1).stringValue, '999999999999998');
    expect((n_999999999999999 * n_2).stringValue, '1999999999999998');
    expect(n_999999999999999 >= n_1, true);
    expect(n2_999999999999999 >= n_999999999999999, true);
    expect(n2_999999999999999 == n_999999999999999, true);

    expect((n_1 - n_0_000000000000000001).stringValue, '0.999999999999999999');
    expect(
        (n_11 + n_0_000000000000000001).stringValue, '11.000000000000000001');
    expect((n_2 * n_0_000000000000000001).stringValue, '0.000000000000000002');

    final e_1000_3 = TokoinNumber.fromBigInt(BigInt.from(1000), exponent: 3);
    final e_100000_5 =
        TokoinNumber.fromBigInt(BigInt.from(100000), exponent: 5);
    expect(e_1000_3 == e_100000_5, true);
    expect((e_1000_3 + e_100000_5).stringValue, '2');
  });

  test('test tokoin number / formalizedString', () {
    var n_1_000000001 = TokoinNumber.fromNumber(1.000000001);
    var n_1000000000 = TokoinNumber.fromNumber(1000000000);

    expect(n_1_000000001.getFormalizedString(decimals: 0), '1');
    expect(n_1_000000001.getFormalizedString(decimals: 6), '1');
    expect(n_1_000000001.getFormalizedString(decimals: 9), '1.000000001');
    expect(n_1000000000.getFormalizedString(decimals: 9), '1,000,000,000');
  });

  test('test tokoin number / getClosestStringValue', () {
    var n_1_000000001 = TokoinNumber.fromNumber(1.000000001);
    var n_1000000000 = TokoinNumber.fromNumber(1000000000);

    expect(n_1_000000001.getClosestStringValue(), '1.000000001');
    expect(n_1_000000001.getClosestStringValue(decimals: 9), '1.000000001');
    expect(n_1000000000.getClosestStringValue(decimals: 9), '1000000000');
  });
}
