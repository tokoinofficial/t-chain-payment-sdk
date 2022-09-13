import 'package:bloc/bloc.dart';
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
    TChainPaymentSDK.instance.init(
      merchantID: Constants.merchantID,
      bundleID: Constants.bundleID,
      delegate: _onHandlePaymentResult,
    );
  }

  _onHandlePaymentResult(TChainPaymentResult result) {
    if (state is PaymentDepositState) {
      final currentState = state as PaymentDepositState;

      if (currentState.orderID != result.orderID) return;

      emit(PaymentDepositState(
        orderID: currentState.orderID,
        amount: currentState.amount,
        status: result.status,
        transactionID: result.transactionID,
        errorMessage: result.errorMessage,
      ));
    } else if (state is PaymentQrState) {
      final currentState = state as PaymentQrState;

      if (currentState.orderID != result.orderID) return;

      emit(PaymentQrState(
        orderID: currentState.orderID,
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
    TChainPaymentSDK.instance.close();

    super.close();
  }

  finish() {
    emit(PaymentInitial());
  }

  deposit({required String orderID, required double amount}) async {
    final result = await TChainPaymentSDK.instance
        .deposit(orderID: orderID, amount: amount);

    emit(PaymentDepositState(
      orderID: orderID,
      amount: amount,
      status: result.status,
      errorMessage: result.errorMessage,
    ));
  }

  generateQrCode({
    required String orderID,
    required double amount,
    double imageSize = defaultQrImageSize,
  }) async {
    final result = await TChainPaymentSDK.instance.generateQrCode(
      orderID: orderID,
      amount: amount,
      imageSize: imageSize,
    );

    emit(PaymentQrState(
      orderID: orderID,
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
