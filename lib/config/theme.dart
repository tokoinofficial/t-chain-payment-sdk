import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const kSemiBold = FontWeight.w600;
const kMedium = FontWeight.w500;

final oldThemeColors = ColoursV2(
  primary1: const Color(0xFF7697E0),
  primary2: const Color(0xFF4F70C2),
  primary: const Color(0xFF21409A),
  primary4: const Color(0xFF10236E),
  primary5: const Color(0xFF061049),
  bg: const Color(0xFFFFFFFF),
  bg1: const Color(0xFFFAFAFA),
  bg2: const Color(0xFFF5F5F5),
  bg3: const Color(0xFFEEEEEE),
  bg4: const Color(0xFFE0E0E0),
  bg5: const Color(0xFFBDBDBD),
  bg6: const Color(0xFF9E9E9E),
  bg7: const Color(0xFF757575),
  bg8: const Color(0xFF616161),
  bg9: const Color(0xFF424242),
  bg10: const Color(0xFF212121),
  text1: const Color(0xFFFFFFFF),
  text2: const Color(0xFFFAFAFA),
  text3: const Color(0xFFF5F5F5),
  text4: const Color(0xFFEEEEEE),
  text5: const Color(0xFFE0E0E0),
  text6: const Color(0xFFBDBDBD),
  text7: const Color(0xFF9E9E9E),
  text8: const Color(0xFF757575),
  text9: const Color(0xFF616161),
  text10: const Color(0xFF424242),
  text11: const Color(0xFF212121),
  statusError1: const Color(0xFFFCE2D5),
  statusError2: const Color(0xFFDC675C),
  statusError: const Color(0xFFC52D2D),
  statusError4: const Color(0xFF8D162B),
  statusError5: const Color(0xFF720E28),
  statusWarning1: const Color(0xFFFFF5D9),
  statusWarning2: const Color(0xFFFFD88D),
  statusWarning: const Color(0xFFFFAE42),
  statusWarning4: const Color(0xFFB76A21),
  statusWarning5: const Color(0xFF7A380C),
  statusSuccess1: const Color(0xFFD9FBD1),
  statusSuccess2: const Color(0xFF73E973),
  statusSuccess: const Color(0xFF1DB83A),
  statusSuccess4: const Color(0xFF0E843A),
  statusSuccess5: const Color(0xFF055834),
  statusDone: const Color(0xFF9F9F9F),
  stakingPlan1: const Color(0xFF9F60B7),
  stakingPlan2: const Color(0xFF00BBEA),
  statkingPlan3: const Color(0xFFF5616D),
  bissPlan: const Color(0xFF53AE94),
  link: const Color(0xFF0D67FE),
);

class ColoursV2 {
  final Color primary1,
      primary2,
      primary,
      primary4,
      primary5,
      bg,
      bg1,
      bg2,
      bg3,
      bg4,
      bg5,
      bg6,
      bg7,
      bg8,
      bg9,
      bg10,
      text1,
      text2,
      text3,
      text4,
      text5,
      text6,
      text7,
      text8,
      text9,
      text10,
      text11,
      statusError1,
      statusError2,
      statusError,
      statusError4,
      statusError5,
      statusWarning1,
      statusWarning2,
      statusWarning,
      statusWarning4,
      statusWarning5,
      statusSuccess1,
      statusSuccess2,
      statusSuccess,
      statusSuccess4,
      statusSuccess5,
      statusDone,
      stakingPlan1,
      stakingPlan2,
      statkingPlan3,
      bissPlan,
      link;

  ColoursV2({
    required this.primary1,
    required this.primary2,
    required this.primary,
    required this.primary4,
    required this.primary5,
    required this.bg,
    required this.bg1,
    required this.bg2,
    required this.bg3,
    required this.bg4,
    required this.bg5,
    required this.bg6,
    required this.bg7,
    required this.bg8,
    required this.bg9,
    required this.bg10,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.text6,
    required this.text7,
    required this.text8,
    required this.text9,
    required this.text10,
    required this.text11,
    required this.statusError1,
    required this.statusError2,
    required this.statusError,
    required this.statusError4,
    required this.statusError5,
    required this.statusWarning1,
    required this.statusWarning2,
    required this.statusWarning,
    required this.statusWarning4,
    required this.statusWarning5,
    required this.statusSuccess1,
    required this.statusSuccess2,
    required this.statusSuccess,
    required this.statusSuccess4,
    required this.statusSuccess5,
    required this.statusDone,
    required this.stakingPlan1,
    required this.stakingPlan2,
    required this.statkingPlan3,
    required this.bissPlan,
    required this.link,
  });
}

final themeTextStyles = TextStylesV1(
  title1: const TextStyle(fontWeight: kSemiBold, fontSize: 34),
  title2: const TextStyle(fontWeight: kSemiBold, fontSize: 24),
  title3: const TextStyle(fontWeight: kSemiBold, fontSize: 22),
  title4: const TextStyle(fontWeight: kSemiBold, fontSize: 20),
  title5: const TextStyle(fontWeight: kSemiBold, fontSize: 18),
  subTitle1: const TextStyle(fontWeight: kMedium, fontSize: 16),
  subTitle2: const TextStyle(fontWeight: kMedium, fontSize: 14),
  subTitle3: const TextStyle(fontWeight: kMedium, fontSize: 12, height: 1.5),
  body1: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
  body2: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
  body3: const TextStyle(fontWeight: kMedium, fontSize: 12),
  body4: const TextStyle(fontWeight: FontWeight.normal, fontSize: 9),
  body5: const TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
  body6: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  button1: const TextStyle(fontWeight: kSemiBold, fontSize: 16),
  button2: const TextStyle(fontWeight: kSemiBold, fontSize: 14),
  button3: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
  button4: const TextStyle(fontWeight: kSemiBold, fontSize: 11),
);

class TextStylesV1 {
  final TextStyle title1,
      title2,
      title3,
      title4,
      title5,
      subTitle1,
      subTitle2,
      subTitle3,
      body1,
      body2,
      body3,
      body4,
      body5,
      body6,
      button1,
      button2,
      button3,
      button4;

  TextStylesV1({
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.title5,
    required this.subTitle1,
    required this.subTitle2,
    required this.subTitle3,
    required this.body1,
    required this.body2,
    required this.body3,
    required this.body4,
    required this.body5,
    required this.body6,
    required this.button1,
    required this.button2,
    required this.button3,
    required this.button4,
  });
}

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
    String path = (useDarkMode ? darkName : name) ?? name;

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
