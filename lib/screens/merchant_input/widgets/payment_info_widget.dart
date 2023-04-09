import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_chain_payment_sdk/bloc/payment/payment_deposit_cubit.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/screens/deposit/widgets/add_note_popup_widget.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';

class PaymentInfoWidget extends StatefulWidget {
  final MerchantInfo merchantInfo;
  final Function(String)? onEditNote;

  const PaymentInfoWidget({
    Key? key,
    required this.merchantInfo,
    this.onEditNote,
  }) : super(key: key);

  @override
  State<PaymentInfoWidget> createState() => _PaymentInfoWidgetState();
}

class _PaymentInfoWidgetState extends State<PaymentInfoWidget> {
  late String _notes;

  @override
  void initState() {
    super.initState();

    _notes = widget.merchantInfo.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: themeColors.warningMain08,
            borderRadius: BorderRadius.circular(12)),
        child: BlocBuilder<PaymentDepositCubit, PaymentDepositState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildInfo(
                  icon: Theme.of(context).getPicture(Assets.merchant),
                  title:
                      TChainPaymentLocalizations.of(context)!.merchant_client,
                  value: widget.merchantInfo.fullname,
                ),
                Gaps.px16,
                _buildInfo(
                  icon: Theme.of(context).getPicture(Assets.amount),
                  title: TChainPaymentLocalizations.of(context)!.payment_amount,
                  value: widget.merchantInfo.currency +
                      ' ' +
                      TokoinNumber.fromNumber(widget.merchantInfo.amount ?? 0)
                          .getFormalizedString(),
                ),
                Gaps.px16,
                _buildNotes(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotes() {
    final buttonStyle = TextStyles.subhead2.copyWith(
      color: themeColors.primaryBlue,
    );

    return _buildInfo(
      icon: Theme.of(context).getPicture(Assets.notes),
      title: TChainPaymentLocalizations.of(context)!.note_optional,
      child: _notes.isEmpty
          ? GestureDetector(
              onTap: _showNotes,
              child: Text(
                '  ${TChainPaymentLocalizations.of(context)!.add_note}  ',
                style: buttonStyle,
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    _notes,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.body1.copyWith(
                      fontWeight: FontWeight.normal,
                      color: themeColors.textPrimary,
                    ),
                  ),
                ),
                if (widget.merchantInfo.notes == null ||
                    widget.merchantInfo.notes!.isEmpty) ...[
                  Gaps.px8,
                  GestureDetector(
                    onTap: _showNotes,
                    child: Text(
                      TChainPaymentLocalizations.of(context)!.edit,
                      style: buttonStyle,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildInfo({
    required Widget icon,
    required String title,
    String value = '',
    Widget? child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        Gaps.px8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyles.caption1.copyWith(
                  color: themeColors.textSecondary,
                ),
              ),
              Gaps.px2,
              child ??
                  Text(
                    value,
                    style: TextStyles.headline.copyWith(
                      color: themeColors.textPrimary,
                    ),
                  ),
            ],
          ),
        )
      ],
    );
  }

  _showNotes() async {
    final text = await AddNotePopupWidget.showBottomSheet(
      context,
      notes: _notes,
    );

    if (text != null) {
      setState(() {
        _notes = text;
        widget.onEditNote?.call(text);
      });
    }
  }
}
