import 'package:equatable/equatable.dart';
import 'package:t_chain_payment_sdk/services/gas_station_api.dart';

const kGweiUnitPerEther = 1000000000.0;
const kMaxEthDecimal = 6;
const kEstimateGasLimitForTransfer =
    21000 * 2; // 21000 is basic gas of transfer() func in Ethereum
const kEstimateGasLimitForApprove =
    47257 * 2; // 47257 is estimated gas for approve() func in Ethereum.

const kDefaultBscGasPriceGwei = 10;
const kDefaultBscWaitMinutes = 5.0;

// ignore: must_be_immutable
class GasFee extends Equatable {
  num fee;
  int estimatedGas = kEstimateGasLimitForTransfer;
  num waitInMin;

  GasFee(this.fee, this.waitInMin);

  toGwei() {
    return fee;
  }

  toEthString(num estimatedGas) =>
      _removeDecimalZeroFormat(toEth(estimatedGas));

  toEth(num estimatedGas) => fee.toDouble() * estimatedGas / kGweiUnitPerEther;

  getWaitInMin() => waitInMin.ceil();

  getFeeValue({double multiplier = 1}) {
    String fee = _removeDecimalZeroFormat(toEth(estimatedGas) * multiplier);
    return fee;
  }

  static int parseBscGasPrice(String hex) {
    try {
      return int.parse(hex.substring(2), radix: 16) ~/ GasStationAPI.kGweiToWei;
    } catch (e) {
      return kDefaultBscGasPriceGwei;
    }
  }

  @override
  List<Object?> get props => [
        fee,
        estimatedGas,
        waitInMin,
      ];
}

String _removeDecimalZeroFormat(double n) {
  RegExp regex = RegExp(r"([\d\.]+[1-9]+)0+$");
  return n
      .toStringAsFixed(kMaxEthDecimal)
      .replaceAllMapped(regex, (Match m) => "${m[1]}");
}
