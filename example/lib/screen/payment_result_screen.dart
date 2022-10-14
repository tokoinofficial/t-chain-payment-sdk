import 'package:example/cubit/payment/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentResultScreen extends StatefulWidget {
  const PaymentResultScreen({
    Key? key,
    required this.orderID,
    required this.amount,
    required this.useQRCode,
  }) : super(key: key);

  final String orderID;
  final double amount;
  final bool useQRCode;

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  late PaymentCubit _paymentCubit;

  @override
  void initState() {
    super.initState();

    _paymentCubit = context.read<PaymentCubit>();
    if (widget.useQRCode) {
      _paymentCubit.generateQrCode(
        orderID: widget.orderID,
        amount: widget.amount,
      );
    } else {
      _paymentCubit.deposit(
        orderID: widget.orderID,
        amount: widget.amount,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is PaymentDepositState && state.errorMessage != null) {
                _showError(state.errorMessage!);
              } else if (state is PaymentQrState &&
                  state.errorMessage != null) {
                _showError(state.errorMessage!);
              }
            },
            builder: (context, state) {
              if (state is PaymentDepositState) {
                return _buildMainWidget(
                  status: state.status,
                  transactionID: state.transactionID ?? '',
                );
              }

              if (state is PaymentQrState) {
                return _buildMainWidget(
                  qrImage: state.qrImage,
                  status: state.status,
                  transactionID: state.transactionID ?? '',
                );
              }

              return const Center(
                child: Text('No Data'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainWidget({
    Image? qrImage,
    required TChainPaymentStatus status,
    String transactionID = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        if (qrImage != null) ...[
          Flexible(
            child: Image(
              image: qrImage.image,
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(height: 16),
        ],
        const Text('status'),
        Text(
          status.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text('txn'),
        InkWell(
          onTap: () =>
              launchUrlString('https://testnet.bscscan.com/tx/$transactionID'),
          child: Text(
            transactionID,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  _showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}