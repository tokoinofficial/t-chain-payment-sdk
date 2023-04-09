import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/common/gaps.dart';
import 'package:t_chain_payment_sdk/common/ui_style.dart';

class AddNotePopupWidget extends StatefulWidget {
  static Future<String?> showBottomSheet(BuildContext context,
      {required String notes}) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext popupContext) {
        return AddNotePopupWidget(
          notes: notes,
        );
      },
    );
  }

  final String notes;

  const AddNotePopupWidget({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  _AddNotePopupWidgetState createState() => _AddNotePopupWidgetState();
}

class _AddNotePopupWidgetState extends State<AddNotePopupWidget> with UIStyle {
  late TextEditingController _noteController;

  final double inputHeight = 140;

  @override
  void initState() {
    super.initState();

    _noteController = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                TChainPaymentLocalizations.of(context)!.note,
                style: TextStyles.subhead1.copyWith(
                  color: themeColors.textSecondary,
                ),
              ),
              Gaps.px4,
              _buildInput(context),
              Gaps.px16,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: buildOutlinedButton(
                      context,
                      onPressed: () => Navigator.of(context).pop(),
                      title: TChainPaymentLocalizations.of(context)!.cancel,
                    ),
                  ),
                  Gaps.px16,
                  Expanded(
                    child: buildElevatedButton(
                      context,
                      onPressed: () {
                        Navigator.of(context).pop(_noteController.text);
                      },
                      title: TChainPaymentLocalizations.of(context)!.done,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10 + MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: themeColors.fillBgSecondary),
      borderRadius: borderRadius,
    );

    return TextFormField(
      controller: _noteController,
      autofocus: true,
      style: TextStyles.subhead1.copyWith(
        color: themeColors.textPrimary,
      ),
      minLines: 6,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: TChainPaymentLocalizations.of(context)!.write_your_note,
        border: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        isCollapsed: true,
        isDense: true,
        fillColor: themeColors.mainBgPrimary,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        hintStyle: TextStyles.subhead1.copyWith(
          color: themeColors.textTertiary,
        ),
        helperStyle: TextStyles.footnote.copyWith(
          color: themeColors.errorMain,
        ),
        errorStyle: TextStyles.footnote.copyWith(
          color: themeColors.errorMain,
        ),
        filled: true,
      ),
    );
  }
}
