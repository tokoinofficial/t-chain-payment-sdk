// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pancake_swap.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PancakeSwapCWProxy {
  PancakeSwap assetIn(Asset assetIn);

  PancakeSwap assetOut(Asset assetOut);

  PancakeSwap amountOut(num? amountOut);

  PancakeSwap amountIn(num? amountIn);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PancakeSwap(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PancakeSwap(...).copyWith(id: 12, name: "My name")
  /// ````
  PancakeSwap call({
    Asset? assetIn,
    Asset? assetOut,
    num? amountOut,
    num? amountIn,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPancakeSwap.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPancakeSwap.copyWith.fieldName(...)`
class _$PancakeSwapCWProxyImpl implements _$PancakeSwapCWProxy {
  const _$PancakeSwapCWProxyImpl(this._value);

  final PancakeSwap _value;

  @override
  PancakeSwap assetIn(Asset assetIn) => this(assetIn: assetIn);

  @override
  PancakeSwap assetOut(Asset assetOut) => this(assetOut: assetOut);

  @override
  PancakeSwap amountOut(num? amountOut) => this(amountOut: amountOut);

  @override
  PancakeSwap amountIn(num? amountIn) => this(amountIn: amountIn);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PancakeSwap(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PancakeSwap(...).copyWith(id: 12, name: "My name")
  /// ````
  PancakeSwap call({
    Object? assetIn = const $CopyWithPlaceholder(),
    Object? assetOut = const $CopyWithPlaceholder(),
    Object? amountOut = const $CopyWithPlaceholder(),
    Object? amountIn = const $CopyWithPlaceholder(),
  }) {
    return PancakeSwap(
      assetIn: assetIn == const $CopyWithPlaceholder() || assetIn == null
          ? _value.assetIn
          // ignore: cast_nullable_to_non_nullable
          : assetIn as Asset,
      assetOut: assetOut == const $CopyWithPlaceholder() || assetOut == null
          ? _value.assetOut
          // ignore: cast_nullable_to_non_nullable
          : assetOut as Asset,
      amountOut: amountOut == const $CopyWithPlaceholder()
          ? _value.amountOut
          // ignore: cast_nullable_to_non_nullable
          : amountOut as num?,
      amountIn: amountIn == const $CopyWithPlaceholder()
          ? _value.amountIn
          // ignore: cast_nullable_to_non_nullable
          : amountIn as num?,
    );
  }
}

extension $PancakeSwapCopyWith on PancakeSwap {
  /// Returns a callable class that can be used as follows: `instanceOfPancakeSwap.copyWith(...)` or like so:`instanceOfPancakeSwap.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PancakeSwapCWProxy get copyWith => _$PancakeSwapCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `PancakeSwap(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PancakeSwap(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  PancakeSwap copyWithNull({
    bool amountOut = false,
    bool amountIn = false,
  }) {
    return PancakeSwap(
      assetIn: assetIn,
      assetOut: assetOut,
      amountOut: amountOut == true ? null : this.amountOut,
      amountIn: amountIn == true ? null : this.amountIn,
    );
  }
}
