part of 'payment_info_cubit.dart';

abstract class PaymentInfoState extends Equatable {
  const PaymentInfoState();

  @override
  List<Object> get props => [];
}

class PaymentInfoInitial extends PaymentInfoState {}

class PaymentInfoLoading extends PaymentInfoState {}

class PaymentInfoLoaded extends PaymentInfoState {
  final MerchantInfo merchantInfo;

  const PaymentInfoLoaded({required this.merchantInfo}) : super();

  @override
  List<Object> get props => super.props..add(merchantInfo);
}

class PaymentInfoUnsupported extends PaymentInfoState {}
