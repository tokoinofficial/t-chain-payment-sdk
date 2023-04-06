import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/data/transfer_data.dart';
import 'package:t_chain_payment_sdk/helpers/tokoin_number.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/widgets/gaps.dart';
import 'package:t_chain_payment_sdk/widgets/ui_style.dart';

class UnableToApplyDiscountWidget extends StatelessWidget with UIStyle {
  static Future<bool> showBottomSheet(
    BuildContext context, {
    required TransferData transferData,
    required String discountPercent,
  }) async {
    return await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (BuildContext popupContext) {
            return UnableToApplyDiscountWidget(
              transferData: transferData,
              discountPercent: discountPercent,
            );
          },
        ) as bool? ??
        false;
  }

  const UnableToApplyDiscountWidget({
    super.key,
    required this.transferData,
    required this.discountPercent,
  });

  final TransferData transferData;
  final String discountPercent;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  TChainPaymentLocalizations.of(context)!
                      .unable_to_apply_discount,
                  textAlign: TextAlign.center,
                  style: TextStyles.title2.copyWith(
                    color: themeColors.primaryBlue,
                  ),
                ),
              ),
              Gaps.px16,
              Text(
                TChainPaymentLocalizations.of(context)!
                    .unable_to_apply_discount_desc(
                  TokoinNumber.fromNumber(transferData.tokoAsset!.balance)
                      .getFormalizedString(),
                  discountPercent,
                ),
                textAlign: TextAlign.center,
                style: TextStyles.body1.copyWith(
                  color: themeColors.textPrimary,
                ),
              ),
              Gaps.px16,
              buildElevatedButton(
                context,
                title: TChainPaymentLocalizations.of(context)!.close,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
