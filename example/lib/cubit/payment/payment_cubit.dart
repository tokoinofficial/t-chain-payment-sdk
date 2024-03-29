import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example/data/fcm_notification.dart';
import 'package:example/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  static const double defaultQrImageSize = 400;

  initial() {
    TChainPaymentSDK.shared.configMerchantApp(
      apiKey: Constants.apiKey,
      bundleId: Constants.bundleId,
      delegate: _onHandlePaymentResult,
      env: TChainPaymentEnv.dev,
    );
  }

  _onHandlePaymentResult(TChainPaymentResult result) {
    if (state is PaymentDepositState) {
      final currentState = state as PaymentDepositState;

      // You should check the result before updating your UI. But in the demo, I didn't check it
      // for example: `if (currentState.notes != result.notes) return;`

      emit(PaymentDepositState(
        notes: currentState.notes,
        amount: currentState.amount,
        status: result.status,
        transactionID: result.transactionID,
        errorMessage: result.errorMessage,
      ));
    } else if (state is PaymentQrState) {
      final currentState = state as PaymentQrState;

      // You should check the result before updating your UI. But in the demo, I didn't check it
      // for example: `if (currentState.notes != result.notes) return;`

      emit(PaymentQrState(
        notes: currentState.notes,
        amount: currentState.amount,
        qrImage: currentState.qrImage,
        status: result.status,
        transactionID: result.transactionID,
        errorMessage: result.errorMessage,
      ));
    }
  }

  @override
  close() async {
    TChainPaymentSDK.shared.close();

    super.close();
  }

  finish() {
    emit(PaymentInitial());
  }

  deposit({
    required String notes,
    required double amount,
    required Currency currency,
  }) async {
    emit(PaymentLoading());
    final result = await TChainPaymentSDK.shared.deposit(
      walletScheme: 'walletexample',
      notes: notes,
      amount: amount,
      currency: currency,
    );

    emit(PaymentDepositState(
      notes: notes,
      amount: amount,
      status: result.status,
      errorMessage: result.errorMessage,
    ));
  }

  generateQrCode({
    required String notes,
    required double amount,
    required Currency currency,
    double imageSize = defaultQrImageSize,
  }) async {
    emit(PaymentLoading());
    final result = await TChainPaymentSDK.shared.generateQrCode(
      walletScheme: 'walletexample',
      notes: notes,
      amount: amount,
      currency: currency,
      imageSize: imageSize,
    );

    emit(PaymentQrState(
      notes: notes,
      amount: amount,
      qrImage: result.qrImage,
      status: result.status,
      errorMessage: result.errorMessage,
    ));
  }

  receiveNotification(FcmNotification notification) {
    if (notification.result == null) return;

    _onHandlePaymentResult(notification.result!);
  }
}
