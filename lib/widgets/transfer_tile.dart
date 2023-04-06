import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/config/utils.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/currency.dart';
import 'package:t_chain_payment_sdk/data/transfer_data.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/helpers/tokoin_number.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/widgets/crypto_widget.dart';

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
            ? oldThemeColors.primary1.withOpacity(0.2)
            : oldThemeColors.bg1,
        border: Border.all(
          color: enable && isSelected
              ? oldThemeColors.primary2
              : oldThemeColors.bg4,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: enable
              ? () => onSelected?.call(transferData.asset, useToko)
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAssetInfo(),
              const SizedBox(height: 12),
              _buildBnbTransactionFee(context),
              const SizedBox(height: 12),
              if (isSelected && useToko && transferData.asset.isNotToko) ...[
                _buildPayWithTokoin(context),
                const SizedBox(height: 12),
              ],
              _buildServiceFee(context),
              if (isSelected && useToko && transferData.asset.isNotToko) ...[
                _buildAppliedDiscount(context),
              ],
              const SizedBox(height: 12),
              _buildExchangeRate(context),
              const SizedBox(height: 12),
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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        children: [
          Expanded(
            child: CryptoWidget(
              transferData.asset,
              iconSize: 36,
              nameTextStyle: TextStyle(
                  color: oldThemeColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Transform.scale(
            scale: 1.5,
            child: Radio(
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return oldThemeColors.primary.withOpacity(0.2);
                }

                return oldThemeColors.primary;
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
        title: TChainPaymentLocalizations.of(context)!.transaction_fee,
        value: value,
        showLoading: value == '');
  }

  Widget _buildPayWithTokoin(BuildContext context) {
    if (transferData.discountInfo == null || transferData.tokoAsset == null) {
      return const SizedBox();
    }

    final amountToko =
        '${TokoinNumber.fromNumber(transferData.discountInfo!.deductAmount).getFormalizedString()} ${transferData.tokoAsset!.shortName}';
    return _buildInfo(
      title: TChainPaymentLocalizations.of(context)!.pay_toko_amount,
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
      title: TChainPaymentLocalizations.of(context)!.service_fee,
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
        title: TChainPaymentLocalizations.of(context)!.exchange_rate,
        value: value,
        showLoading: value == '');
  }

  Widget _buildTransferAmount(BuildContext context) {
    final valueColor =
        enable && isSelected ? Colors.white : oldThemeColors.statusSuccess4;
    final value = transferData.transferAmount == null
        ? ''
        : '${TokoinNumber.fromNumber(transferData.transferAmount!).getFormalizedString()} ';
    final unit =
        transferData.exchangeRate == null ? '' : transferData.asset.shortName;

    return Container(
      decoration: BoxDecoration(
        color: enable && isSelected
            ? oldThemeColors.primary
            : oldThemeColors.statusWarning2.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildInfo(
            title: TChainPaymentLocalizations.of(context)!.you_will_transfer,
            valueWidget: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: themeTextStyles.body6.copyWith(
                      color: valueColor,
                    ),
                  ),
                ),
                Text(
                  unit,
                  maxLines: 1,
                  style: themeTextStyles.body6.copyWith(
                    color: valueColor,
                  ),
                ),
              ],
            ),
            titleColor: enable && isSelected ? Colors.white : null,
            valueColor: valueColor,
            showLoading: value == '',
          ),
          _buildWarning(context),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$title:',
              style: themeTextStyles.body1.copyWith(
                color: titleColor ?? oldThemeColors.text10,
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: !showLoading
                  ? Colors.transparent
                  : oldThemeColors.bg5.withOpacity(0.3),
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
                            style: themeTextStyles.body6.copyWith(
                              color: valueColor ?? oldThemeColors.text11,
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
    final desc = TChainPaymentLocalizations.of(context)!.x_discount_applied(
      discountPercent.removeTrailingZeros(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        desc,
        textAlign: TextAlign.start,
        style: themeTextStyles.body3.copyWith(
          fontWeight: FontWeight.normal,
          color: oldThemeColors.text10,
        ),
      ),
    );
  }

  Widget _buildWarning(BuildContext context) {
    if (isTokenEnough != false) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        children: [
          Theme.of(context).getPicture(Assets.balanceWarning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              TChainPaymentLocalizations.of(context)!
                  .insufficient_balance_to_use_token,
              style: TextStyle(color: oldThemeColors.statusError),
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

    final normalStyle = themeTextStyles.body3.copyWith(
        fontWeight: FontWeight.normal, color: Colors.white, height: 16.8 / 12);
    final boldStyle = themeTextStyles.body2.copyWith(
        fontWeight: FontWeight.bold, color: Colors.white, height: 19.6 / 14);

    final amountToko =
        '${TokoinNumber.fromNumber(transferData.discountInfo!.deductAmount).getFormalizedString()} ${transferData.tokoAsset!.shortName}';
    final discount =
        '${(transferData.discountInfo!.discountFeePercent / transferData.serviceFeePercent! * 100).removeTrailingZeros()}% ${TChainPaymentLocalizations.of(context)!.discount}';
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
          image: DecorationImage(
            image: Image.asset('assets/v1/payment_service_fee.png').image,
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: Transform.scale(
                scale: 0.8,
                child: Theme.of(context).getPicture(
                  useToko ? Assets.checkboxOn : Assets.checkboxOff,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RichText(
                  textScaleFactor: 1,
                  text: TextSpan(
                    text: TChainPaymentLocalizations.of(context)!.use_toko_pay,
                    style: normalStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: amountToko,
                        style: boldStyle,
                      ),
                      TextSpan(
                          text: TChainPaymentLocalizations.of(context)!
                              .use_toko_to_get),
                      TextSpan(
                        text: discount,
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: TChainPaymentLocalizations.of(context)!
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

  _showUnableToApplyDiscount(BuildContext context) async {
    // TODO
    // if (transferData.discountInfo == null || transferData.tokoAsset == null) {
    //   return;
    // }

    // final discountPercent = (transferData.discountInfo!.discountFeePercent /
    //         transferData.serviceFeePercent! *
    //         100)
    //     .removeTrailingZeros();

    // await showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    //   ),
    //   builder: (BuildContext popupContext) {
    //     return PopupWidget(
    //       title:
    //           TChainPaymentLocalizations.of(context)!.unable_to_apply_discount,
    //       content: Text(
    //         TChainPaymentLocalizations.of(context)!
    //             .unable_to_apply_discount_desc(
    //           TokoinNumber.fromNumber(transferData.tokoAsset!.balance)
    //               .getFormalizedString(),
    //           discountPercent,
    //         ),
    //         textAlign: TextAlign.center,
    //         style: themeTextStyles.body1.copyWith(color: oldThemeColors.text1),
    //       ),
    //       actions: <Widget>[
    //         ButtonWidget(
    //           margin: const EdgeInsets.only(right: 20),
    //           title: TChainPaymentLocalizations.of(context)!.cancel,
    //           onPressed: () {
    //             Navigator.pop(popupContext);
    //           },
    //         ),
    //         ButtonWidget(
    //           title: TChainPaymentLocalizations.of(context)!.deposit,
    //           onPressed: () {
    //             Navigator.pop(popupContext);
    //             // TODO
    //             // Navigator.pushNamed(
    //             //   context,
    //             //   ScreenRouter.ASSET_DETAIL,
    //             //   arguments: {
    //             //     ScreenRouter.ARG_ASSET: transferData.tokoAsset!,
    //             //   },
    //             // );
    //           },
    //         )
    //       ],
    //     );
    //   },
    // );
  }
}
