// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AssetCWProxy {
  Asset contractAddress(String contractAddress);

  Asset fullName(String fullName);

  Asset shortName(String shortName);

  Asset iconName(String iconName);

  Asset balance(num balance);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Asset(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Asset(...).copyWith(id: 12, name: "My name")
  /// ````
  Asset call({
    String? contractAddress,
    String? fullName,
    String? shortName,
    String? iconName,
    num? balance,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAsset.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAsset.copyWith.fieldName(...)`
class _$AssetCWProxyImpl implements _$AssetCWProxy {
  const _$AssetCWProxyImpl(this._value);

  final Asset _value;

  @override
  Asset contractAddress(String contractAddress) =>
      this(contractAddress: contractAddress);

  @override
  Asset fullName(String fullName) => this(fullName: fullName);

  @override
  Asset shortName(String shortName) => this(shortName: shortName);

  @override
  Asset iconName(String iconName) => this(iconName: iconName);

  @override
  Asset balance(num balance) => this(balance: balance);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Asset(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Asset(...).copyWith(id: 12, name: "My name")
  /// ````
  Asset call({
    Object? contractAddress = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? shortName = const $CopyWithPlaceholder(),
    Object? iconName = const $CopyWithPlaceholder(),
    Object? balance = const $CopyWithPlaceholder(),
  }) {
    return Asset(
      contractAddress: contractAddress == const $CopyWithPlaceholder() ||
              contractAddress == null
          ? _value.contractAddress
          // ignore: cast_nullable_to_non_nullable
          : contractAddress as String,
      fullName: fullName == const $CopyWithPlaceholder() || fullName == null
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      shortName: shortName == const $CopyWithPlaceholder() || shortName == null
          ? _value.shortName
          // ignore: cast_nullable_to_non_nullable
          : shortName as String,
      iconName: iconName == const $CopyWithPlaceholder() || iconName == null
          ? _value.iconName
          // ignore: cast_nullable_to_non_nullable
          : iconName as String,
      balance: balance == const $CopyWithPlaceholder() || balance == null
          ? _value.balance
          // ignore: cast_nullable_to_non_nullable
          : balance as num,
    );
  }
}

extension $AssetCopyWith on Asset {
  /// Returns a callable class that can be used as follows: `instanceOfAsset.copyWith(...)` or like so:`instanceOfAsset.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AssetCWProxy get copyWith => _$AssetCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      contractAddress: json['contractAddress'] as String,
      fullName: json['fullName'] as String,
      shortName: json['shortName'] as String,
      iconName: json['iconName'] as String,
      balance: json['balance'] as num? ?? 0.0,
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'contractAddress': instance.contractAddress,
      'shortName': instance.shortName,
      'fullName': instance.fullName,
      'iconName': instance.iconName,
      'balance': instance.balance,
    };
