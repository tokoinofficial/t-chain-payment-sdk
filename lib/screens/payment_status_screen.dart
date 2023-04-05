import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/widgets/app_bar_widget.dart';
import 'package:t_chain_payment_sdk/widgets/button_widget.dart';

enum PaymentType {
  deposit,
  payment,
}

enum PaymentTransactionStatus {
  processing,
  success,
  failed,
}

class PaymentStatusScreen extends StatelessWidget {
  static const waitingTimeBeforeClosingScreenInSeconds = 3;
  factory PaymentStatusScreen.proceeding({
    required PaymentType type,
    required int second,
  }) =>
      PaymentStatusScreen(
        paymentType: type,
        second: second,
        status: PaymentTransactionStatus.processing,
      );

  factory PaymentStatusScreen.completed(
          {required PaymentType type,
          required int second,
          Function()? onViewTransactionDetail}) =>
      PaymentStatusScreen(
        paymentType: type,
        second: second,
        status: PaymentTransactionStatus.success,
        onViewTransactionDetail: onViewTransactionDetail,
      );

  factory PaymentStatusScreen.failed({
    required PaymentType type,
    required int second,
    Function()? onRetry,
  }) =>
      PaymentStatusScreen(
        paymentType: type,
        second: second,
        status: PaymentTransactionStatus.failed,
        onRetry: onRetry,
      );

  const PaymentStatusScreen({
    Key? key,
    this.paymentType = PaymentType.payment,
    this.second = waitingTimeBeforeClosingScreenInSeconds,
    required this.status,
    this.onViewTransactionDetail,
    this.onRetry,
  }) : super(key: key);

  final PaymentType paymentType;
  final int second;
  final PaymentTransactionStatus status;
  final Function()? onViewTransactionDetail;
  final Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: themeColors.mainBgPrimary,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: _buildIcon(context)),
                        const SizedBox(height: 24),
                        _buildTitle(context),
                        const SizedBox(height: 12),
                        _buildDesc(context),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    String title;

    if (paymentType == PaymentType.deposit) {
      title = TChainPaymentLocalizations.of(context)!.deposit_payment_status;
    } else {
      title = TChainPaymentLocalizations.of(context)!.payment_status;
    }

    return AppBarWidget(
      title: title,
      showBackButton: false,
    );
  }

  Widget _buildIcon(BuildContext context) {
    switch (status) {
      case PaymentTransactionStatus.success:
        return Theme.of(context).getPicture(
          Assets.paymentCompleted,
          darkName: Assets.paymentCompletedDark,
          fit: BoxFit.none,
        );
      case PaymentTransactionStatus.failed:
        return Theme.of(context).getPicture(
          Assets.paymentFailed,
          darkName: Assets.paymentFailedDark,
        );
      case PaymentTransactionStatus.processing:
        return Theme.of(context).getPicture(
          Assets.paymentProceeding,
          darkName: Assets.paymentProceedingDark,
        );
    }
  }

  Widget _buildTitle(BuildContext context) {
    TextStyle style = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 21,
    );

    switch (status) {
      case PaymentTransactionStatus.success:
        return Text(
          TChainPaymentLocalizations.of(context)!.payment_completed,
          style: style.copyWith(
            color: oldThemeColors.statusSuccess,
          ),
        );
      case PaymentTransactionStatus.failed:
        return Text(
          TChainPaymentLocalizations.of(context)!.payment_failed,
          style: style.copyWith(
            color: oldThemeColors.statusError,
          ),
        );
      case PaymentTransactionStatus.processing:
        return Text(
          TChainPaymentLocalizations.of(context)!.payment_proceeding,
          style: style.copyWith(
            color: oldThemeColors.statusWarning,
          ),
        );
    }
  }

  Widget _buildDesc(BuildContext context) {
    final style = themeTextStyles.body1.copyWith(
      color: oldThemeColors.text11,
    );

    switch (status) {
      case PaymentTransactionStatus.success:
        return Text(
          paymentType == PaymentType.deposit
              ? TChainPaymentLocalizations.of(context)!
                  .payment_completed_brought_back_3rdapp(second.toString())
              : TChainPaymentLocalizations.of(context)!
                  .payment_completed_successfully,
          style: style,
          textAlign: TextAlign.center,
        );
      case PaymentTransactionStatus.failed:
        return Text(
          paymentType == PaymentType.deposit
              ? TChainPaymentLocalizations.of(context)!
                  .payment_failed_brought_back_3rdapp(second.toString())
              : TChainPaymentLocalizations.of(context)!
                  .unfortunately_payment_failed,
          style: style,
          textAlign: TextAlign.center,
        );
      case PaymentTransactionStatus.processing:
        String text = '';
        if (paymentType == PaymentType.deposit) {
          text = TChainPaymentLocalizations.of(context)!
              .payment_proceeding_brought_back_3rdapp(second.toString());
        } else {
          text = second == 0
              ? TChainPaymentLocalizations.of(context)!
                  .payment_proceeding_can_take_longer
              : TChainPaymentLocalizations.of(context)!
                  .payment_proceeding_can_take_up(second.toString());
        }

        return Text(
          text,
          style: style,
          textAlign: TextAlign.center,
        );
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    if (paymentType == PaymentType.deposit) {
      return const Expanded(
        flex: 3,
        child: SizedBox(),
      );
    }

    switch (status) {
      case PaymentTransactionStatus.success:
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
            child: ButtonWidget(
              onPressed: () {
                // TODO
                // Navigator.of(context).popUntil(
                //   (route) => route.settings.name == ScreenRouter.MAIN,
                // );
              },
              title: TChainPaymentLocalizations.of(context)!.go_to_home,
            ),
          ),
        );
      case PaymentTransactionStatus.failed:
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
                child: ButtonWidget(
                  onPressed: () => onRetry?.call(),
                  title: TChainPaymentLocalizations.of(context)!.retry,
                ),
              ),
              ButtonWidget(
                onPressed: () {
                  // TODO
                  // Navigator.of(context).popUntil(
                  //   (route) => route.settings.name == ScreenRouter.MAIN,
                  // );
                },
                title: TChainPaymentLocalizations.of(context)!.go_to_home,
              ),
            ],
          ),
        );
      case PaymentTransactionStatus.processing:
        return const Expanded(
          flex: 3,
          child: SizedBox(),
        );
    }
  }
}
