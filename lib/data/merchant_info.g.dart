// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MerchantInfoCWProxy {
  MerchantInfo id(String? id);

  MerchantInfo merchantId(String merchantId);

  MerchantInfo fullname(String fullname);

  MerchantInfo amount(double? amount);

  MerchantInfo currency(String currency);

  MerchantInfo expiredTime(String? expiredTime);

  MerchantInfo qrCode(String qrCode);

  MerchantInfo status(int status);

  MerchantInfo notes(String? notes);

  MerchantInfo chainId(String chainId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MerchantInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MerchantInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  MerchantInfo call({
    String? id,
    String? merchantId,
    String? fullname,
    double? amount,
    String? currency,
    String? expiredTime,
    String? qrCode,
    int? status,
    String? notes,
    String? chainId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMerchantInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMerchantInfo.copyWith.fieldName(...)`
class _$MerchantInfoCWProxyImpl implements _$MerchantInfoCWProxy {
  const _$MerchantInfoCWProxyImpl(this._value);

  final MerchantInfo _value;

  @override
  MerchantInfo id(String? id) => this(id: id);

  @override
  MerchantInfo merchantId(String merchantId) => this(merchantId: merchantId);

  @override
  MerchantInfo fullname(String fullname) => this(fullname: fullname);

  @override
  MerchantInfo amount(double? amount) => this(amount: amount);

  @override
  MerchantInfo currency(String currency) => this(currency: currency);

  @override
  MerchantInfo expiredTime(String? expiredTime) =>
      this(expiredTime: expiredTime);

  @override
  MerchantInfo qrCode(String qrCode) => this(qrCode: qrCode);

  @override
  MerchantInfo status(int status) => this(status: status);

  @override
  MerchantInfo notes(String? notes) => this(notes: notes);

  @override
  MerchantInfo chainId(String chainId) => this(chainId: chainId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MerchantInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MerchantInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  MerchantInfo call({
    Object? id = const $CopyWithPlaceholder(),
    Object? merchantId = const $CopyWithPlaceholder(),
    Object? fullname = const $CopyWithPlaceholder(),
    Object? amount = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? expiredTime = const $CopyWithPlaceholder(),
    Object? qrCode = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? chainId = const $CopyWithPlaceholder(),
  }) {
    return MerchantInfo(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      merchantId:
          merchantId == const $CopyWithPlaceholder() || merchantId == null
              ? _value.merchantId
              // ignore: cast_nullable_to_non_nullable
              : merchantId as String,
      fullname: fullname == const $CopyWithPlaceholder() || fullname == null
          ? _value.fullname
          // ignore: cast_nullable_to_non_nullable
          : fullname as String,
      amount: amount == const $CopyWithPlaceholder()
          ? _value.amount
          // ignore: cast_nullable_to_non_nullable
          : amount as double?,
      currency: currency == const $CopyWithPlaceholder() || currency == null
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String,
      expiredTime: expiredTime == const $CopyWithPlaceholder()
          ? _value.expiredTime
          // ignore: cast_nullable_to_non_nullable
          : expiredTime as String?,
      qrCode: qrCode == const $CopyWithPlaceholder() || qrCode == null
          ? _value.qrCode
          // ignore: cast_nullable_to_non_nullable
          : qrCode as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as int,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String?,
      chainId: chainId == const $CopyWithPlaceholder() || chainId == null
          ? _value.chainId
          // ignore: cast_nullable_to_non_nullable
          : chainId as String,
    );
  }
}

extension $MerchantInfoCopyWith on MerchantInfo {
  /// Returns a callable class that can be used as follows: `instanceOfMerchantInfo.copyWith(...)` or like so:`instanceOfMerchantInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MerchantInfoCWProxy get copyWith => _$MerchantInfoCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `MerchantInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MerchantInfo(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  MerchantInfo copyWithNull({
    bool id = false,
    bool amount = false,
    bool expiredTime = false,
    bool notes = false,
  }) {
    return MerchantInfo(
      id: id == true ? null : this.id,
      merchantId: merchantId,
      fullname: fullname,
      amount: amount == true ? null : this.amount,
      currency: currency,
      expiredTime: expiredTime == true ? null : this.expiredTime,
      qrCode: qrCode,
      status: status,
      notes: notes == true ? null : this.notes,
      chainId: chainId,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantInfo _$MerchantInfoFromJson(Map<String, dynamic> json) => MerchantInfo(
      id: json['id'] as String?,
      merchantId: json['merchant_id'] as String,
      fullname: json['fullname'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      expiredTime: json['expired_time'] as String?,
      qrCode: json['qr_code'] as String,
      status: json['status'] as int,
      notes: json['notes'] as String?,
      chainId: json['chain_id'] as String? ?? '$kTestnetChainID',
    );

Map<String, dynamic> _$MerchantInfoToJson(MerchantInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchant_id': instance.merchantId,
      'fullname': instance.fullname,
      'amount': instance.amount,
      'currency': instance.currency,
      'expired_time': instance.expiredTime,
      'qr_code': instance.qrCode,
      'status': instance.status,
      'notes': instance.notes,
      'chain_id': instance.chainId,
    };
