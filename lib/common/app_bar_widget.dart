import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/text_styles.dart';
import 'package:t_chain_payment_sdk/config/theme.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String title;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? tintColor;
  final Widget? leading;

  @override
  final Size preferredSize;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.shadowColor,
    this.tintColor,
    this.leading,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? themeColors.mainBgPrimary,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '$title${TChainPaymentSDK.shared.sandboxTitle}',
        style: TextStyles.headline.copyWith(
          color: tintColor ?? themeColors.textPrimary,
        ),
      ),
      iconTheme: IconThemeData(
        color: tintColor ?? themeColors.textSecondary,
      ),
      actions: actions,
      automaticallyImplyLeading: showBackButton,
      shadowColor: shadowColor,
      leading: leading,
    );
  }
}
