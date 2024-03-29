import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

part 'payment_info_state.dart';

class PaymentInfoCubit extends Cubit<PaymentInfoState> {
  PaymentInfoCubit({
    required this.paymentRepository,
  }) : super(PaymentInfoInitial());

  PaymentRepository paymentRepository;

  setPaymentInfo({required MerchantInfo merchantInfo}) {
    emit(PaymentInfoLoaded(merchantInfo: merchantInfo));
  }

  getPaymentInfo({String? qrCode, required String currentChainId}) async {
    if (state is PaymentInfoLoading) return;
    emit(PaymentInfoLoading());

    if (qrCode == null || qrCode.isEmpty) {
      emit(PaymentInfoUnsupported());

      return;
    }

    try {
      final response = await paymentRepository.getMerchantInfo(qrCode: qrCode);

      if (response == null ||
          response.result == null ||
          response.result!.chainId != currentChainId) {
        emit(PaymentInfoUnsupported());
        return;
      }

      emit(PaymentInfoLoaded(merchantInfo: response.result!));
    } catch (e) {
      emit(PaymentInfoUnsupported());
    }
  }
}
