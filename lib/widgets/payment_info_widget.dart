import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_chain_payment_sdk/bloc/payment_deposit_cubit.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/gen/assets.gen.dart';
import 'package:t_chain_payment_sdk/helpers/tokoin_number.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/widgets/add_note_popup_widget.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            color: oldThemeColors.statusWarning2.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12)),
        child: BlocBuilder<PaymentDepositCubit, PaymentDepositState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildInfo(
                  icon: Theme.of(context).getPicture(Assets.paymentStore,
                      darkName: Assets.paymentStoreDark),
                  title:
                      TChainPaymentLocalizations.of(context)!.merchant_client,
                  value: widget.merchantInfo.fullname,
                ),
                const SizedBox(height: 16),
                _buildAmount(),
                const SizedBox(height: 16),
                _buildNotes(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAmount() {
    final numberStyle = themeTextStyles.title4.copyWith(
      fontWeight: FontWeight.bold,
      color: oldThemeColors.text11,
    );
    final unitStyle =
        numberStyle.copyWith(fontSize: (numberStyle.fontSize ?? 16) - 4);

    return _buildInfo(
      icon: Theme.of(context)
          .getPicture(Assets.paymentAmount, darkName: Assets.paymentAmountDark),
      title: TChainPaymentLocalizations.of(context)!.payment_amount,
      child: RichText(
        textScaleFactor: 1,
        text: TextSpan(
          text: widget.merchantInfo.currency + ' ',
          style: unitStyle,
          children: <TextSpan>[
            TextSpan(
              text: TokoinNumber.fromNumber(widget.merchantInfo.amount ?? 0)
                  .getFormalizedString(),
              style: numberStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes() {
    final buttonStyle = themeTextStyles.body1.copyWith(
      fontWeight: FontWeight.w600,
      color: oldThemeColors.primary,
    );

    return _buildInfo(
      icon: Theme.of(context)
          .getPicture(Assets.paymentNotes, darkName: Assets.paymentNotesDark),
      title: TChainPaymentLocalizations.of(context)!.note_optional,
      child: _notes.isEmpty
          ? GestureDetector(
              onTap: _showNotes,
              child: Text(
                TChainPaymentLocalizations.of(context)!.add_a_note,
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
                    style: themeTextStyles.body1.copyWith(
                      fontWeight: FontWeight.normal,
                      color: oldThemeColors.text11,
                    ),
                  ),
                ),
                if (widget.merchantInfo.notes == null ||
                    widget.merchantInfo.notes!.isEmpty) ...[
                  const SizedBox(width: 8),
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
    String? value = '',
    Widget? child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title:',
                style: themeTextStyles.body2.copyWith(
                  color: oldThemeColors.text10,
                ),
              ),
              const SizedBox(height: 4),
              child ??
                  Text(
                    '$value',
                    style: themeTextStyles.title4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: oldThemeColors.text11,
                    ),
                  ),
            ],
          ),
        )
      ],
    );
  }

  _showNotes() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext popupContext) {
        return AddNotePopupWidget(
          notes: _notes,
          onEdited: (value) {
            setState(() {
              _notes = value;
              widget.onEditNote?.call(value);
            });
          },
        );
      },
    );
  }
}
