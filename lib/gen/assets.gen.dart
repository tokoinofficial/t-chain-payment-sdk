/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal

import 'package:flutter/widgets.dart';

class $LibGen {
  const $LibGen();

  $LibSmcGen get smc => const $LibSmcGen();
}

class $LibSmcGen {
  const $LibSmcGen();

  $LibSmcAbisGen get abis => const $LibSmcAbisGen();
}

class $LibSmcAbisGen {
  const $LibSmcAbisGen();

  /// File path: lib/smc/abis/bep20.abi.json
  String get bep20Abi => 'lib/smc/abis/bep20.abi.json';

  /// File path: lib/smc/abis/payment.abi.json
  String get paymentAbi => 'lib/smc/abis/payment.abi.json';

  /// File path: lib/smc/abis/swap.abi.json
  String get swapAbi => 'lib/smc/abis/swap.abi.json';

  /// List of all assets
  List<String> get values => [bep20Abi, paymentAbi, swapAbi];
}

class Assets {
  Assets._();

  static const String amount = 'assets/amount.svg';
  static const String balanceWarning = 'assets/balance_warning.svg';
  static const String checkboxOff = 'assets/checkbox_off.svg';
  static const String checkboxOn = 'assets/checkbox_on.svg';
  static const String chevronDown = 'assets/chevron_down.svg';
  static const String currencyIdr = 'assets/currency_idr.svg';
  static const String currencyUsd = 'assets/currency_usd.svg';
  static const String currencyVnd = 'assets/currency_vnd.svg';
  static const String merchant = 'assets/merchant.svg';
  static const String notes = 'assets/notes.svg';
  static const String paymentCompleted = 'assets/payment_completed.svg';
  static const String paymentFailed = 'assets/payment_failed.svg';
  static const String paymentProceeding = 'assets/payment_proceeding.svg';
  static const String refreshCircle = 'assets/refresh_circle.svg';
  static const String tokenBnb = 'assets/token_bnb.svg';
  static const String tokenBusd = 'assets/token_busd.svg';
  static const String tokenToko = 'assets/token_toko.svg';
  static const String tokenUsdt = 'assets/token_usdt.svg';
  static const $LibGen lib = $LibGen();

  /// List of all assets
  List<String> get values => [
        amount,
        balanceWarning,
        checkboxOff,
        checkboxOn,
        chevronDown,
        currencyIdr,
        currencyUsd,
        currencyVnd,
        merchant,
        notes,
        paymentCompleted,
        paymentFailed,
        paymentProceeding,
        refreshCircle,
        tokenBnb,
        tokenBusd,
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
