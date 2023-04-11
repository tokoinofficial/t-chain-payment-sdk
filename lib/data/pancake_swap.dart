import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';

part 'pancake_swap.g.dart';

@CopyWith(copyWithNull: true)
class PancakeSwap extends Equatable {
  const PancakeSwap({
    required this.assetIn,
    required this.assetOut,
    this.amountOut,
    this.amountIn,
  });

  final num? amountIn, amountOut;
  final Asset assetIn, assetOut;

  @override
  List<Object?> get props => [
        assetIn,
        assetOut,
        amountIn,
        amountOut,
      ];
}
