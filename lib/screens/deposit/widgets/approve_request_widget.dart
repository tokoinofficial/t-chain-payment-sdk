import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:t_chain_payment_sdk/bloc/approve_request/approve_request_cubit.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/repo/storage_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:t_chain_payment_sdk/screens/deposit/widgets/approve_request_pending_widget.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';
import 'package:t_chain_payment_sdk/common/ui_style.dart';

class ApproveRequestWidget extends StatefulWidget {
  static Future<bool?> showBottomSheet(
    BuildContext context, {
    required String contractAddress,
    required Asset asset,
    required num amount,
  }) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext popupContext) {
        return ApproveRequestWidget(
          contractAddress: contractAddress,
          asset: asset,
          amount: amount,
        );
      },
    );
  }

  const ApproveRequestWidget({
    Key? key,
    required this.amount,
    required this.asset,
    required this.contractAddress,
  }) : super(key: key);

  final num amount;
  final Asset asset;
  final String contractAddress;

  @override
  _ApproveRequestWidgetState createState() => _ApproveRequestWidgetState();
}

class _ApproveRequestWidgetState extends State<ApproveRequestWidget>
    with UIStyle {
  late ApproveRequestCubit _approveRequestCubit;
  GasFee? _gasFee;
  bool _loadingApprove = false;

  @override
  void initState() {
    super.initState();
    final walletRepository = context.read<WalletRepository>();
    final storageRepository = context.read<StorageRepository>();
    _approveRequestCubit = ApproveRequestCubit(
      walletRepository: walletRepository,
      storageRepository: storageRepository,
      privateKeyHex: TChainPaymentSDK.shared.account.privateKeyHex,
    );

    _approveRequestCubit.loadTokenInfo(asset: widget.asset);
  }

  @override
  void dispose() {
    _approveRequestCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _approveRequestCubit.localizations =
        TChainPaymentLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproveRequestCubit, ApproveRequestState>(
      bloc: _approveRequestCubit,
      listener: (context, state) {
        _loadingApprove = state is ApproveRequestLoading;

        if (state is ApproveRequestReady) {
          _gasFee = state.gasFee;
        } else if (state is ApproveRequestSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is ApproveRequestWaiting) {
          Utils.toast(TChainPaymentLocalizations.of(context)!.please_try_again);
          Navigator.of(context).pop(false);
        } else if (state is ApproveRequestError) {
          Utils.errorToast(state.error);
        } else if (state is ApproveRequestPending) {
          _showConfirmResendAlert();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Gaps.px20,
              applyPadding(Text(
                TChainPaymentLocalizations.of(context)!.approve_request,
                textAlign: TextAlign.center,
                style: TextStyles.title2.copyWith(
                  color: themeColors.textPrimary,
                ),
              )),
              Gaps.px12,
              applyPadding(Text(
                TChainPaymentLocalizations.of(context)!.allow_this_app_transfer(
                  '${widget.amount} ${widget.asset.shortName}',
                ),
                textAlign: TextAlign.center,
                style: TextStyles.body1.copyWith(
                  color: themeColors.textPrimary,
                ),
              )),
              Gaps.px16,
              _buildDetailsField(),
              Gaps.px32,
              applyPadding(Text(
                TChainPaymentLocalizations.of(context)!
                    .duration_of_approve_request,
                textAlign: TextAlign.center,
                style: TextStyles.footnote.copyWith(
                  color: themeColors.textPrimary,
                ),
              )),
              Gaps.px12,
              _buildButtons(),
              Gaps.px12,
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsField() {
    TextStyle textStyle = TextStyles.footnote.copyWith(
      color: themeColors.textSecondary,
    );
    TextStyle boldTextStyle = TextStyles.subhead2.copyWith(
      color: themeColors.textPrimary,
    );

    return ColoredBox(
      color: themeColors.fillBgQuarternary,
      child: SafeArea(
        bottom: false,
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Table(
            children: [
              TableRow(children: [
                _buildCell(
                  text: '${TChainPaymentLocalizations.of(context)!.from}:',
                  style: textStyle,
                  bottomGap: 8,
                ),
                _buildCell(
                  text: TChainPaymentSDK
                      .shared.account.privateKey.address.hex.shortAddress,
                  style: boldTextStyle,
                  textAlign: TextAlign.right,
                  bottomGap: 8,
                )
              ]),
              TableRow(children: [
                _buildCell(
                  text:
                      '${TChainPaymentLocalizations.of(context)!.transaction_fee}:',
                  style: textStyle,
                ),
                _buildShimmerCell(
                  text: _gasFee == null
                      ? ''
                      : "${_gasFee!.toEthString(kEstimateGasLimitForApprove)} BNB",
                  style: boldTextStyle,
                  textAlign: TextAlign.right,
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell({
    required String text,
    required TextStyle style,
    TextAlign textAlign = TextAlign.left,
    double bottomGap = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: Text(
        text,
        textAlign: textAlign,
        style: style,
      ),
    );
  }

  Widget _buildShimmerCell({
    required String text,
    required TextStyle style,
    TextAlign textAlign = TextAlign.left,
    double bottomGap = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: Shimmer(
        enabled: text.isEmpty,
        color: themeColors.textQuarternary,
        child: Text(
          text,
          textAlign: textAlign,
          style: style,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return applyPadding(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: buildOutlinedButton(
              context,
              key: const Key('btnCancel'),
              title: TChainPaymentLocalizations.of(context)!.cancel,
              onPressed: _loadingApprove
                  ? null
                  : () => Navigator.of(context).pop(false),
            ),
          ),
          Gaps.px16,
          Expanded(
            child: buildElevatedButton(
              context,
              key: const Key('btnApprove'),
              title: TChainPaymentLocalizations.of(context)!.confirm,
              onPressed: _loadingApprove ? null : () => _onApproveDeposit(),
              child: _loadingApprove
                  ? const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(),
                    )
                  : null,
            ),
          )
        ],
      ),
      enableBottom: true,
    );
  }

  Widget applyPadding(Widget child, {bool enableBottom = false}) {
    return SafeArea(
      bottom: enableBottom,
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }

  _onApproveDeposit({bool? resend}) {
    _approveRequestCubit.approve(
      gasPrice: _gasFee?.toGwei(),
      amount: widget.amount,
      asset: widget.asset,
      resend: resend ?? false,
      contractAddress: widget.contractAddress,
    );
  }

  _showConfirmResendAlert() async {
    final isResend = await ApproveRequestPendingWidget.showBottomSheet(context);

    if (isResend == true) {
      _onApproveDeposit(resend: true);
    } else {
      Navigator.of(context).pop();
    }
  }
}
