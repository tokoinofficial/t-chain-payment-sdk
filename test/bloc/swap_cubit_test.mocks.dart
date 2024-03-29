// Mocks generated by Mockito 5.4.0 from annotations
// in t_chain_payment_sdk/test/bloc/swap_cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:mockito/mockito.dart' as _i1;
import 'package:t_chain_payment_sdk/data/asset.dart' as _i10;
import 'package:t_chain_payment_sdk/data/gas_fee.dart' as _i11;
import 'package:t_chain_payment_sdk/data/pancake_swap.dart' as _i13;
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart' as _i12;
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart' as _i8;
import 'package:t_chain_payment_sdk/services/blockchain_service.dart' as _i3;
import 'package:t_chain_payment_sdk/services/gas_station_api.dart' as _i2;
import 'package:t_chain_payment_sdk/smc/bep_20_smc.dart' as _i4;
import 'package:t_chain_payment_sdk/smc/pancake_swap_smc.dart' as _i6;
import 'package:t_chain_payment_sdk/smc/payment_smc.dart' as _i5;
import 'package:web3dart/web3dart.dart' as _i7;

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

class _FakeGasStationAPI_0 extends _i1.SmartFake implements _i2.GasStationAPI {
  _FakeGasStationAPI_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBlockchainService_1 extends _i1.SmartFake
    implements _i3.BlockchainService {
  _FakeBlockchainService_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBep20Smc_2 extends _i1.SmartFake implements _i4.Bep20Smc {
  _FakeBep20Smc_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePaymentSmc_3 extends _i1.SmartFake implements _i5.PaymentSmc {
  _FakePaymentSmc_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePancakeSwapSmc_4 extends _i1.SmartFake
    implements _i6.PancakeSwapSmc {
  _FakePancakeSwapSmc_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTransaction_5 extends _i1.SmartFake implements _i7.Transaction {
  _FakeTransaction_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBigInt_6 extends _i1.SmartFake implements BigInt {
  _FakeBigInt_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WalletRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletRepository extends _i1.Mock implements _i8.WalletRepository {
  @override
  _i2.GasStationAPI get gasStationAPI => (super.noSuchMethod(
        Invocation.getter(#gasStationAPI),
        returnValue: _FakeGasStationAPI_0(
          this,
          Invocation.getter(#gasStationAPI),
        ),
        returnValueForMissingStub: _FakeGasStationAPI_0(
          this,
          Invocation.getter(#gasStationAPI),
        ),
      ) as _i2.GasStationAPI);
  @override
  _i3.BlockchainService get blockchainService => (super.noSuchMethod(
        Invocation.getter(#blockchainService),
        returnValue: _FakeBlockchainService_1(
          this,
          Invocation.getter(#blockchainService),
        ),
        returnValueForMissingStub: _FakeBlockchainService_1(
          this,
          Invocation.getter(#blockchainService),
        ),
      ) as _i3.BlockchainService);
  @override
  bool get isReady => (super.noSuchMethod(
        Invocation.getter(#isReady),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i9.Future<bool> setup() => (super.noSuchMethod(
        Invocation.method(
          #setup,
          [],
        ),
        returnValue: _i9.Future<bool>.value(false),
        returnValueForMissingStub: _i9.Future<bool>.value(false),
      ) as _i9.Future<bool>);
  @override
  _i9.Future<_i4.Bep20Smc> getBep20Smc(String? addressHex) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBep20Smc,
          [addressHex],
        ),
        returnValue: _i9.Future<_i4.Bep20Smc>.value(_FakeBep20Smc_2(
          this,
          Invocation.method(
            #getBep20Smc,
            [addressHex],
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i4.Bep20Smc>.value(_FakeBep20Smc_2(
          this,
          Invocation.method(
            #getBep20Smc,
            [addressHex],
          ),
        )),
      ) as _i9.Future<_i4.Bep20Smc>);
  @override
  _i9.Future<_i5.PaymentSmc> getPaymentSmc() => (super.noSuchMethod(
        Invocation.method(
          #getPaymentSmc,
          [],
        ),
        returnValue: _i9.Future<_i5.PaymentSmc>.value(_FakePaymentSmc_3(
          this,
          Invocation.method(
            #getPaymentSmc,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i5.PaymentSmc>.value(_FakePaymentSmc_3(
          this,
          Invocation.method(
            #getPaymentSmc,
            [],
          ),
        )),
      ) as _i9.Future<_i5.PaymentSmc>);
  @override
  _i9.Future<_i6.PancakeSwapSmc> getPancakeSwapSmc() => (super.noSuchMethod(
        Invocation.method(
          #getPancakeSwapSmc,
          [],
        ),
        returnValue: _i9.Future<_i6.PancakeSwapSmc>.value(_FakePancakeSwapSmc_4(
          this,
          Invocation.method(
            #getPancakeSwapSmc,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i6.PancakeSwapSmc>.value(_FakePancakeSwapSmc_4(
          this,
          Invocation.method(
            #getPancakeSwapSmc,
            [],
          ),
        )),
      ) as _i9.Future<_i6.PancakeSwapSmc>);
  @override
  _i9.Future<num> balanceOf({
    required String? smcAddressHex,
    required _i7.EthPrivateKey? privateKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #balanceOf,
          [],
          {
            #smcAddressHex: smcAddressHex,
            #privateKey: privateKey,
          },
        ),
        returnValue: _i9.Future<num>.value(0),
        returnValueForMissingStub: _i9.Future<num>.value(0),
      ) as _i9.Future<num>);
  @override
  _i9.Future<num> allowance({
    required _i10.Asset? asset,
    required _i7.EthPrivateKey? privateKey,
    required String? contractAddress,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #allowance,
          [],
          {
            #asset: asset,
            #privateKey: privateKey,
            #contractAddress: contractAddress,
          },
        ),
        returnValue: _i9.Future<num>.value(0),
        returnValueForMissingStub: _i9.Future<num>.value(0),
      ) as _i9.Future<num>);
  @override
  _i9.Future<_i7.TransactionReceipt?> getTransactionReceipt(
    _i10.Asset? asset,
    String? txHash,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransactionReceipt,
          [
            asset,
            txHash,
          ],
        ),
        returnValue: _i9.Future<_i7.TransactionReceipt?>.value(),
        returnValueForMissingStub: _i9.Future<_i7.TransactionReceipt?>.value(),
      ) as _i9.Future<_i7.TransactionReceipt?>);
  @override
  _i9.Future<_i7.TransactionInformation?> getTransactionByHash(
    _i10.Asset? asset,
    String? txHash,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransactionByHash,
          [
            asset,
            txHash,
          ],
        ),
        returnValue: _i9.Future<_i7.TransactionInformation?>.value(),
        returnValueForMissingStub:
            _i9.Future<_i7.TransactionInformation?>.value(),
      ) as _i9.Future<_i7.TransactionInformation?>);
  @override
  _i9.Future<_i7.Transaction> buildApproveTransaction({
    required _i7.EthPrivateKey? privateKey,
    required _i10.Asset? asset,
    required String? contractAddress,
    required BigInt? amount,
    num? gasPrice = 0,
    int? nonce,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #buildApproveTransaction,
          [],
          {
            #privateKey: privateKey,
            #asset: asset,
            #contractAddress: contractAddress,
            #amount: amount,
            #gasPrice: gasPrice,
            #nonce: nonce,
          },
        ),
        returnValue: _i9.Future<_i7.Transaction>.value(_FakeTransaction_5(
          this,
          Invocation.method(
            #buildApproveTransaction,
            [],
            {
              #privateKey: privateKey,
              #asset: asset,
              #contractAddress: contractAddress,
              #amount: amount,
              #gasPrice: gasPrice,
              #nonce: nonce,
            },
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i7.Transaction>.value(_FakeTransaction_5(
          this,
          Invocation.method(
            #buildApproveTransaction,
            [],
            {
              #privateKey: privateKey,
              #asset: asset,
              #contractAddress: contractAddress,
              #amount: amount,
              #gasPrice: gasPrice,
              #nonce: nonce,
            },
          ),
        )),
      ) as _i9.Future<_i7.Transaction>);
  @override
  _i9.Future<String> sendApproval({
    required _i7.EthPrivateKey? privateKey,
    required _i10.Asset? asset,
    required String? contractAddress,
    num? gasPrice = 0,
    int? nonce,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendApproval,
          [],
          {
            #privateKey: privateKey,
            #asset: asset,
            #contractAddress: contractAddress,
            #gasPrice: gasPrice,
            #nonce: nonce,
          },
        ),
        returnValue: _i9.Future<String>.value(''),
        returnValueForMissingStub: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  _i9.Future<bool> isEnoughBnb({
    required _i7.EthPrivateKey? privateKey,
    required _i10.Asset? asset,
    required num? amount,
    required num? gasPrice,
    required num? estimatedGas,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #isEnoughBnb,
          [],
          {
            #privateKey: privateKey,
            #asset: asset,
            #amount: amount,
            #gasPrice: gasPrice,
            #estimatedGas: estimatedGas,
          },
        ),
        returnValue: _i9.Future<bool>.value(false),
        returnValueForMissingStub: _i9.Future<bool>.value(false),
      ) as _i9.Future<bool>);
  @override
  _i9.Future<List<_i11.GasFee>> getBSCGasFees() => (super.noSuchMethod(
        Invocation.method(
          #getBSCGasFees,
          [],
        ),
        returnValue: _i9.Future<List<_i11.GasFee>>.value(<_i11.GasFee>[]),
        returnValueForMissingStub:
            _i9.Future<List<_i11.GasFee>>.value(<_i11.GasFee>[]),
      ) as _i9.Future<List<_i11.GasFee>>);
  @override
  _i9.Future<dynamic> setupPaymentContract() => (super.noSuchMethod(
        Invocation.method(
          #setupPaymentContract,
          [],
        ),
        returnValue: _i9.Future<dynamic>.value(),
        returnValueForMissingStub: _i9.Future<dynamic>.value(),
      ) as _i9.Future<dynamic>);
  @override
  _i9.Future<_i7.Transaction> buildDepositTransaction({
    required _i7.EthPrivateKey? privateKey,
    required List<dynamic>? parameters,
    required num? gasPrice,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #buildDepositTransaction,
          [],
          {
            #privateKey: privateKey,
            #parameters: parameters,
            #gasPrice: gasPrice,
          },
        ),
        returnValue: _i9.Future<_i7.Transaction>.value(_FakeTransaction_5(
          this,
          Invocation.method(
            #buildDepositTransaction,
            [],
            {
              #privateKey: privateKey,
              #parameters: parameters,
              #gasPrice: gasPrice,
            },
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i7.Transaction>.value(_FakeTransaction_5(
          this,
          Invocation.method(
            #buildDepositTransaction,
            [],
            {
              #privateKey: privateKey,
              #parameters: parameters,
              #gasPrice: gasPrice,
            },
          ),
        )),
      ) as _i9.Future<_i7.Transaction>);
  @override
  _i9.Future<num> getPaymentDepositFee() => (super.noSuchMethod(
        Invocation.method(
          #getPaymentDepositFee,
          [],
        ),
        returnValue: _i9.Future<num>.value(0),
        returnValueForMissingStub: _i9.Future<num>.value(0),
      ) as _i9.Future<num>);
  @override
  _i9.Future<_i12.PaymentDiscountInfo?> getPaymentDiscountFee({
    required String? contractAddress,
    required num? amount,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPaymentDiscountFee,
          [],
          {
            #contractAddress: contractAddress,
            #amount: amount,
          },
        ),
        returnValue: _i9.Future<_i12.PaymentDiscountInfo?>.value(),
        returnValueForMissingStub:
            _i9.Future<_i12.PaymentDiscountInfo?>.value(),
      ) as _i9.Future<_i12.PaymentDiscountInfo?>);
  @override
  _i9.Future<BigInt> debugPaymentDepositFee({
    required _i10.Asset? asset,
    required num? amount,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #debugPaymentDepositFee,
          [],
          {
            #asset: asset,
            #amount: amount,
          },
        ),
        returnValue: _i9.Future<BigInt>.value(_FakeBigInt_6(
          this,
          Invocation.method(
            #debugPaymentDepositFee,
            [],
            {
              #asset: asset,
              #amount: amount,
            },
          ),
        )),
        returnValueForMissingStub: _i9.Future<BigInt>.value(_FakeBigInt_6(
          this,
          Invocation.method(
            #debugPaymentDepositFee,
            [],
            {
              #asset: asset,
              #amount: amount,
            },
          ),
        )),
      ) as _i9.Future<BigInt>);
  @override
  _i9.Future<String> sendPaymentTransaction({
    required _i7.EthPrivateKey? privateKey,
    required _i7.Transaction? tx,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendPaymentTransaction,
          [],
          {
            #privateKey: privateKey,
            #tx: tx,
          },
        ),
        returnValue: _i9.Future<String>.value(''),
        returnValueForMissingStub: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  _i9.Future<num> estimateGas({
    required _i7.EthereumAddress? address,
    required _i7.Transaction? transaction,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #estimateGas,
          [],
          {
            #address: address,
            #transaction: transaction,
          },
        ),
        returnValue: _i9.Future<num>.value(0),
        returnValueForMissingStub: _i9.Future<num>.value(0),
      ) as _i9.Future<num>);
  @override
  _i9.Future<BigInt?> getSwapAmountOut(
          {required _i13.PancakeSwap? pancakeSwap}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSwapAmountOut,
          [],
          {#pancakeSwap: pancakeSwap},
        ),
        returnValue: _i9.Future<BigInt?>.value(),
        returnValueForMissingStub: _i9.Future<BigInt?>.value(),
      ) as _i9.Future<BigInt?>);
  @override
  _i9.Future<BigInt?> getSwapAmountIn(
          {required _i13.PancakeSwap? pancakeSwap}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSwapAmountIn,
          [],
          {#pancakeSwap: pancakeSwap},
        ),
        returnValue: _i9.Future<BigInt?>.value(),
        returnValueForMissingStub: _i9.Future<BigInt?>.value(),
      ) as _i9.Future<BigInt?>);
  @override
  _i9.Future<String> swap({
    required _i7.EthPrivateKey? privateKey,
    required num? gasPrice,
    required num? gasLimit,
    required _i13.PancakeSwap? pancakeSwap,
    required _i7.Transaction? tx,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #swap,
          [],
          {
            #privateKey: privateKey,
            #gasPrice: gasPrice,
            #gasLimit: gasLimit,
            #pancakeSwap: pancakeSwap,
            #tx: tx,
          },
        ),
        returnValue: _i9.Future<String>.value(''),
        returnValueForMissingStub: _i9.Future<String>.value(''),
      ) as _i9.Future<String>);
  @override
  _i9.Future<_i7.Transaction> buildSwapContractTransaction({
    required _i7.EthPrivateKey? privateKey,
    required _i13.PancakeSwap? pancakeSwap,
    required num? gasPrice,
    int? nonce,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #buildSwapContractTransaction,
          [],
          {
            #privateKey: privateKey,
            #pancakeSwap: pancakeSwap,
            #gasPrice: gasPrice,
            #nonce: nonce,
          },
        ),
        returnValue: _i9.Future<_i7.Transaction>.value(_FakeTransaction_5(
          this,
          Invocation.method(
            #buildSwapContractTransaction,
            [],
            {
              #privateKey: privateKey,
              #pancakeSwap: pancakeSwap,
              #gasPrice: gasPrice,
              #nonce: nonce,
            },
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i7.Transaction>.value(_FakeTransaction_5(
          this,
          Invocation.method(
            #buildSwapContractTransaction,
            [],
            {
              #privateKey: privateKey,
              #pancakeSwap: pancakeSwap,
              #gasPrice: gasPrice,
              #nonce: nonce,
            },
          ),
        )),
      ) as _i9.Future<_i7.Transaction>);
  @override
  _i9.Future<bool> waitForReceiptResult(
    _i10.Asset? asset,
    String? txHash,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #waitForReceiptResult,
          [
            asset,
            txHash,
          ],
        ),
        returnValue: _i9.Future<bool>.value(false),
        returnValueForMissingStub: _i9.Future<bool>.value(false),
      ) as _i9.Future<bool>);
}
