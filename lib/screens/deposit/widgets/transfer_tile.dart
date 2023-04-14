import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/currency.dart';
import 'package:t_chain_payment_sdk/data/transfer_data.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/screens/deposit/widgets/crypto_widget.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';
import 'package:t_chain_payment_sdk/screens/deposit/widgets/unable_to_apply_discount_widget.dart';

class TransferTile extends StatelessWidget {
  const TransferTile({
    Key? key,
    required this.transferData,
    this.selectedAsset,
    this.useToko = false,
    this.onSelected,
  }) : super(key: key);

  final TransferData transferData;
  final Asset? selectedAsset;
  final bool useToko;
  final Function(Asset?, bool)? onSelected;

  bool get isSelected => transferData.asset == selectedAsset;
  bool get enable =>
      transferData.tokoAsset != null &&
      transferData.discountInfo != null &&
      transferData.gasFee != null &&
      transferData.serviceFeePercent != null &&
      transferData.exchangeRate != null &&
      isTokenEnough == true;

  double? get serviceFee {
    final transferAmount = transferData.transferAmount;
    if (transferAmount != null &&
        transferData.discountInfo != null &&
        transferData.serviceFeePercent != null) {
      double value;
      if (isSelected && useToko && transferData.asset.isNotToko) {
        final discountPercent = transferData.discountInfo!.discountFeePercent /
            transferData.serviceFeePercent! *
            100;
        final percent = 100 - discountPercent;
        value = transferAmount *
            transferData.serviceFeePercent! /
            100 *
            percent /
            100;
      } else {
        value = transferAmount * transferData.serviceFeePercent! / 100;
      }

      return value;
    }

    return null;
  }

