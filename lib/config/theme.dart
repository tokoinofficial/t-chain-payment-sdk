import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const kSemiBold = FontWeight.w600;
const kMedium = FontWeight.w500;

extension ThemeExt on ThemeData {
  Widget getPicture(
    String name, {
    Key? key,
    String? darkName,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    final useDarkMode = darkName != null && brightness == Brightness.dark;
    final path = useDarkMode ? darkName : name;

    if (path.endsWith('svg')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        package: 't_chain_payment_sdk',
        key: key,
        color: color,
        fit: fit,
      );
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      package: 't_chain_payment_sdk',
      key: key,
      color: color,
      fit: fit,
    );
  }
}

class ThemeColors {
  final Color primaryYellow,
      primaryBlue,
      primaryBlueLight,
      primaryBlueDark,
      infoLighter,
      infoLight,
      infoMain,
      infoDark,
      infoDarker,
      successLighter,
      successLight,
      successMain,
      successDark,
      successDarker,
      warningLighter,
      warningLight,
      warningMain,
      warningDark,
      warningDarker,
      errorLighter,
      errorLight,
      errorMain,
      errorDark,
      errorDarker,
      textPrimary,
      textSecondary,
      textTertiary,
      textQuarternary,
      textAccent,
      mainBgPrimary,
      mainBgSecondary,
      mainBgTertiary,
      fillBgBlack,
      fillBgPrimary,
      fillBgSecondary,
      fillBgTertiary,
      fillBgQuarternary,
      fillBgWhite,
      fillBgOverlay,
      separator,
      shadow;

  ThemeColors({
    this.primaryYellow = const Color(0xFFFFB600),
    this.primaryBlue = const Color(0xFF00A0F7),
    this.primaryBlueLight = const Color(0xFFA3DCE7),
    this.primaryBlueDark = const Color(0xFF107EA0),
    this.infoLighter = const Color(0xFFC1E5FF),
    this.infoLight = const Color(0xFF69BFFE),
    this.infoMain = const Color(0xFF20A1FF),
    this.infoDark = const Color(0xFF1A7EC8),
    this.infoDarker = const Color(0xFF0D446C),
    this.successLighter = const Color(0xFFD8F5C3),
    this.successLight = const Color(0xFF89DA6D),
    this.successMain = const Color(0xFF65D83C),
    this.successDark = const Color(0xFF4A9D2D),
    this.successDarker = const Color(0xFF336B1F),
    this.warningLighter = const Color(0xFFFCEDC7),
    this.warningLight = const Color(0xFFFFD568),
    this.warningMain = const Color(0xFFFFC225),
    this.warningDark = const Color(0xFFCC9D24),
    this.warningDarker = const Color(0xFF8A6A16),
    this.errorLighter = const Color(0xFFFFE5E5),
    this.errorLight = const Color(0xFFFF8484),
    this.errorMain = const Color(0xFFFF4242),
    this.errorDark = const Color(0xFFC92F2F),
    this.errorDarker = const Color(0xFF802222),
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textQuarternary,
    required this.textAccent,
    required this.mainBgPrimary,
    required this.mainBgSecondary,
    required this.mainBgTertiary,
    this.fillBgBlack = const Color(0xFF000000),
    required this.fillBgPrimary,
    required this.fillBgSecondary,
    required this.fillBgTertiary,
    required this.fillBgQuarternary,
    this.fillBgWhite = const Color(0xFFFFFFFF),
    required this.fillBgOverlay,
    required this.separator,
    required this.shadow,
  });

  Color get infoMain08 => infoMain.withOpacity(0.08);
  Color get infoMain24 => infoMain.withOpacity(0.24);
  Color get infoMain40 => infoMain.withOpacity(0.40);
  Color get infoMain56 => infoMain.withOpacity(0.56);
  Color get infoMain72 => infoMain.withOpacity(0.72);
  Color get infoMain88 => infoMain.withOpacity(0.88);

  Color get successMain08 => successMain.withOpacity(0.08);
  Color get successMain24 => successMain.withOpacity(0.24);
  Color get successMain40 => successMain.withOpacity(0.40);
  Color get successMain56 => successMain.withOpacity(0.56);
  Color get successMain72 => successMain.withOpacity(0.72);
  Color get successMain88 => successMain.withOpacity(0.88);

  Color get warningMain08 => warningMain.withOpacity(0.08);
  Color get warningMain24 => warningMain.withOpacity(0.24);
  Color get warningMain40 => warningMain.withOpacity(0.40);
  Color get warningMain56 => warningMain.withOpacity(0.56);
  Color get warningMain72 => warningMain.withOpacity(0.72);
  Color get warningMain88 => warningMain.withOpacity(0.88);

  Color get errorMain08 => errorMain.withOpacity(0.08);
  Color get errorMain24 => errorMain.withOpacity(0.24);
  Color get errorMain40 => errorMain.withOpacity(0.40);
  Color get errorMain56 => errorMain.withOpacity(0.56);
  Color get errorMain72 => errorMain.withOpacity(0.72);
  Color get errorMain88 => errorMain.withOpacity(0.88);

  Color grey10 = const Color(0xFFEEF1F3);
  Color grey80 = const Color(0xFF434D56);
}

final themeColors = ThemeColors(
  textPrimary: const Color(0xFF0C0F12),
  textSecondary: const Color(0xFF3C3C43).withOpacity(0.6),
  textTertiary: const Color(0xFF3C3C43).withOpacity(0.3),
  textQuarternary: const Color(0xFF3C3C43).withOpacity(0.18),
  textAccent: const Color(0xFFFFFFFF),
  mainBgPrimary: const Color(0xFFFFFFFF),
  mainBgSecondary: const Color(0xFFF2F2F7).withOpacity(0.8),
  mainBgTertiary: const Color(0xFFF2F2F7).withOpacity(0.45),
  fillBgPrimary: const Color(0xFF787880).withOpacity(0.2),
  fillBgSecondary: const Color(0xFF787880).withOpacity(0.16),
  fillBgTertiary: const Color(0xFF787880).withOpacity(0.12),
  fillBgQuarternary: const Color(0xFF787880).withOpacity(0.08),
  fillBgOverlay: const Color(0xFF000000).withOpacity(0.78),
  separator: const Color(0xFFF2F2F2),
  shadow: const Color(0xFF1C2731).withOpacity(0.05),
);
