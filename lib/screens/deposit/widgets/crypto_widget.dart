import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/screens/deposit/widgets/chain_tag_widget.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';

class CryptoWidget extends StatelessWidget {
  final Asset asset;
  final bool fullNameStyle;
  final double iconSize;
  final bool hasArrow;
  final TextStyle? nameTextStyle;

  const CryptoWidget(
    this.asset, {
    Key? key,
    this.fullNameStyle = true,
    this.iconSize = 24,
    this.hasArrow = false,
    this.nameTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullName = asset.fullName;
    String shortName = asset.shortName;
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          Theme.of(context)
              .getPicture(asset.iconName, width: iconSize, fit: BoxFit.fill),
          Gaps.px8,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullNameStyle ? '$fullName ($shortName)' : shortName,
                style: nameTextStyle ??
                    TextStyles.headline.copyWith(
                      color: themeColors.textPrimary,
                    ),
              ),
              Gaps.px4,
              const ChainTagWidget(),
            ],
          ),
          hasArrow
              ? Icon(Icons.arrow_drop_down,
                  color: themeColors.separator, size: 30)
              : Container()
        ],
      ),
    );
  }
}
