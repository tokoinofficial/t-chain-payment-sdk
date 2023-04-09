import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';

class CurrencySelectionWidget extends StatelessWidget {
  static Future<Currency?> showBottomSheet(BuildContext context,
      {required Currency currentCurrency}) {
    return showModalBottomSheet<Currency>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CurrencySelectionWidget(
          currentCurrency: currentCurrency,
        );
      },
    );
  }

  const CurrencySelectionWidget({
    Key? key,
    required this.currentCurrency,
  }) : super(key: key);

  final Currency currentCurrency;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(context),
        ...Currency.values
            .map((e) => _buildItem(context, currency: e))
            .toList(),
        const SafeArea(child: SizedBox()),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: Text(
        TChainPaymentLocalizations.of(context)!.select_currency,
        textAlign: TextAlign.center,
        style: TextStyles.title2.copyWith(
          color: themeColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required Currency currency,
  }) {
    bool isSelected = currency == currentCurrency;

    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isSelected ? themeColors.infoMain08 : Colors.transparent,
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              Theme.of(context).getPicture(
                currency.icon,
              ),
              Gaps.px12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${currency.name} (${currency.shortName})',
                      style: isSelected
                          ? TextStyles.headline.copyWith(
                              color: themeColors.primaryBlue,
                            )
                          : TextStyles.body1.copyWith(
                              color: themeColors.textPrimary,
                            ),
                    ),
                    if (!currency.available)
                      Container(
                        padding:
                            const EdgeInsets.only(left: 4, right: 4, bottom: 2),
                        decoration: BoxDecoration(
                          color: themeColors.successDark.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          TChainPaymentLocalizations.of(context)!.coming_soon,
                          style: TextStyles.caption3.copyWith(
                            color: themeColors.textAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap:
          currency.available ? () => Navigator.of(context).pop(currency) : null,
    );
  }
}
