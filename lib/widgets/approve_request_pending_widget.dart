import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/widgets/gaps.dart';
import 'package:t_chain_payment_sdk/widgets/ui_style.dart';

class ApproveRequestPendingWidget extends StatelessWidget with UIStyle {
  static Future<bool?> showBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext popupContext) {
        return const ApproveRequestPendingWidget();
      },
    );
  }

  const ApproveRequestPendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Gaps.px20,
          applyPadding(Text(
            TChainPaymentLocalizations.of(context)!.approve_request_pending,
            textAlign: TextAlign.center,
            style: TextStyles.title2.copyWith(
              color: themeColors.textPrimary,
            ),
          )),
          Gaps.px12,
          applyPadding(Text(
            TChainPaymentLocalizations.of(context)!.duration_of_approve_request,
            textAlign: TextAlign.center,
            style: TextStyles.footnote.copyWith(
              color: themeColors.textPrimary,
            ),
          )),
          Gaps.px24,
          _buildButtons(context),
          Gaps.px12,
        ],
      ),
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

  Widget _buildButtons(BuildContext context) {
    return applyPadding(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: buildOutlinedButton(
              context,
              key: const Key('btnCancel'),
              title:
                  TChainPaymentLocalizations.of(context)!.send_another_request,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
          Gaps.px16,
          Expanded(
            child: buildElevatedButton(
              context,
              key: const Key('btnWaiting'),
              title: TChainPaymentLocalizations.of(context)!.keep_waiting,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          )
        ],
      ),
      enableBottom: true,
    );
  }
}