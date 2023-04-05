import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:t_chain_payment_sdk/widgets/button_widget.dart';
import 'package:t_chain_payment_sdk/widgets/input_widget.dart';

class AddNotePopupWidget extends StatefulWidget {
  final String notes;
  final Function(String)? onEdited;

  const AddNotePopupWidget({
    Key? key,
    required this.notes,
    this.onEdited,
  }) : super(key: key);

  @override
  _AddNotePopupWidgetState createState() => _AddNotePopupWidgetState();
}

class _AddNotePopupWidgetState extends State<AddNotePopupWidget> {
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                TChainPaymentLocalizations.of(context)!.add_a_note,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: oldThemeColors.text11,
                ),
              ),
              Divider(
                color: oldThemeColors.bg4.withOpacity(0.5),
                height: 32,
              ),
              const SizedBox(height: 8),
              InputWidget(
                controller: _noteController,
                title: TChainPaymentLocalizations.of(context)!.note,
                textStyle: themeTextStyles.title5.copyWith(
                  color: oldThemeColors.text11,
                ),
                autoFocus: true,
                maxLines: 5,
                minLines: 5,
                height: inputHeight,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonWidget(
                      margin: const EdgeInsets.only(right: 20),
                      title: TChainPaymentLocalizations.of(context)!.cancel,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: ButtonWidget(
                      title: TChainPaymentLocalizations.of(context)!.done,
                      onPressed: () {
                        widget.onEdited?.call(_noteController.text);
                        Navigator.of(context).pop();
                      },
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
}
