import 'package:example/data/pay_result_route_data.dart';
import 'package:example/router/screen_router.dart';
import 'package:example/utils/input_formatter.dart';
import 'package:example/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deposit')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Deposit amount',
                  prefixText: TChainPaymentCurrency.idr.shortName,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: InputFormatter.positiveNumberAndZero(),
                onEditingComplete: () => {FocusScope.of(context).unfocus()},
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _onDeposit,
                child: const Text('Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onDeposit() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    // For simplicity, the order id is generated on the local, but you should create the order on your server-side
    final orderID = Utility.generateID();

    Navigator.of(context).pushNamed(
      ScreenRouter.payResult,
      arguments: PayResultRouteData(
        orderID: orderID,
        amount: amount,
        useQRCode: false,
      ),
    );
  }
}
