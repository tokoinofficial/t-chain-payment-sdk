library t_chain_payment_sdk;

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/account.dart';
import 'package:t_chain_payment_sdk/data/currency.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_qr_result.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/repo/storage_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/screens/t_chain_root.dart';
import 'package:t_chain_payment_sdk/services/blockchain_service.dart';
import 'package:t_chain_payment_sdk/services/t_chain_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:t_chain_payment_sdk/services/deep_link_service.dart';

export 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
export 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
export 'package:t_chain_payment_sdk/data/t_chain_payment_qr_result.dart';
export 'package:t_chain_payment_sdk/data/currency.dart';
export 'package:t_chain_payment_sdk/data/account.dart';
export 'package:t_chain_payment_sdk/data/merchant_info.dart';
export 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
export 'package:t_chain_payment_sdk/services/deep_link_service.dart';

/// T-Chain Paymnent SDK
/// T-Chain Payment is a B2B service helping small and medium-sized enterprises add another channel for users to purchase using crypto currency with minimum efforts.
/// Features:
/// - deposit
/// - generate QR Code
///
class TChainPaymentSDK {
  static final TChainPaymentSDK _shared = TChainPaymentSDK._();
  static TChainPaymentSDK get shared => _shared;

  TChainPaymentSDK._();

  /// [apiKey] will be generated when you (create a project)[https://developer.tokoin.io/guides/creating-a-project]
  late String apiKey;

  /// Bundle id of merchant app
  /// It's used for wallet's callback function
  late String bundleId;

  /// Environment
  late TChainPaymentEnv env;

  /// what chain id do you want to work with?
  late bool isTestnet;

  /// user data
  late Account account;

  /// To handle payment result
  late Function(TChainPaymentResult) delegate;

  String get sandboxTitle => isTestnet ? ' - SANDBOX' : '';

  int get chainID => isTestnet ? kTestnetChainID : kMainnetChainID;
  String get chainIdString => '$chainID';

  late PaymentRepository _paymentRepository;

  /// Close payment sdk
  close() {
    DeepLinkService.shared.close();
  }
}

extension TChainPaymentSDKMerchantApp on TChainPaymentSDK {
  /// config payment sdk
  configMerchantApp({
    required String apiKey,
    required String bundleId,
    TChainPaymentEnv env = TChainPaymentEnv.dev,
    bool isTestnet = true,
    required Function(TChainPaymentResult) delegate,
  }) {
    this.apiKey = apiKey;
    this.bundleId = bundleId;
    this.env = env;
    this.isTestnet = isTestnet;
    this.delegate = delegate;
    Config.setEnvironment(env);

    final api = TChainAPI.standard(env.apiUrl);
    _paymentRepository = PaymentRepository(api: api);

    DeepLinkService.shared.listen(_handleDeepLink);
  }

  /// Use case: App to App
  /// Alex wants to add funds into his wallet in a game platform, the system
  /// already provides several way to deposit such as redeem code, credit card...
  /// But he wants a modern way - the crypto currency. After integrating with
  /// T-Chain Payment, Alex now can click on a button on mobile or web application
  /// to transfer his money to our smart contract, hence he will get the same
  /// amount in the system after the transaction is completed.
  ///
  /// [notes] unique id of each order. It is called offchain in blockchain terms.
  /// [amount] a sum of money to make a depositary
  Future<TChainPaymentResult> deposit({
    required String walletScheme,
    required String notes,
    required double amount,
    required Currency currency,
  }) async {
    return await _callPaymentAction(
      action: TChainPaymentAction.deposit,
      walletScheme: walletScheme,
      notes: notes,
      amount: amount,
      currency: currency,
    );
  }

  /// Use case: User want to take money out of their game wallet
  ///
  /// [notes] unique id of each order. It is called offchain in blockchain terms
  /// [amount] a sum of money to make a withdrawal
  Future<TChainPaymentResult> withdraw({
    required String notes,
    required double amount,
  }) async {
    return TChainPaymentResult(
      status: TChainPaymentStatus.error,
      notes: notes,
      errorMessage: 'Coming soon',
    );
  }

  /// Use case: POS - QR
  /// Daisy owns a coffee shop, in order to follow the social distancing rules,
  /// along with banking QR code, she now can introduce the similar way but using
  /// crypto currency instead. Customers just need to scan the code, a
  /// notification will be sent to Daisy's phone once the payment succeeds.
  ///
  ///
  /// [notes] unique id of each order. It is called offchain in blockchain terms.
  /// [amount] a sum of money to make a depositary
  Future<TChainPaymentQRResult> generateQrCode({
    required String walletScheme,
    required String notes,
    required double amount,
    required Currency currency,
    required double imageSize,
  }) async {
    if (amount <= 0) {
      return TChainPaymentQRResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Invalid parameter',
      );
    }

