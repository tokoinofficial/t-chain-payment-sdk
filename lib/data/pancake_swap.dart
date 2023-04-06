import 'package:t_chain_payment_sdk/data/asset.dart';

const KEY_ASSET_ID_IN = 'from_asset_id';
const KEY_AMOUNT_IN = 'token_amount_input';
const KEY_ASSET_ID_OUT = 'to_asset_id';
const KEY_AMOUNT_OUT = 'token_amount_output';

class PancakeSwap {
  num? amountIn, amountOut;
  late Asset assetIn, assetOut;

  PancakeSwap(
      {required this.assetIn,
      required this.assetOut,
      this.amountOut,
      this.amountIn});
}
