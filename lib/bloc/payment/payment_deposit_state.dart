part of 'payment_deposit_cubit.dart';

enum PaymentDepositStatus { loading, loaded, depositing }

abstract class PaymentDepositState extends Equatable {
  const PaymentDepositState();

  @override
  List<Object?> get props => [];
}

class PaymentDepositInitial extends PaymentDepositState {}

class PaymentDepositUnsupportedWallet extends PaymentDepositState {}

class PaymentDepositSwapRequest extends PaymentDepositState {
  final Asset fromAsset;
  final Asset toAsset;
  final double amount;
  final GasFee gasFee;
  final List<TransferData> transferDataList;

  const PaymentDepositSwapRequest({
    required this.fromAsset,
    required this.toAsset,
    required this.amount,
    required this.gasFee,
    required this.transferDataList,
  }) : super();

  @override
  List<Object?> get props => super.props
    ..addAll([
      fromAsset,
      toAsset,
      amount,
      gasFee,
      transferDataList,
    ]);
}

class PaymentDepositSetUpCompleted extends PaymentDepositState {}

class PaymentDepositShowInfo extends PaymentDepositState {
  final PaymentDepositStatus status;
  final bool isEnoughBnb;
  final List<TransferData> transferDataList;

  const PaymentDepositShowInfo({
    required this.status,
    required this.isEnoughBnb,
    required this.transferDataList,
  }) : super();

  PaymentDepositShowInfo copyWith({
    PaymentDepositStatus? status,
    bool? isEnoughBnb,
    List<TransferData>? transferDataList,
  }) {
    return PaymentDepositShowInfo(
      status: status ?? this.status,
      isEnoughBnb: isEnoughBnb ?? this.isEnoughBnb,
      transferDataList: transferDataList ?? this.transferDataList,
    );
  }

  @override
  List<Object?> get props => super.props
    ..addAll([
      status,
      isEnoughBnb,
      transferDataList,
    ]);
}

class PaymentDepositAddAllowance extends PaymentDepositState {
  final Asset asset;
  final num amount;
  final String contractAddress;
  final List<TransferData> transferDataList;

  const PaymentDepositAddAllowance({
    required this.asset,
    required this.amount,
    required this.contractAddress,
    required this.transferDataList,
  }) : super();

  @override
  List<Object?> get props => super.props
    ..addAll([
      asset,
      amount,
      contractAddress,
      transferDataList,
    ]);
}

class PaymentDepositProceeding extends PaymentDepositState {
  final String txn;

  const PaymentDepositProceeding({required this.txn}) : super();

  @override
  List<Object?> get props => super.props..add(txn);
}

class PaymentDepositCompleted extends PaymentDepositState {
  final String txn;

  const PaymentDepositCompleted({required this.txn}) : super();

  @override
  List<Object?> get props => super.props..add(txn);
}

class PaymentDepositFailed extends PaymentDepositState {
  final String txn;

  const PaymentDepositFailed({required this.txn}) : super();

  @override
  List<Object?> get props => super.props..add(txn);
}

class PaymentDepositError extends PaymentDepositState {
  final String error;

  const PaymentDepositError({required this.error}) : super();

  @override
  List<Object?> get props => super.props..add(error);
}
