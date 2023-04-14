import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/common/transaction_waiter.dart';
import 'package:web3dart/web3dart.dart';

const num kMaxSlippage = 1.0;
const num kDeadlineInSecond = 1200; // 20 minutes

class PancakeSwapSmc extends GeneratedContract {
  PancakeSwapSmc({
    required ContractAbi contractAbi,
    required EthereumAddress address,
    required Web3Client client,
    required int? chainId,
  }) : super(DeployedContract(contractAbi, address), client, chainId);

  Future<BigInt> getBalance(
    EthereumAddress walletAddress, {
    BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[0];

    final params = [walletAddress];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// call getAmountOut func with params: [amountIn], [reserveIn], [reserveOut]
  ///
  /// return [amountOut]
  Future<BigInt?> getAmountOut({
    num amountIn = 0,
    required List<String> paths,
  }) async {
    final contractFunction = self.function('getAmountsOut');
    final params = [
      TokoinNumber.fromNumber(amountIn).bigIntValue,
      paths.map((e) => EthereumAddress.fromHex(e)).toList()
    ];

    final results = await read(contractFunction, params, null);

    if (results.isEmpty) return null;
    List<dynamic> subResults = results.first;
    if (subResults.length != paths.length) return null;
    return subResults[paths.length - 1];
  }

  /// call getAmountIn func with params: [amountIn], [reserveIn], [reserveOut]
  ///
  /// return [amountIn]
  Future<BigInt?> getAmountIn({
    num amountOut = 0,
    required List<String> paths,
  }) async {
    final contractFunction = self.function('getAmountsIn');
    final params = [
      TokoinNumber.fromNumber(amountOut).bigIntValue,
      paths.map((e) => EthereumAddress.fromHex(e)).toList()
    ];

    final results = await read(contractFunction, params, null);

    if (results.isEmpty) return null;
    List<dynamic> subResults = results.first;
    if (subResults.isEmpty) return null;
    return subResults.first;
  }

  Future<Transaction> buildSwapTransaction({
    required EthPrivateKey privateKey,
    required String functionName,
    required List parameters,
    num gasPrice = 0,
    int? nonce,
    BigInt? value,
  }) async {
    var credentials = privateKey;
    var address = credentials.address;
    var nextNonce = nonce ??
        await client.getTransactionCount(address,
            atBlock: const BlockNum.pending());

    return Transaction.callContract(
      contract: self,
      gasPrice: EtherAmount.fromBigInt(EtherUnit.gwei, BigInt.from(gasPrice)),
      maxGas: Config.maxGas,
      function: self.function(functionName),
      parameters: parameters,
      nonce: nextNonce,
      value:
          value != null ? EtherAmount.fromBigInt(EtherUnit.wei, value) : null,
    );
  }

  Future<String> sendRawTransaction({
    required EthPrivateKey privateKey,
    required Transaction transaction,
  }) async {
    return await transactionWaiter.ready(() async {
      var credentials = privateKey;
      return await client.sendTransaction(
        credentials,
        transaction,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
    });
  }

  static get deadline => BigInt.from(
      DateTime.now().millisecondsSinceEpoch / 1000 + kDeadlineInSecond);
}
