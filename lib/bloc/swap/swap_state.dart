part of 'swap_cubit.dart';

abstract class SwapState extends Equatable {
  const SwapState();

  @override
  List<Object?> get props => [];
}

class SwapInitial extends SwapState {}

class SwapSending extends SwapState {}

class SwapGetAmountOutLoading extends SwapState {}

class SwapGetAmountOutSuccess extends SwapState {
  final TokoinNumber amountOut;
  const SwapGetAmountOutSuccess(this.amountOut) : super();

  @override
  List<Object?> get props => super.props..add(amountOut);
}

class SwapSuccess extends SwapState {
  final PancakeSwap pancakeSwap;
  const SwapSuccess(this.pancakeSwap) : super();

  @override
  List<Object?> get props => super.props..add(pancakeSwap);
}

class SwapAddAllowance extends SwapState {
  final Asset asset;
  final num amount;
  final String contractAddress;

  const SwapAddAllowance({
    required this.asset,
    required this.amount,
    required this.contractAddress,
  }) : super();

  @override
  List<Object?> get props => super.props
    ..addAll([
      asset,
      amount,
      contractAddress,
    ]);
}

class SwapFailed extends SwapState {
  final String errorMsg;

  const SwapFailed(this.errorMsg) : super();

  @override
  List<Object?> get props => super.props..add(errorMsg);
}
