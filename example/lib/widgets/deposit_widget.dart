import 'package:example/utils/input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class DepositWidget extends StatelessWidget {
  const DepositWidget({
    Key? key,
    required this.amountController,
    required this.currency,
    required this.onCurrencyChanged,
  }) : super(key: key);

  final TextEditingController amountController;
  final Currency currency;
  final Function(Currency) onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildRow(
          left: const Text(
            'Currency',
            style: TextStyle(color: Colors.grey),
          ),
          right: const Text(
            'Deposit amount',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 16),
        _buildRow(
          left: _buildCurrencySelection(),
          right: _buildDepositAmountWidget(context),
        ),
      ],
    );
  }

  Widget _buildRow({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: left,
        ),
        const SizedBox(width: 16),
        Flexible(child: right),
      ],
    );
  }

  Widget _buildCurrencySelection() {
    return DropdownButton<Currency>(
      key: const Key('btnCurrency'),
      value: currency,
      underline: const SizedBox(),
      isDense: true,
      items: Currency.values.where((element) => element.available).map(
        (e) {
          return DropdownMenuItem(
            key: Key(e.shortName),
            child: Text(e.shortName),
            value: e,
          );
        },
      ).toList(),
      onChanged: (value) {
        if (value == null) return;

        onCurrencyChanged.call(value);
      },
    );
  }

  Widget _buildDepositAmountWidget(BuildContext context) {
    return TextField(
      key: const Key('txtAmount'),
      controller: amountController,
      decoration: const InputDecoration(
        isDense: true,
        isCollapsed: false,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: InputFormatter.positiveNumberAndZero(),
      onEditingComplete: () => {FocusScope.of(context).unfocus()},
    );
  }
}
