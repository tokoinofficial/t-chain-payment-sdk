import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t_chain_payment_sdk/bloc/payment_deposit_cubit.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/config/utils.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/currency.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/data/transfer_data.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/helpers/deep_link_service.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/screens/payment_status_screen.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:t_chain_payment_sdk/widgets/app_bar_widget.dart';
import 'package:t_chain_payment_sdk/widgets/button_widget.dart';
import 'package:t_chain_payment_sdk/widgets/payment_info_widget.dart';
import 'package:t_chain_payment_sdk/widgets/transfer_tile.dart';

class PaymentDepositScreen extends StatefulWidget {
  const PaymentDepositScreen({
    Key? key,
    required this.merchantInfo,
    required this.bundleId,
  }) : super(key: key);

  final MerchantInfo merchantInfo;
  final String? bundleId;

  @override
  State<PaymentDepositScreen> createState() => _PaymentDepositScreenState();
}

class _PaymentDepositScreenState extends State<PaymentDepositScreen> {
  // late WalletCubit _walletCubit;
  late PaymentDepositCubit _paymentDepositCubit;
  // late SwapCubit _swapCubit;
  Timer? _timer;
  static const int maxProceedingDurationInSeconds = 10;
  int _countdown = 0;

  Timer? _exchangeRateRefreshingTimer;
  static const int maxExchangeRateDuration = 60 * 5;
  final ValueNotifier<int> _exchangeRateCountdown = ValueNotifier(0);

  // Wallet? _wallet;
  GasFee? _gasFee;
  Asset? _currentAsset;
  Asset? _swappingAsset;
  double? _swappingAmount;
  bool _useToko = false;
  late PaymentType _paymentType;
  String _userNotes = '';

  double get safeOriginalAmount => widget.merchantInfo.amount ?? 0;

