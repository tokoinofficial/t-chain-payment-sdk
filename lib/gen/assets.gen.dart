/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal

import 'package:flutter/widgets.dart';

class Assets {
  Assets._();

  static const String balanceWarning = 'assets/balance_warning.svg';
  static const String checkboxOff = 'assets/checkbox_off.svg';
  static const String checkboxOn = 'assets/checkbox_on.svg';
  static const String chevronDown = 'assets/chevron_down.svg';
  static const String currencyIdr = 'assets/currency_idr.svg';
  static const String currencyUsd = 'assets/currency_usd.svg';
  static const String currencyVnd = 'assets/currency_vnd.svg';
  static const String merchant = 'assets/merchant.svg';
  static const String paymentAmount = 'assets/payment_amount.svg';
  static const String paymentAmountDark = 'assets/payment_amount_dark.svg';
  static const String paymentCompleted = 'assets/payment_completed.svg';
  static const String paymentCompletedDark =
      'assets/payment_completed_dark.svg';
  static const String paymentFailed = 'assets/payment_failed.svg';
  static const String paymentFailedDark = 'assets/payment_failed_dark.svg';
  static const String paymentNotes = 'assets/payment_notes.svg';
  static const String paymentNotesDark = 'assets/payment_notes_dark.svg';
  static const String paymentProceeding = 'assets/payment_proceeding.svg';
  static const String paymentProceedingDark =
      'assets/payment_proceeding_dark.svg';
  static const AssetGenImage paymentServiceFee =
      AssetGenImage('assets/payment_service_fee.png');
  static const String paymentStore = 'assets/payment_store.svg';
  static const String paymentStoreDark = 'assets/payment_store_dark.svg';
  static const String refreshCircle = 'assets/refresh_circle.svg';
  static const String tokenBnb = 'assets/token_bnb.svg';
  static const String tokenBusd = 'assets/token_busd.svg';
  static const String tokenEth = 'assets/token_eth.svg';
  static const String tokenToko = 'assets/token_toko.svg';
  static const String tokenUsdt = 'assets/token_usdt.svg';

  /// List of all assets
  List<dynamic> get values => [
        balanceWarning,
        checkboxOff,
        checkboxOn,
        chevronDown,
        currencyIdr,
        currencyUsd,
        currencyVnd,
        merchant,
        paymentAmount,
        paymentAmountDark,
        paymentCompleted,
        paymentCompletedDark,
        paymentFailed,
        paymentFailedDark,
        paymentNotes,
        paymentNotesDark,
        paymentProceeding,
        paymentProceedingDark,
        paymentServiceFee,
        paymentStore,
        paymentStoreDark,
        refreshCircle,
        tokenBnb,
        tokenBusd,
        tokenEth,
        tokenToko,
        tokenUsdt
      ];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
