part of 'swap_cubit.dart';

abstract class SwapState extends Equatable {
  const SwapState();

  @override
  List<Object> get props => [];
}

class SwapInitial extends SwapState {}

class SwapSending extends SwapState {}

class SwapGetAmountOutLoading extends SwapState {}

class SwapGetAmountOutSuccess extends SwapState {
  final TokoinNumber amountOut;
  const SwapGetAmountOutSuccess(this.amountOut) : super();

  @override
  List<Object> get props => super.props..add(amountOut);
}

class SwapSuccess extends SwapState {
  final PancakeSwap pancakeSwap;
  const SwapSuccess(this.pancakeSwap) : super();

  @override
  List<Object> get props => super.props..add(pancakeSwap);
}

class SwapRequiresApproval extends SwapState {}

class SwapFailed extends SwapState {
  final String errorMsg;

  const SwapFailed(this.errorMsg) : super();

  @override
  List<Object> get props => super.props..add(errorMsg);
}
