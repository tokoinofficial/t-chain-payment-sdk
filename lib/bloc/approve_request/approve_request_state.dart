part of 'approve_request_cubit.dart';

abstract class ApproveRequestState extends Equatable {
  const ApproveRequestState();

  @override
  List<Object?> get props => [];
}

class ApproveRequestInitial extends ApproveRequestState {}

class ApproveRequestLoading extends ApproveRequestState {}

class ApproveRequestReady extends ApproveRequestState {
  final Asset asset;
  final num balance;

  final GasFee gasFee;

  const ApproveRequestReady({
    required this.asset,
    required this.balance,
    required this.gasFee,
  }) : super();

  @override
  List<Object?> get props => super.props
    ..addAll([
      asset,
      balance,
      gasFee,
    ]);
}

class ApproveRequestSuccess extends ApproveRequestState {}

class ApproveRequestWaiting extends ApproveRequestState {}

class ApproveRequestPending extends ApproveRequestState {}

class ApproveRequestError extends ApproveRequestState {
  final String error;

  const ApproveRequestError({required this.error});

  @override
  List<Object?> get props => super.props..add(error);
}