  @override
  void initState() {
    super.initState();

    _paymentType = widget.bundleId != null && widget.bundleId!.isNotEmpty
        ? PaymentType.deposit
        : PaymentType.payment;

    // _walletCubit = context.read<WalletCubit>();
    // _swapCubit = context.read<SwapCubit>();

    final walletRepos = context.read<WalletRepository>();
    final paymentRepos = context.read<PaymentRepository>();
    _paymentDepositCubit = PaymentDepositCubit(
      walletRepository: walletRepos,
      paymentRepository: paymentRepos,
      amount: safeOriginalAmount,
      currency: widget.merchantInfo.currency.toCurrency(),
      privateKeyHex: TChainPaymentSDK.instance.account.privateKeyHex,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paymentDepositCubit.setup();
      _paymentDepositCubit.getAllInfo();
      // _swapCubit.setupSwapContractSupportBNB();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _exchangeRateRefreshingTimer?.cancel();
    _paymentDepositCubit.close();
    _exchangeRateCountdown.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _paymentDepositCubit.localizations =
        TChainPaymentLocalizations.of(context)!;
  }

  _startExchangeRateTimer() {
    if (_exchangeRateRefreshingTimer != null) return;

    _exchangeRateCountdown.value = maxExchangeRateDuration;
    _exchangeRateRefreshingTimer =
        Timer.periodic(const Duration(seconds: 1), (second) {
      _exchangeRateCountdown.value -= 1;

      if (_exchangeRateCountdown.value == 0) {
        _exchangeRateRefreshingTimer?.cancel();
        _exchangeRateRefreshingTimer = null;

        setState(() {
          _currentAsset = null;
        });

        _paymentDepositCubit.getExchangeRate();
      }
    });
  }

  _onRefreshExchangeRate() async {
    _exchangeRateRefreshingTimer?.cancel();
    _exchangeRateRefreshingTimer = null;
    _exchangeRateCountdown.value = 0;

    setState(() {
      _currentAsset = null;
    });

    _paymentDepositCubit.getExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _paymentDepositCubit,
      child: MultiBlocListener(
        listeners: [
          // BlocListener<SwapCubit, SwapState>(
          //   bloc: _swapCubit,
          //   listener: (context, state) {
          //     if (state is SwapSuccess)
          //       _handleSuccessSwap(state.pancakeSwap);
          //     else if (state is SwapRequiresApproval) {
          //       _handleSwapApproveDeposit();
          //     } else if (state is SwapFailed) {
          //       Utils.instance.errorToast(state.errorMsg);
          //     }
          //   },
          // ),
          // BlocListener<WalletCubit, WalletState>(listener: (context, state) {
          //   if (state is WalletSuccess) {
          //     _wallet = state.wallet;
          //     _walletCubit.walletLoadBalance(wallet: _wallet!);
          //   }

          //   if (state is WalletLoadBalanceSuccess) {
          //     _wallet = state.wallet;
          //     _paymentDepositCubit.getAllInfo();
          //   }
          // }),
          BlocListener<PaymentDepositCubit, PaymentDepositState>(
            bloc: _paymentDepositCubit,
            listener: (context, state) {
              if (state is PaymentDepositSwapRequest) {
                _swappingAsset = state.toAsset;
                _swappingAmount = state.amount;
                _gasFee = state.gasFee;
                _swap(swappingAsset: _swappingAsset!, amount: _swappingAmount!);
              } else if (state is PaymentDepositSetUpCompleted) {
                // _walletCubit.walletStarted();
              } else if (state is PaymentDepositError) {
                Utils.errorToast(state.error);
              } else if (state is PaymentDepositApproveRequest) {
                _handleApproveDeposit(
                  asset: state.asset,
                  amount: state.amount,
                  contractAddress: state.contractAddress,
                );
              } else if (state is PaymentDepositShowInfo) {
                if (state.status == PaymentDepositStatus.loaded) {
                  _startExchangeRateTimer();
                }
              } else if (state is PaymentDepositCompleted ||
                  state is PaymentDepositFailed ||
                  state is PaymentDepositProceeding) {
                if (_timer == null) {
                  _countdown = maxProceedingDurationInSeconds;
                  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                    setState(() {
                      _countdown -= 1;
                    });

                    if (_countdown == 0) {
                      _timer?.cancel();
                      _timer = null;

                      if (_paymentType == PaymentType.payment) return;

                      final currentState = _paymentDepositCubit.state;
                      if (currentState is PaymentDepositCompleted) {
                        DeepLinkService.instance.success(
                          bundleID: widget.bundleId,
                          notes: widget.merchantInfo.notes,
                          txn: currentState.txn,
                        );
                      } else if (currentState is PaymentDepositFailed) {
                        DeepLinkService.instance.fail(
                          bundleID: widget.bundleId,
                          notes: widget.merchantInfo.notes,
                          txn: currentState.txn,
                        );
                      } else if (currentState is PaymentDepositProceeding) {
                        DeepLinkService.instance.proceeding(
                          bundleID: widget.bundleId,
                          notes: widget.merchantInfo.notes,
                          txn: currentState.txn,
                        );
                      }

                      _onCloseScreen();
                    }
                  });
                }
              }
            },
          ),
        ],
        child:
            // TODO
            // BlocBuilder<SwapCubit, SwapState>(
            //   bloc: _swapCubit,
            //   builder: (context, swapState) {
            //     final isSwapNotReady = swapState is InitialSwapState;
            //     final isSwapSending = swapState is SwapSending;

            //     return
            BlocBuilder<PaymentDepositCubit, PaymentDepositState>(
          bloc: _paymentDepositCubit,
          builder: (context, state) {
            if (state is PaymentDepositCompleted) {
              return PaymentStatusScreen.completed(
                type: _paymentType,
                second: _countdown,
              );
            }

            if (state is PaymentDepositFailed) {
              return PaymentStatusScreen.failed(
                type: _paymentType,
                second: _countdown,
                onRetry: _onRetry,
              );
            }

            if (state is PaymentDepositProceeding) {
              return PaymentStatusScreen.proceeding(
                type: _paymentType,
                second: _countdown,
              );
            }

            bool? isEnoughBnb;
            if (state is PaymentDepositShowInfo) {
              isEnoughBnb = state.isEnoughBnb;
            }

            final paymentInProcess = state is PaymentDepositShowInfo &&
                state.status == PaymentDepositStatus.depositing;

            final showLoading = paymentInProcess; // TODO
            // final showLoading =
            // paymentInProcess || isSwapSending || isSwapNotReady;

            List<TransferData> transferDataList = [];
            bool isLoaded = false;

            if (state is PaymentDepositShowInfo) {
              transferDataList = state.transferDataList;
              isLoaded = state.status != PaymentDepositStatus.loading;
            } else if (state is PaymentDepositSwapRequest) {
              transferDataList = state.transferDataList;
              isLoaded = true;
            } else if (state is PaymentDepositSetUpCompleted) {
              isLoaded = false;
            } else if (state is PaymentDepositApproveRequest) {
              transferDataList = state.transferDataList;
              isLoaded = true;
            }

            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                backgroundColor: oldThemeColors.bg,
                resizeToAvoidBottomInset: false,
                appBar: _buildAppBar(),
                body: ModalProgressHUD(
                  inAsyncCall: showLoading,
                  child: state is PaymentDepositUnsupportedWallet
                      ? _buildWalletError()
                      : Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: SafeArea(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildMerchantInfo(),
                                      const SizedBox(height: 16),
                                      _buildSelectToken(),
                                      const SizedBox(height: 16),
                                      _buildExchangeRateRefreshArea(
                                        showLoading: showLoading,
                                      ),
                                      const SizedBox(height: 10),
                                      ..._buildAssets(
                                        transferDataList: transferDataList,
                                        isLoaded: isLoaded,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildConfirmDesc(),
                                _buildConfirmButton(isEnoughBnb),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
          // );
          // },
        ),
      ),
    );
  }

  _handleSwapApproveDeposit() async {
    // var result =
    //     await Navigator.pushNamed(context, ScreenRouter.APPROVAL, arguments: {
    //   ScreenRouter.ARG_ASSET: _currentAsset,
    //   ScreenRouter.ARG_AMOUNT: widget.merchantInfo.amount,
    //   ScreenRouter.ARG_CONTRACT_ADDRESS: Config.pancakeRouter
    // });

    // if (result != null && _swappingAsset != null && _swappingAmount != null) {
    //   _swap(
    //     swappingAsset: _swappingAsset!,
    //     amount: _swappingAmount!,
    //   );
    // }
  }

  _swap({
    required Asset swappingAsset,
    required double amount,
  }) {
    // TODO
    // if (_currentAsset == null && _gasFee != null) return;

    // _swapCubit.confirmSwap(
    //   pancakeSwap: PancakeSwap(
    //     assetIn: _currentAsset!,
    //     assetOut: swappingAsset,
    //     amountIn: amount,
    //   ),
    //   gasPrice: _gasFee!.fee,
    //   externalGasPrice: _gasFee!.fee,
    // );
  }

// TODO
  // _handleSuccessSwap(PancakeSwap pancakeSwap) {
  //   _onPay(alternativeCoin: _swappingAsset);
  //   _swappingAsset = null;
  //   _swappingAmount = null;
  // }

  Future<bool> _onWillPop() async {
    _onCancel();
    return false;
  }

  PreferredSizeWidget _buildAppBar() {
    if (_paymentType == PaymentType.deposit) {
      return AppBarWidget(
        title: TChainPaymentLocalizations.of(context)!.deposit_confirmation,
      );
    }

    return AppBarWidget(
      title: TChainPaymentLocalizations.of(context)!.select_token,
    );
  }

  Widget _buildWalletError() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Text(
        TChainPaymentLocalizations.of(context)!
            .the_selected_wallet_supports_eth_network_please_select_another_one,
        style: TextStyle(color: themeColors.errorMain),
      ),
    );
  }