    final Uri? uri = await _paymentRepository.generateDeeplink(
      action: TChainPaymentAction.deposit,
      walletScheme: walletScheme,
      notes: notes,
      amount: amount,
      currency: currency,
      chainId: '$chainID',
    );

    if (uri == null) {
      return TChainPaymentQRResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Cannot generate deeplink',
      );
    }

    final painter = QrPainter(
      data: uri.toString(),
      version: QrVersions.auto,
    );

    final qrImage = await painter.toImage(imageSize);
    final qrData = await qrImage.toByteData(format: ImageByteFormat.png);

    return TChainPaymentQRResult(
      status: TChainPaymentStatus.waiting,
      notes: notes,
      qrData: qrData,
    );
  }

  Future<TChainPaymentResult> _callPaymentAction({
    required TChainPaymentAction action,
    required String walletScheme,
    required String notes,
    required double amount,
    required Currency currency,
  }) async {
    if (amount <= 0) {
      return TChainPaymentResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Invalid parameter',
      );
    }

    final Uri? uri = await _paymentRepository.generateDeeplink(
      walletScheme: walletScheme,
      action: action,
      notes: notes,
      amount: amount,
      currency: currency,
      bundleID: bundleId,
      chainId: '$chainID',
    );

    if (uri == null) {
      return TChainPaymentQRResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Cannot generate deeplink',
      );
    }

    bool result = false;
    try {
      result = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (result == false) {
      return TChainPaymentResult(
        status: TChainPaymentStatus.failed,
        notes: notes,
      );
    }

    return TChainPaymentResult(
      status: TChainPaymentStatus.waiting,
      notes: notes,
    );
  }

  _handleDeepLink(Uri? deepLink) {
    if (deepLink == null) return;

    final transactionID = deepLink.queryParameters['txn'];
    final String notes = deepLink.queryParameters['notes'] ?? '';

    switch (deepLink.path) {
      case '/success':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.success,
          notes: notes,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/fail':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.failed,
          notes: notes,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/proceeding':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.proceeding,
          notes: notes,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/cancelled':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.cancelled,
          notes: notes,
        );
        delegate.call(result);
        break;
    }
  }
}

extension TChainPaymentSDKWalletApp on TChainPaymentSDK {
  /// config payment sdk
  configWallet({
    required String apiKey,
    TChainPaymentEnv env = TChainPaymentEnv.dev,
    bool isTestnet = true,
    Function(Uri)? onDeeplinkReceived,
  }) {
    this.apiKey = apiKey;
    this.env = env;
    this.isTestnet = isTestnet;

    Config.setEnvironment(env);

    final api = TChainAPI.standard(env.apiUrl);
    _paymentRepository = PaymentRepository(api: api);

    DeepLinkService.shared.listen(onDeeplinkReceived);
  }

  Future<bool> _startPayment(
    BuildContext context, {
    required Account account,
    MerchantInfo? merchantInfo,
    String? qrCode,
    String? bundleId,
  }) async {
    this.account = account;

    return await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MultiRepositoryProvider(
              providers: [
                RepositoryProvider.value(value: _paymentRepository),
                RepositoryProvider(create: (context) {
                  return WalletRepository(
                    blockchainService: BlockchainService(),
                  );
                }),
                RepositoryProvider(create: (context) {
                  return StorageRepository();
                }),
              ],
              child: TChainRoot(
                merchantInfo: merchantInfo,
                qrCode: qrCode,
                bundleId: bundleId,
              ),
            ),
            fullscreenDialog: true,
          ),
        ) as bool? ??
        false;
  }

  // App to App
  Future<bool> startPaymentWithQrCode(
    BuildContext context, {
    required Account account,
    required String qrCode,
    required String bundleId,
  }) {
    return _startPayment(
      context,
      account: account,
      qrCode: qrCode,
      bundleId: bundleId,
    );
  }

  // Window to App
  Future<bool> startPaymentWithMerchantInfo(
    BuildContext context, {
    required Account account,
    required MerchantInfo merchantInfo,
  }) {
    return _startPayment(
      context,
      account: account,
      merchantInfo: merchantInfo,
    );
  }

  Future<MerchantInfo?> getMerchantInfo({required String qrCode}) async {
    try {
      final response = await _paymentRepository.getMerchantInfo(qrCode: qrCode);
      return response?.result;
    } catch (e) {
      return null;
    }
  }
}
