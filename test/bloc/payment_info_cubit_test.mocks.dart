// Mocks generated by Mockito 5.4.0 from annotations
// in t_chain_payment_sdk/test/bloc/payment_info_cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:t_chain_payment_sdk/data/merchant_transaction.dart' as _i8;
import 'package:t_chain_payment_sdk/data/response/data_response.dart' as _i7;
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart' as _i5;
import 'package:t_chain_payment_sdk/repo/payment_repo.dart' as _i3;
import 'package:t_chain_payment_sdk/services/t_chain_api.dart' as _i2;
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTChainAPI_0 extends _i1.SmartFake implements _i2.TChainAPI {
  _FakeTChainAPI_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PaymentRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPaymentRepository extends _i1.Mock implements _i3.PaymentRepository {
  @override
  _i2.TChainAPI get api => (super.noSuchMethod(
        Invocation.getter(#api),
        returnValue: _FakeTChainAPI_0(
          this,
          Invocation.getter(#api),
        ),
        returnValueForMissingStub: _FakeTChainAPI_0(
          this,
          Invocation.getter(#api),
        ),
      ) as _i2.TChainAPI);
  @override
  _i4.Future<Uri?> generateDeeplink({
    required _i5.TChainPaymentAction? action,
    required String? walletScheme,
    required String? notes,
    required double? amount,
    required _i6.Currency? currency,
    required String? chainId,
    String? bundleID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #generateDeeplink,
          [],
          {
            #action: action,
            #walletScheme: walletScheme,
            #notes: notes,
            #amount: amount,
            #currency: currency,
            #chainId: chainId,
            #bundleID: bundleID,
          },
        ),
        returnValue: _i4.Future<Uri?>.value(),
        returnValueForMissingStub: _i4.Future<Uri?>.value(),
      ) as _i4.Future<Uri?>);
  @override
  _i4.Future<_i7.DataResponse<_i6.MerchantInfo>?> getMerchantInfo(
          {required String? qrCode}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMerchantInfo,
          [],
          {#qrCode: qrCode},
        ),
        returnValue: _i4.Future<_i7.DataResponse<_i6.MerchantInfo>?>.value(),
        returnValueForMissingStub:
            _i4.Future<_i7.DataResponse<_i6.MerchantInfo>?>.value(),
      ) as _i4.Future<_i7.DataResponse<_i6.MerchantInfo>?>);
  @override
  _i4.Future<_i7.DataResponse<Map<String, dynamic>>?> getExchangeRate() =>
      (super.noSuchMethod(
        Invocation.method(
          #getExchangeRate,
          [],
        ),
        returnValue:
            _i4.Future<_i7.DataResponse<Map<String, dynamic>>?>.value(),
        returnValueForMissingStub:
            _i4.Future<_i7.DataResponse<Map<String, dynamic>>?>.value(),
      ) as _i4.Future<_i7.DataResponse<Map<String, dynamic>>?>);
  @override
  _i4.Future<_i8.MerchantTransaction?> createMerchantTransaction({
    required String? address,
    required double? amount,
    required _i6.Currency? currency,
    required String? notes,
    required String? tokenName,
    required String? externalMerchantId,
    required String? chainId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createMerchantTransaction,
          [],
          {
            #address: address,
            #amount: amount,
            #currency: currency,
            #notes: notes,
            #tokenName: tokenName,
            #externalMerchantId: externalMerchantId,
            #chainId: chainId,
          },
        ),
        returnValue: _i4.Future<_i8.MerchantTransaction?>.value(),
        returnValueForMissingStub: _i4.Future<_i8.MerchantTransaction?>.value(),
      ) as _i4.Future<_i8.MerchantTransaction?>);
}
