import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';

class ChainTagWidget extends StatelessWidget {
  const ChainTagWidget({Key? key}) : super(key: key);

  static const double paddingBottom = 3;

  @override
  Widget build(BuildContext context) {
    final bgColor = themeColors.warningMain56;
    final textColor = themeColors.warningDarker;

    return Opacity(
      opacity: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(34),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: paddingBottom),
          child: Text(
            'BEP20',
            style: TextStyles.caption2.copyWith(
              color: textColor,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