  bool? get isTokenEnough => transferData.transferAmount != null &&
          serviceFee != null
      ? transferData.asset.balance >= transferData.transferAmount! + serviceFee!
      : null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: enable && isSelected
            ? themeColors.infoMain08
            : themeColors.fillBgWhite,
        border: Border.all(
          color: enable && isSelected
              ? Colors.transparent
              : themeColors.fillBgSecondary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: enable
              ? () => onSelected?.call(transferData.asset, useToko)
              : null,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAssetInfo(),
              Gaps.px12,
              _buildBnbTransactionFee(context),
              Gaps.px6,
              if (isSelected && useToko && transferData.asset.isNotToko) ...[
                _buildPayWithTokoin(context),
                Gaps.px6,
              ],
              _buildServiceFee(context),
              if (isSelected && useToko && transferData.asset.isNotToko) ...[
                _buildAppliedDiscount(context),
              ],
              Gaps.px6,
              _buildExchangeRate(context),
              Gaps.px12,
              if (isSelected) _buildDiscountSelection(context),
              _buildTransferAmount(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Row(
        children: [
          Expanded(
            child: CryptoWidget(
              transferData.asset,
              iconSize: 56,
              nameTextStyle: TextStyles.headline.copyWith(
                color: themeColors.textPrimary,
              ),
            ),
          ),
          Transform.scale(
            scale: 1.6,
            child: Radio(
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return themeColors.textQuarternary;
                }

                if (states.contains(MaterialState.selected)) {
                  return themeColors.primaryBlue;
                }

                return themeColors.textSecondary;
              }),
              value: transferData.asset,
              groupValue: selectedAsset,
              onChanged: enable
                  ? (_) => onSelected?.call(transferData.asset, useToko)
                  : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              toggleable: enable,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBnbTransactionFee(BuildContext context) {
    double multiplier = 1; // once for payment
    if (!transferData.asset.isStableCoin &&
        transferData.asset != transferData.tokoAsset) {
      multiplier = 2; // once for swapping and once for payment
    }

    final value = transferData.gasFee?.getFeeValue(
          multiplier: multiplier,
        ) ??
        '';
    return _buildInfo(
      title: Utils.getLocalizations(context).transaction_fee,
      value: value,
      showLoading: value == '',
    );
  }

  Widget _buildPayWithTokoin(BuildContext context) {
    if (transferData.discountInfo == null || transferData.tokoAsset == null) {
      return const SizedBox();
    }

    final amountToko =
        '${TokoinNumber.fromNumber(transferData.discountInfo!.deductAmount).getFormalizedString()} ${transferData.tokoAsset!.shortName}';
    return _buildInfo(
      title: Utils.getLocalizations(context).pay_toko_amount,
      value: amountToko,
    );
  }

  Widget _buildServiceFee(BuildContext context) {
    String? total = '';

    double? value = serviceFee;
    if (value != null) {
      total =
          '${value.removeTrailingZeros(fractionDigits: 8)} ${transferData.asset.shortName}';
    }

    return _buildInfo(
      title: Utils.getLocalizations(context).service_fee,
      value: total,
      showLoading: total == '',
    );
  }

  Widget _buildExchangeRate(BuildContext context) {
    String value = '';
    if (transferData.exchangeRate != null) {
      final roundedExchangeRate =
          ((transferData.exchangeRate! * 10000).toInt() / 10000).toDouble();
      value =
          '1 ${transferData.asset.shortName} = ~${transferData.currency.shortName} ${TokoinNumber.fromNumber(roundedExchangeRate).getFormalizedString()}';
    }

    return _buildInfo(
        title: Utils.getLocalizations(context).exchange_rate,
        value: value,
        showLoading: value == '');
  }

  Widget _buildTransferAmount(BuildContext context) {
    final valueColor = enable && isSelected
        ? themeColors.textPrimary
        : themeColors.successDark;
    final value = transferData.transferAmount == null
        ? ''
        : '${TokoinNumber.fromNumber(transferData.transferAmount!).getFormalizedString()} ';
    final unit =
        transferData.exchangeRate == null ? '' : transferData.asset.shortName;

    return Container(
      decoration: BoxDecoration(
        color: isTokenEnough != true
            ? themeColors.errorMain08
            : (enable && isSelected
                ? themeColors.successMain88
                : themeColors.successMain08),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        children: [
          _buildInfo(
            title: Utils.getLocalizations(context).you_will_transfer,
            valueWidget: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.headline.copyWith(
                      color: valueColor,
                    ),
                  ),
                ),
                Text(
                  unit,
                  maxLines: 1,
                  style: TextStyles.subhead2.copyWith(
                    color: valueColor,
                  ),
                ),
              ],
            ),
            titleColor: enable && isSelected ? themeColors.textPrimary : null,
            valueColor: valueColor,
            showLoading: value == '',
          ),
          if (isTokenEnough != true) _buildWarning(context) else Gaps.px8,
        ],
      ),
    );
  }

  Widget _buildInfo({
    required String title,
    String? value,
    Widget? valueWidget,
    Color? titleColor,
    Color? valueColor,
    bool showLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$title:',
              style: TextStyles.footnote.copyWith(
                color: titleColor ?? themeColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ColoredBox(
              color: !showLoading
                  ? Colors.transparent
                  : themeColors.fillBgQuarternary,
              child: Shimmer(
                enabled: showLoading,
                child: valueWidget ??
                    (value == null
                        ? const SizedBox()
                        : AutoSizeText(
                            value,
                            maxLines: 1,
                            minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.subhead2.copyWith(
                              color: valueColor ?? themeColors.textPrimary,
                            ),
                          )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppliedDiscount(BuildContext context) {
    if (transferData.tokoAsset == null ||
        transferData.serviceFeePercent == null) return const SizedBox();

    final discountPercent = transferData.discountInfo!.discountFeePercent /
        transferData.serviceFeePercent! *
        100;
    final desc = Utils.getLocalizations(context).x_discount_applied(
      discountPercent.removeTrailingZeros(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        desc,
        textAlign: TextAlign.start,
        style: TextStyles.caption3.copyWith(
          color: themeColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildWarning(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        children: [
          Theme.of(context).getPicture(Assets.balanceWarning),
          Gaps.px8,
          Expanded(
            child: Text(
              Utils.getLocalizations(context).insufficient_balance_to_use_token,
              style: TextStyles.subhead1.copyWith(color: themeColors.errorMain),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDiscountSelection(BuildContext context) {
    if (transferData.discountInfo == null ||
        (transferData.serviceFeePercent == null ||
            transferData.serviceFeePercent! <= 0) ||
        transferData.tokoAsset == null) {
      return const SizedBox();
    }

    final normalStyle =
        TextStyles.subhead1.copyWith(color: themeColors.textPrimary);
    final boldStyle =
        TextStyles.subhead2.copyWith(color: themeColors.textPrimary);

    final amountToko =
        '${TokoinNumber.fromNumber(transferData.discountInfo!.deductAmount).getFormalizedString()} ${transferData.tokoAsset!.shortName}';
    final discount =
        '${(transferData.discountInfo!.discountFeePercent / transferData.serviceFeePercent! * 100).removeTrailingZeros()}% ${Utils.getLocalizations(context).discount}';
    final balance =
        '${TokoinNumber.fromNumber(transferData.tokoAsset!.balance).getFormalizedString()} ${transferData.tokoAsset!.shortName}';

    return GestureDetector(
      onTap: () {
        if (transferData.tokoAsset!.balance <
            transferData.discountInfo!.deductAmount) {
          _showUnableToApplyDiscount(context);
        } else {
          onSelected?.call(transferData.asset, !useToko);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        decoration: BoxDecoration(
          color: themeColors.warningLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Theme.of(context).getPicture(
              useToko ? Assets.checkboxOn : Assets.checkboxOff,
            ),
            Gaps.px12,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RichText(
                  textScaleFactor: 1,
                  text: TextSpan(
                    text: Utils.getLocalizations(context).use_toko_pay,
                    style: normalStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: amountToko,
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: Utils.getLocalizations(context).use_toko_to_get,
                      ),
                      TextSpan(
                        text: discount,
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: Utils.getLocalizations(context)
                            .use_toko_of_service_fee,
                      ),
                      TextSpan(
                        text: balance,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: ')',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showUnableToApplyDiscount(BuildContext context) {
    if (transferData.discountInfo == null || transferData.tokoAsset == null) {
      return;
    }

    final discountPercent = (transferData.discountInfo!.discountFeePercent /
            transferData.serviceFeePercent! *
            100)
        .removeTrailingZeros();

    UnableToApplyDiscountWidget.showBottomSheet(
      context,
      transferData: transferData,
      discountPercent: discountPercent,
    );
  }
}
