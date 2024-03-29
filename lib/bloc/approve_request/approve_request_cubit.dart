import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/data/account.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/common/transaction_waiter.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:t_chain_payment_sdk/repo/storage_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:web3dart/web3dart.dart';

part 'approve_request_state.dart';

class ApproveRequestCubit extends Cubit<ApproveRequestState> {
  ApproveRequestCubit({
    required this.walletRepository,
    required this.storageRepository,
    required this.account,
  }) : super(ApproveRequestInitial());

  final WalletRepository walletRepository;
  final StorageRepository storageRepository;
  final Account account;
  TChainPaymentLocalizations localizations = TChainPaymentLocalizationsEn();

  Future<void> loadTokenInfo({required Asset asset, event}) async {
    try {
      emit(ApproveRequestLoading());
      List<Future<dynamic>> infoNeeded = [
        walletRepository.balanceOf(
          smcAddressHex: asset.contractAddress,
          privateKey: account.privateKey,
        ),
        walletRepository.getBSCGasFees(),
      ];

      List<dynamic> list = await Future.wait(infoNeeded);

      final List<GasFee> gasFees = list.length > 1 ? list[1] : [];
      if (gasFees.isEmpty) {
        throw Exception(localizations.cannot_get_gas_fee);
      }

      emit(ApproveRequestReady(
        asset: asset,
        balance: list[0],
        gasFee: gasFees.first,
      ));
    } catch (e) {
      emit(ApproveRequestError(error: Utils.getErrorMsg(e)));
    }
  }

  Future<void> approve({
    required Asset asset,
    required num amount,
    required bool resend,
    required num gasPrice,
    required String contractAddress,
  }) async {
    try {
      emit(ApproveRequestLoading());
      var hasEnoughAllowance = await _hasEnoughAllowance(
        amount,
        asset,
        contractAddress,
      );
      if (hasEnoughAllowance) {
        emit(ApproveRequestSuccess());
        return;
      }

      if (!resend) {
        // check pending approval
        String? pendingApprovalTxHash =
            await storageRepository.getPendingApprovalTxHash(
          walletAddress: account.privateKey.address.hex,
          contractAddress: contractAddress,
        );

        if (!Utils.isEmptyString(pendingApprovalTxHash)) {
          final receipt = await walletRepository.getTransactionReceipt(
              asset, pendingApprovalTxHash!);

          if (receipt != null) {
            // have receipt
            if (receipt.status == true) {
              // this transaction was executed successfully -> check approval
              bool isApproved =
                  await _waitForEnoughAllowance(amount, asset, contractAddress);

              if (isApproved) {
                emit(ApproveRequestSuccess());
                return;
              }
            }

            // this tx was failed or not enough --> start a new request
          } else {
            // tx may be not executed --> it's information
            TransactionInformation? info = await walletRepository
                .getTransactionByHash(asset, pendingApprovalTxHash);

            if (info != null) {
              // tx's pending
              emit(ApproveRequestPending());
              return;
            }

            // cannot find the tx --> start a new request
          }
        }
      }

      // user wants to send a new request --> remove the pending approval on local storage if needed
      storageRepository.removePendingApprovalTxHash(
        walletAddress: account.privateKey.address.hex,
        contractAddress: contractAddress,
      );

      bool isEnoughBalance = false;
      Transaction tnx = await walletRepository.buildApproveTransaction(
        privateKey: account.privateKey,
        asset: asset,
        contractAddress: contractAddress,
        amount: TokoinNumber.fromNumber(amount).bigIntValue,
        gasPrice: gasPrice,
      );

      num estimatedGas = await walletRepository.estimateGas(
        address: account.privateKey.address,
        transaction: tnx,
      );

      isEnoughBalance = await walletRepository.isEnoughBnb(
        privateKey: account.privateKey,
        asset: asset,
        amount: amount,
        gasPrice: gasPrice,
        estimatedGas: estimatedGas,
      );

      if (!isEnoughBalance) {
        emit(ApproveRequestError(
          error: localizations.you_are_not_enough_bnb,
        ));

        return;
      }

      String txHash = await walletRepository.sendApproval(
        privateKey: account.privateKey,
        asset: asset,
        contractAddress: contractAddress,
        gasPrice: gasPrice,
      );

      debugPrint('approving TxHash $txHash');

      // approve deposit does not immediately become successful,
      // so we wait for the allowance to become enough here
      bool isApproved = await _waitForEnoughAllowance(
        amount,
        asset,
        contractAddress,
      );

      if (isApproved) {
        emit(ApproveRequestSuccess());
      } else {
        // store tx to check pending approval later
        storageRepository.setPendingApprovalTxHash(
          txHash: txHash,
          walletAddress: account.privateKey.address.hex,
          contractAddress: contractAddress,
        );

        emit(ApproveRequestWaiting());
      }
    } catch (e) {
      emit(ApproveRequestError(error: localizations.failed_to_approve_deposit));
    }
  }

  Future<bool> _hasEnoughAllowance(
    num amount,
    Asset asset,
    String contractAddress,
  ) async {
    double depositAmount = amount.toDouble();
    var allowance = await walletRepository.allowance(
      privateKey: account.privateKey,
      asset: asset,
      contractAddress: contractAddress,
    );
    return allowance >= depositAmount;
  }

  Future<bool> _waitForEnoughAllowance(
    num amount,
    Asset asset,
    String contractAddress,
  ) async {
    return await transactionWaiter.waitUntil(() => _hasEnoughAllowance(
          amount,
          asset,
          contractAddress,
        ));
  }
}
