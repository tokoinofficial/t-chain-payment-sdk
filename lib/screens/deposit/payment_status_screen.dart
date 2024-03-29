import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/screens/t_chain_root.dart';
import 'package:t_chain_payment_sdk/common/app_bar_widget.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';
import 'package:t_chain_payment_sdk/common/ui_style.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum PaymentType {
  deposit,
  payment,
}

enum PaymentTransactionStatus {
  processing,
  success,
  failed,
}

class PaymentStatusScreen extends StatelessWidget with UIStyle {
  static const kWaitingTimeBeforeClosingScreenInSeconds = 3;
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
          required String txn,
          Function()? onViewTransactionDetail}) =>
      PaymentStatusScreen(
        paymentType: type,
        second: second,
        status: PaymentTransactionStatus.success,
        onViewTransactionDetail: onViewTransactionDetail,
        txn: txn,
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
    this.second = kWaitingTimeBeforeClosingScreenInSeconds,
    required this.status,
    this.txn,
    this.onViewTransactionDetail,
    this.onRetry,
  }) : super(key: key);

  final PaymentType paymentType;
  final int second;
  final PaymentTransactionStatus status;
  final String? txn;
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 105),
                      _buildIcon(context),
                      Gaps.px24,
                      _buildTitle(context),
                      Gaps.px12,
                      _buildDesc(context),
                    ],
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
      title = Utils.getLocalizations(context).deposit_payment_status;
    } else {
      title = Utils.getLocalizations(context).payment_status;
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
          fit: BoxFit.none,
        );
      case PaymentTransactionStatus.failed:
        return Theme.of(context).getPicture(
          Assets.paymentFailed,
        );
      case PaymentTransactionStatus.processing:
        return Theme.of(context).getPicture(
          Assets.paymentProceeding,
        );
    }
  }

  Widget _buildTitle(BuildContext context) {
    TextStyle style = TextStyles.headline;

    switch (status) {
      case PaymentTransactionStatus.success:
        return Text(
          Utils.getLocalizations(context).payment_completed,
          style: style.copyWith(
            color: themeColors.successMain,
          ),
        );
      case PaymentTransactionStatus.failed:
        return Text(
          Utils.getLocalizations(context).payment_failed,
          style: style.copyWith(
            color: themeColors.errorMain,
          ),
        );
      case PaymentTransactionStatus.processing:
        return Text(
          Utils.getLocalizations(context).payment_proceeding,
          style: style.copyWith(
            color: themeColors.primaryYellow,
          ),
        );
    }
  }

  Widget _buildDesc(BuildContext context) {
    final style = TextStyle(
      letterSpacing: -0.24,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 22.5 / 15,
      color: themeColors.textPrimary,
      fontFamily: 'SF Pro Text',
    );

    // final style = TextStyles.subhead1.copyWith(
    //   color: themeColors.textPrimary,
    // );

    switch (status) {
      case PaymentTransactionStatus.success:
        return Text(
          paymentType == PaymentType.deposit
              ? Utils.getLocalizations(context)
                  .payment_completed_brought_back_3rdapp(second.toString())
              : Utils.getLocalizations(context).payment_completed_successfully,
          style: style,
          textAlign: TextAlign.center,
        );
      case PaymentTransactionStatus.failed:
        return Text(
          paymentType == PaymentType.deposit
              ? Utils.getLocalizations(context)
                  .payment_failed_brought_back_3rdapp(second.toString())
              : Utils.getLocalizations(context).unfortunately_payment_failed,
          style: style,
          textAlign: TextAlign.center,
        );
      case PaymentTransactionStatus.processing:
        String text = '';
        if (paymentType == PaymentType.deposit) {
          text = Utils.getLocalizations(context)
              .payment_proceeding_brought_back_3rdapp(second.toString());
        } else {
          text = second == 0
              ? Utils.getLocalizations(context)
                  .payment_proceeding_can_take_longer
              : Utils.getLocalizations(context)
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextButton(
                context,
                onPressed: () {
                  launchUrlString('${Config.bscTxUrl}$txn');
                },
                title: Utils.getLocalizations(context).view_transaction_detail,
              ),
              Gaps.px16,
              buildElevatedButton(
                context,
                onPressed: () {
                  final currentContext = tChainNavigatorKey.currentContext;
                  if (currentContext != null) {
                    Navigator.of(currentContext, rootNavigator: true).pop(true);
                  }
                },
                title: Utils.getLocalizations(context).go_home,
              ),
            ],
          ),
        );

      case PaymentTransactionStatus.failed:
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextButton(
                context,
                onPressed: () {
                  final currentContext = tChainNavigatorKey.currentContext;
                  if (currentContext != null) {
                    Navigator.of(currentContext, rootNavigator: true)
                        .pop(false);
                  }
                },
                title: Utils.getLocalizations(context).go_home,
              ),
              Gaps.px16,
              buildElevatedButton(
                context,
                onPressed: () => onRetry?.call(),
                title: Utils.getLocalizations(context).retry,
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
