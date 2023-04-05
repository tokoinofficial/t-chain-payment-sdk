import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:t_chain_payment_sdk/helpers/transaction_waiter.dart';
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
}
