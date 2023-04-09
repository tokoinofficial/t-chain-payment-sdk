import 'package:t_chain_payment_sdk/data/asset.dart';

class PancakeSwap {
  num? amountIn, amountOut;
  late Asset assetIn, assetOut;

  PancakeSwap({
    required this.assetIn,
    required this.assetOut,
    this.amountOut,
    this.amountIn,
  });
}
