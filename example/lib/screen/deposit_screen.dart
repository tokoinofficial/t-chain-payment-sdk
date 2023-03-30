import 'package:example/data/pay_result_route_data.dart';
import 'package:example/router/screen_router.dart';
import 'package:example/utils/utility.dart';
import 'package:example/widgets/deposit_widget.dart';
import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  TChainPaymentCurrency _currency = TChainPaymentCurrency.usd;

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
              DepositWidget(
                amountController: _amountController,
                currency: _currency,
                onCurrencyChanged: (value) {
                  setState(() {
                    _currency = value;
                  });
                },
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

    // For simplicity, the notes - unique id is generated on the local, but you should create the order on your server-side
    final notes = Utility.generateID();

    Navigator.of(context).pushNamed(
      ScreenRouter.payResult,
      arguments: PayResultRouteData(
        notes: notes,
        amount: amount,
        currency: _currency,
        useQRCode: false,
      ),
    );
  }
}
