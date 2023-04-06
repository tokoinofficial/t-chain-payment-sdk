import 'package:t_chain_payment_sdk/services/gas_station_api.dart';

const GWEI_UNIT_PER_ETHER = 1000000000.0;
const SATOSHI_UNIT_PER_BTC = 1000000000;
const MAX_ETH_DECIMAL = 6;
const ESTIMATE_GAS_LIMIT_FOR_TRANSFER =
    21000 * 2; // 21000 is basic gas of transfer() func in Ethereum
const ESTIMATE_GAS_LIMIT_FOR_APPROVE =
    47257 * 2; // 47257 is estimated gas for approve() func in Ethereum.
const ESTIMATE_GAS_LIMIT_FOR_DEPOSIT =
    173791 * 2; // 173791 is estimated gas for deposit() func in Staking program
const ESTIMATE_GAS_LIMIT_FOR_WITHDRAW =
    67635 * 2; // 67635 is estimated gas for withdraw() func in Staking program
const DEFAULT_BSC_GAS_PRICE_GWEI = 10;
const DEFAULT_BSC_WAIT_MINUTES = 5.0;
const DEFAULT_ETH_GAS_PRICE_GWEI = 30;

class Wait {
  final int index;

  const Wait._internal(this.index);

  static const Fast = const Wait._internal(0);
  static const Average = const Wait._internal(1);
  static const Slow = const Wait._internal(2);

  static getList() => [Slow, Average, Fast];

  // static getName(int index) {
  //   if (index == Slow.index)
  //     return LocaleKeys.common_slow.tr();
  //   else if (index == Average.index)
  //     return LocaleKeys.common_average.tr();
  //   else
  //     return LocaleKeys.common_fast.tr();
  // }

  // static getColor(int index) {
  //   if (index == Slow.index)
  //     return App.theme.colorsV1.card2;
  //   else if (index == Average.index)
  //     return App.theme.colorsV1.button3;
  //   else
  //     return App.theme.colorsV1.error;
  // }
}

abstract class GasFee {
  num fee;
  int estimatedGas = ESTIMATE_GAS_LIMIT_FOR_TRANSFER;
  num waitInMin;

  GasFee(this.fee, this.waitInMin);

  toGwei() {
    return fee;
  }

  toEthString(num estimatedGas) =>
      _removeDecimalZeroFormat(toEth(estimatedGas));

  toEth(num estimatedGas) =>
      fee.toDouble() * estimatedGas / GWEI_UNIT_PER_ETHER;

  toBTC() => fee / SATOSHI_UNIT_PER_BTC;

  getWaitInMin() => waitInMin.ceil();

  getFeeValue({double multiplier = 1}) {
    String fee = _removeDecimalZeroFormat(toEth(estimatedGas) * multiplier);
    return fee;
  }

  static int parseBscGasPrice(String hex) {
    try {
      return int.parse(hex.substring(2), radix: 16) ~/ GasStationAPI.kGweiToWei;
    } catch (e) {
      return DEFAULT_BSC_GAS_PRICE_GWEI;
    }
  }

  static getGasFee(List<GasFee>? gasFees) {
    if (gasFees != null && gasFees.isNotEmpty) {
      return (gasFees.length > Wait.Average.index)
          ? gasFees[Wait.Average.index]
          : gasFees.first;
    }
    return null;
  }
}

class GasFeeFast extends GasFee {
  GasFeeFast(num fee, num waitInMin) : super(fee, waitInMin);

  @override
  toString() {
    return 'fast';
  }
}

class GasFeeAverage extends GasFee {
  GasFeeAverage(num fee, num waitInMin) : super(fee, waitInMin);

  @override
  toString() {
    return 'average';
  }
}

class GasFeeSafeLow extends GasFee {
  GasFeeSafeLow(num fee, num waitInMin) : super(fee, waitInMin);

  @override
  toString() {
    return 'slow';
  }
}

String _removeDecimalZeroFormat(double n) {
  RegExp regex = RegExp(r"([\d\.]+[1-9]+)0+$");
  return n
      .toStringAsFixed(MAX_ETH_DECIMAL)
      .replaceAllMapped(regex, (Match m) => "${m[1]}");
}
