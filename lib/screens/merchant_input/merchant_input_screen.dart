import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_chain_payment_sdk/bloc/payment/payment_info_cubit.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/common/deep_link_service.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/screens/t_chain_root.dart';
import 'package:t_chain_payment_sdk/screens/t_chain_router_const.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:t_chain_payment_sdk/common/app_bar_widget.dart';
import 'package:t_chain_payment_sdk/screens/merchant_input/widgets/currency_selection_widget.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';
import 'package:t_chain_payment_sdk/common/ui_style.dart';

class MerchantInputScreen extends StatefulWidget {
  const MerchantInputScreen({
    Key? key,
    this.merchantInfo,
    this.qrCode,
    this.bundleId,
  }) : super(key: key);

  final MerchantInfo? merchantInfo;
  final String? qrCode;
  final String? bundleId;

  @override
  State<MerchantInputScreen> createState() => _MerchantInputScreenState();
}

class _MerchantInputScreenState extends State<MerchantInputScreen>
    with UIStyle {
  late TextEditingController _amountController;
  late PaymentInfoCubit _paymentInfoCubit;
  MerchantInfo? _paymentInfo;
  bool _canEditAmount = false;

  @override
  void initState() {
    super.initState();

    final paymentRepository = context.read<PaymentRepository>();
    _paymentInfoCubit = PaymentInfoCubit(paymentRepository: paymentRepository);
    if (widget.merchantInfo != null) {
      _paymentInfoCubit.setPaymentInfo(merchantInfo: widget.merchantInfo!);
      _paymentInfo = widget.merchantInfo?.copyWith();
      _canEditAmount = widget.merchantInfo?.isDynamic ?? false;
    } else {
      _paymentInfoCubit.getPaymentInfo(
        qrCode: widget.qrCode,
        currentChainId: TChainPaymentSDK.shared.chainIdString,
      );
    }

    _amountController = TextEditingController(
      text: _paymentInfo == null || _paymentInfo!.isDynamic
          ? ''
          : _paymentInfo!.amount!.toString(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paymentInfoCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          title: TChainPaymentLocalizations.of(context)!.enter_transfer_amount,
          leading: CloseButton(onPressed: () {
            final currentContext = tChainNavigatorKey.currentContext;
            if (currentContext != null) {
              Navigator.of(currentContext, rootNavigator: true).pop();
            }
          }),
        ),
        backgroundColor: themeColors.mainBgPrimary,
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<PaymentInfoCubit, PaymentInfoState>(
          bloc: _paymentInfoCubit,
          listener: (context, state) {
            if (state is PaymentInfoLoaded) {
              _paymentInfo = state.merchantInfo;
              _canEditAmount = _paymentInfo?.isDynamic ?? false;
              _amountController = TextEditingController(
                text: _paymentInfo == null || _paymentInfo!.isDynamic
                    ? ''
                    : _paymentInfo!.amount!.toString(),
              );

              _onContinuePressed();
            }
          },
          builder: (context, state) {
            if (state is PaymentInfoUnsupported) {
              return Center(
                child: Text(
                  TChainPaymentLocalizations.of(context)!.invalid_code,
                ),
              );
            }

            if (_paymentInfo == null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildMerchantClient(),
                            Gaps.px16,
                            buildLabel(
                              context,
                              title: TChainPaymentLocalizations.of(context)!
                                  .transfer_amount,
                            ),
                            Gaps.px4,
                            _buildAmountInput(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _buildContinueButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMerchantClient() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: themeColors.warningMain08,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Theme.of(context).getPicture(Assets.merchant),
          Gaps.px8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  TChainPaymentLocalizations.of(context)!.merchant_client,
                  style: TextStyles.caption1.copyWith(
                    color: themeColors.textSecondary,
                  ),
                ),
                Text(
                  _paymentInfo?.fullname ?? '',
                  style: TextStyles.headline.copyWith(
                    color: themeColors.textPrimary,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    if (_paymentInfo == null) return const SizedBox();

    final borderRadius = BorderRadius.circular(8);
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: borderRadius,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: themeColors.fillBgSecondary),
        borderRadius: borderRadius,
      ),
      child: Row(children: [
        Expanded(
            child: TextFormField(
          controller: _amountController,
          autofocus: false,
          style: TextStyles.title2.copyWith(color: themeColors.textPrimary),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.,]"))
          ],
          decoration: InputDecoration(
            hintText: '0.0',
            border: border,
            focusedBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            enabledBorder: border,
            disabledBorder: border,
            isCollapsed: true,
            isDense: true,
            fillColor: themeColors.mainBgPrimary,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            hintStyle: TextStyles.title2.copyWith(
              color: themeColors.textTertiary,
            ),
            filled: true,
            enabled: _canEditAmount,
          ),
          onChanged: (value) {
            final amount = double.tryParse(value) ?? 0;

            _paymentInfo = _paymentInfo!.copyWith(amount: amount);
          },
        )),
        const SizedBox(
          height: 54,
          child: VerticalDivider(
            indent: 4,
            endIndent: 4,
            width: 1,
            thickness: 1,
          ),
        ),
        GestureDetector(
          onTap: _canEditAmount ? _showCurrencyListBottomSheet : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Theme.of(context).getPicture(
                  _paymentInfo!.currency.toCurrency().icon,
                  width: 24,
                  height: 24,
                ),
                Gaps.px8,
                Text(
                  _paymentInfo!.currency.toCurrency().shortName,
                  style: TextStyles.subhead2.copyWith(
                    color: themeColors.textSecondary,
                  ),
                ),
                Gaps.px4,
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Theme.of(context).getPicture(Assets.chevronDown),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildContinueButton() {
    return ValueListenableBuilder(
      valueListenable: _amountController,
      builder: (context, TextEditingValue? value, child) {
        final amount = double.tryParse(value?.text ?? '') ?? 0;
        final enabled = amount > 0;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: buildElevatedButton(
              context,
              onPressed: enabled ? () => _onContinuePressed() : null,
              title: TChainPaymentLocalizations.of(context)!.btn_continue,
            ),
          ),
        );
      },
    );
  }

  _showCurrencyListBottomSheet() async {
    if (_paymentInfo == null) return const SizedBox();

    FocusScope.of(context).unfocus();

    final selectedCurrency = await CurrencySelectionWidget.showBottomSheet(
      context,
      currentCurrency: _paymentInfo!.currency.toCurrency(),
    );

    if (selectedCurrency != null) {
      if (_paymentInfo!.currency.toCurrency() == selectedCurrency) return;

      setState(() {
        _paymentInfo = _paymentInfo!.copyWith(
          currency: selectedCurrency.shortName,
        );
      });
    }
  }

  _onContinuePressed() {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    // to make sure the payment info contains the amount and currency
    _paymentInfo = _paymentInfo!.copyWith(
      amount: amount,
      currency: _paymentInfo!.currency.toCurrency().shortName,
    );

    Navigator.of(context).pushNamed(TChainRouterConst.kDeposit, arguments: {
      TChainRouterConst.kArgMerchantInfo: _paymentInfo!,
      TChainRouterConst.kArgBunderId: widget.bundleId,
    });
  }

  Future<bool> _onWillPop() async {
    _onCancel();
    return false;
  }

  _onCancel() async {
    DeepLinkService.instance.cancel(
      bundleID: widget.bundleId,
      notes: '',
    );

    Navigator.of(context).pop();
  }
}