  Widget _buildMerchantInfo() {
    return PaymentInfoWidget(
      merchantInfo: widget.merchantInfo,
      onEditNote: (value) {
        _userNotes = value;
      },
    );
  }

  Widget _buildSelectToken() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        _paymentType == PaymentType.deposit
            ? TChainPaymentLocalizations.of(context)!
                .please_select_token_to_deposit
            : TChainPaymentLocalizations.of(context)!
                .please_select_token_to_transfer,
        textAlign: TextAlign.center,
        style: themeTextStyles.subTitle1.copyWith(
          color: oldThemeColors.text10,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildExchangeRateRefreshArea({bool showLoading = false}) {
    return ValueListenableBuilder(
      valueListenable: _exchangeRateCountdown,
      builder: (BuildContext context, int value, Widget? child) {
        String time = '--:--';
        if (!showLoading && _exchangeRateRefreshingTimer != null) {
          final duration = Duration(seconds: value);
          time = duration.toString().substring(2, 7);
        }

        return Container(
          padding:
              const EdgeInsets.only(left: 16, right: 10, top: 12, bottom: 12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: oldThemeColors.bg2.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  textScaleFactor: 1,
                  text: TextSpan(
                    text:
                        '${TChainPaymentLocalizations.of(context)!.exchange_rate_will_be_refreshed_after} ',
                    style: themeTextStyles.body2.copyWith(
                      color: oldThemeColors.text10,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: time,
                        style: themeTextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: oldThemeColors.text11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _onRefreshExchangeRate();
                },
                child: Theme.of(context).getPicture(Assets.refreshCircle),
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildAssets({
    required List<TransferData> transferDataList,
    required bool isLoaded,
  }) {
    final tiles = transferDataList.map((data) {
      return TransferTile(
        transferData: data,
        selectedAsset: _currentAsset,
        useToko: _currentAsset?.isToko == true ? false : _useToko,
        onSelected: (asset, useToko) {
          setState(() {
            _currentAsset = asset;
            _useToko = useToko;
          });
        },
      );
    }).toList();

    if (tiles.isEmpty && isLoaded) {
      // Show error message `Invalid exchange rate`
      return [
        const SizedBox(height: 20),
        Center(
          child: Text(
            TChainPaymentLocalizations.of(context)!.invalid_exchange_rate,
            style: TextStyle(color: oldThemeColors.statusError),
          ),
        ),
      ];
    }

    // show asset tiles. There are 2 states: loading and show info
    return tiles;
  }

  Widget _buildConfirmDesc() {
    return const SizedBox();
    // TODO
    // return Padding(
    //   padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
    //   child: InkWell(
    //     child: RichText(
    //       textAlign: TextAlign.center,
    //       text: TextSpan(
    //         text: TChainPaymentLocalizations.of(context)!
    //                 .program_by_clicking_confirm_you_understood +
    //             ' ',
    //         style: App.theme.textStylesV1.body2
    //             .copyWith(color: App.theme.colorsV1.text1),
    //         children: <TextSpan>[
    //           TextSpan(
    //               text: LocaleKeys.program_our_policy.tr() + '.',
    //               style: App.theme.textStylesV1.button2
    //                   .copyWith(color: App.theme.colorsV1.primary)),
    //         ],
    //       ),
    //     ),
    //     onTap: () => Navigator.pushNamed(context, ScreenRouter.TNC,
    //         arguments: <String, dynamic>{
    //           "item": TermItem.COMMON,
    //         }),
    //   ),
    // );
  }

  Widget _buildConfirmButton(bool? isEnoughBnb) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
        child: ButtonWidget(
          margin: const EdgeInsets.symmetric(vertical: 0),
          onPressed: () => _onPay(),
          enabled: true,
          title: TChainPaymentLocalizations.of(context)!.confirm,
        ),
      ),
    );
  }

  _handleApproveDeposit({
    required Asset asset,
    required num amount,
    required String contractAddress,
  }) async {
    // var result =
    //     await Navigator.pushNamed(context, ScreenRouter.APPROVAL, arguments: {
    //   ScreenRouter.ARG_ASSET: asset,
    //   ScreenRouter.ARG_AMOUNT: amount,
    //   ScreenRouter.ARG_CONTRACT_ADDRESS: contractAddress,
    // });

    // if (result != null) _onPay();
  }

  _onCancel() async {
    DeepLinkService.instance.cancel(
      bundleID: widget.bundleId,
      notes: '',
    );

    _onCloseScreen();
  }

  _onPay({Asset? alternativeCoin}) {
    final asset = alternativeCoin ?? _currentAsset;
    if (asset == null) return;

    // because the backend is using the same field `notes` to do 2 use-cases:
    // - pos qr, app to app: the notes serves as a store of order id
    // - qr payment like ovo: the notes server as a store of user's note
    final notes =
        widget.merchantInfo.notes == null || widget.merchantInfo.notes!.isEmpty
            ? _userNotes
            : widget.merchantInfo.notes!;

    _paymentDepositCubit.deposit(
      walletAddress: '', // TODO
      asset: asset,
      useToko: asset.contractAddress == Config.bscTokoinContractAddress
          ? true
          : _useToko,
      notes: notes,
      merchantID: widget.merchantInfo.merchantId,
      chainID: widget.merchantInfo.chainId != null
          ? widget.merchantInfo.chainId.toString()
          : Config.bscChainID.toString(),
    );
  }

  _onCloseScreen() {
    if (widget.bundleId == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context)
        ..pop()
        ..pop();
    }
  }

  _onRetry() {
    _paymentDepositCubit.getAllInfo();
    // _walletCubit.walletStarted();
  }
}
