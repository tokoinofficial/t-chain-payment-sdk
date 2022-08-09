import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tk_payment_gateway/tk_payment_gateway.dart';

class TWPaymentButton extends StatelessWidget {
  final Widget? child;
  final TWPaymentAction action;
  final double amount;
  final bool isDarkMode;
  final Function(TWPaymentResult)? onResult;

  const TWPaymentButton({
    Key? key,
    this.child,
    required this.action,
    this.amount = 0,
    this.isDarkMode = true,
    this.onResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: _onPressed, child: child ?? _defaultButton());
  }

  _defaultButton() =>
      SvgPicture.asset('assets/${action.icon}${isDarkMode ? '_dark' : ''}.svg',
          package: 'tk_payment_gateway');

  _onPressed() async {
    switch (action) {
      case TWPaymentAction.deposit:
        final result = await TWPaymentSDK.instance.purchase(
          orderID: '',
          amount: amount,
        );
        onResult?.call(result);
        break;
      case TWPaymentAction.withdraw:
        final result = await TWPaymentSDK.instance.withdraw(
          orderID: '',
          amount: amount,
        );
        onResult?.call(result);
        break;
    }
  }
}
