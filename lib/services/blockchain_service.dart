import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:t_chain_payment_sdk/helpers/transaction_waiter.dart';
import 'package:t_chain_payment_sdk/smc/bep_20_smc.dart';
import 'package:t_chain_payment_sdk/smc/payment_smc.dart';
import 'package:web3dart/web3dart.dart';

class BlockchainService {
  Future<Web3Client?> createWeb3Client(List<String> providers) async {
    var httpClient = Client();
    if (providers.length == 1) {
      return Web3Client(
        providers.first,
        httpClient,
      );
    }

    return await transactionWaiter.ready(() async {
      for (int i = 0; i < providers.length; i++) {
        var e = providers[i];

        try {
          var response = await Dio().get(e);
          if (response.statusCode == 200) {
            return Web3Client(
              e,
              httpClient,
            );
          }
        } on DioError catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  Future<Bep20Smc> createBep20Smc({
    required EthereumAddress address,
    required Web3Client client,
    required int? chainId,
  }) async {
    final abiString = await rootBundle
        .loadString("packages/t_chain_payment_sdk/lib/smc/abis/bep20.abi.json");

    final bep20Api = ContractAbi.fromJson(abiString, 'bep20');

    return Bep20Smc(
      contractAbi: bep20Api,
      address: address,
      client: client,
      chainId: chainId,
    );
  }

  Future<PaymentSmc> createPaymentSmc({
    required EthereumAddress address,
    required Web3Client client,
    required int? chainId,
  }) async {
    final abiString = await rootBundle.loadString(
        "packages/t_chain_payment_sdk/lib/smc/abis/payment.abi.json");

    final bep20Api = ContractAbi.fromJson(abiString, 'payment');

    return PaymentSmc(
      contractAbi: bep20Api,
      address: address,
      client: client,
      chainId: chainId,
    );
  }
}
