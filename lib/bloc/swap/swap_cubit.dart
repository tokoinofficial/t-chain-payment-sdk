import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/pancake_swap.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:web3dart/web3dart.dart';

import '../../l10n/generated/tchain_payment_localizations.dart';

part 'swap_state.dart';

class SwapCubit extends Cubit<SwapState> {
  SwapCubit({
    required this.walletRepository,
    required this.privateKeyHex,
  }) : super(SwapInitial());

  final WalletRepository walletRepository;
  final String privateKeyHex;
  TChainPaymentLocalizations localizations = TChainPaymentLocalizationsEn();

  /// externalGasPrice is used for checking gas in case the process has multi-steps
  Future<void> confirmSwap({
    required PancakeSwap pancakeSwap,
    required num gasPrice,
    num externalGasPrice = 0,
  }) async {
    try {
      emit(SwapSending());
      bool isEnoughBalance = false;

      if (pancakeSwap.amountIn == null && pancakeSwap.amountOut == null) {
        throw Exception(localizations.something_went_wrong_please_try_later);
      }

      if (pancakeSwap.amountIn == null) {
        BigInt? amountInBigInt =
            await walletRepository.getSwapAmountIn(pancakeSwap: pancakeSwap);
        final exponent = TokoinNumber.getExponentWithAsset(pancakeSwap.assetIn);
        final amountIn = TokoinNumber.fromBigInt(
          amountInBigInt ?? BigInt.zero,
          exponent: exponent,
        ).doubleValue;

        pancakeSwap = pancakeSwap.copyWith(
          amountIn: amountIn,
        );
      } else if (pancakeSwap.amountOut == null) {
        BigInt? amountOutBigInt =
            await walletRepository.getSwapAmountOut(pancakeSwap: pancakeSwap);
        final exponent =
            TokoinNumber.getExponentWithAsset(pancakeSwap.assetOut);
        final amountOut = TokoinNumber.fromBigInt(
          amountOutBigInt ?? BigInt.zero,
          exponent: exponent,
        ).doubleValue;
        pancakeSwap = pancakeSwap.copyWith(amountOut: amountOut);
      }

      var hasEnoughAllowance = await _hasEnoughAllowance(
          pancakeSwap.amountIn!, pancakeSwap.assetIn, Config.pancakeRouter);
      if (!hasEnoughAllowance) {
        emit(SwapAddAllowance(
          contractAddress: Config.pancakeRouter,
          asset: pancakeSwap.assetIn,
          amount: pancakeSwap.amountIn!,
        ));
        return;
      }

      Transaction tnx = await walletRepository.buildSwapContractTransaction(
        privateKeyHex: privateKeyHex,
        pancakeSwap: pancakeSwap,
        gasPrice: gasPrice,
      );
      final privateKey = EthPrivateKey.fromHex(privateKeyHex);
      num estimatedGas = await walletRepository.estimateGas(
        address: privateKey.address,
        transaction: tnx,
      );
      isEnoughBalance = await walletRepository.isEnoughBnb(
          privateKeyHex: privateKeyHex,
          asset: pancakeSwap.assetIn,
          amount: pancakeSwap.amountIn!,
          gasPrice: gasPrice,
          estimatedGas: estimatedGas + externalGasPrice);

      if (!isEnoughBalance) {
        emit(SwapFailed(localizations.you_are_not_enough_bnb));
        return;
      }

      var hash = await walletRepository.swap(
          privateKeyHex: privateKeyHex,
          tx: tnx,
          pancakeSwap: pancakeSwap,
          gasLimit: estimatedGas,
          gasPrice: gasPrice);
      bool isSuccess = await walletRepository.waitForReceiptResult(
          pancakeSwap.assetIn, hash);

      if (!isSuccess) {
        throw Exception(localizations.something_went_wrong_please_try_later);
      }

      emit(SwapSuccess(pancakeSwap));
    } catch (e) {
      emit(SwapFailed(Utils.getErrorMsg(e)));
    }
  }

  Future<bool> _hasEnoughAllowance(
    num amount,
    Asset asset,
    String contractAddress,
  ) async {
    double depositAmount = amount.toDouble();
    var allowance = await walletRepository.allowance(
      privateKeyHex: privateKeyHex,
      asset: asset,
      contractAddress: contractAddress,
    );
    return allowance >= depositAmount;
  }
}
