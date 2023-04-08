import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/screens/merchant_input_screen.dart';
import 'package:t_chain_payment_sdk/screens/payment_deposit_screen.dart';
import 'package:t_chain_payment_sdk/screens/t_chain_router_const.dart';

final tChainNavigatorKey = GlobalKey<NavigatorState>();

class TChainRoot extends StatelessWidget {
  const TChainRoot({
    super.key,
    this.merchantInfo,
    this.qrCode,
    this.bundleId,
  });

  final MerchantInfo? merchantInfo;
  final String? qrCode;
  final String? bundleId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (tChainNavigatorKey.currentState != null) {
          tChainNavigatorKey.currentState!.maybePop();
          return false;
        }

        return true;
      },
      child: Navigator(
        key: tChainNavigatorKey,
        initialRoute: TChainRouterConst.kMerchantInput,
        onGenerateRoute: (RouteSettings settings) {
          Map arguments = settings.arguments as Map? ?? {};

          Widget screen;
          switch (settings.name) {
            case TChainRouterConst.kMerchantInput:
              screen = MerchantInputScreen(
                merchantInfo: merchantInfo,
                qrCode: qrCode,
                bundleId: bundleId,
              );
              break;

            case TChainRouterConst.kDeposit:
              screen = PaymentDepositScreen(
                merchantInfo: arguments[TChainRouterConst.kArgMerchantInfo],
                bundleId: arguments[TChainRouterConst.kArgBunderId],
              );
              break;
            default:
              return null;
          }

          return MaterialPageRoute<void>(
            builder: (BuildContext context) => screen,
          );
        },
      ),
    );
  }
}
