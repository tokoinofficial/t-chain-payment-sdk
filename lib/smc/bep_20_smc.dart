import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/common/transaction_waiter.dart';
import 'package:web3dart/web3dart.dart';

const kDefaultApprovedValue = 1000000000000;

class Bep20Smc extends GeneratedContract {
  Bep20Smc({
    required ContractAbi contractAbi,
    required EthereumAddress address,
    required Web3Client client,
    required int? chainId,
  }) : super(DeployedContract(contractAbi, address), client, chainId);

  Future<BigInt> getBalance(
    EthereumAddress walletAddress, {
    BlockNum? atBlock,
  }) async {
    final function = self.function('balanceOf');

    final params = [walletAddress];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  Future<num> allowance({
    required String walletAddress,
    required String contractAddress,
  }) async {
    final allowance = await client.call(
        contract: self,
        function: self.function('allowance'),
        params: [
          EthereumAddress.fromHex(walletAddress),
          EthereumAddress.fromHex(contractAddress)
        ]);

    return TokoinNumber.fromBigInt(
      allowance.first,
      exponent: kEthPowExponent,
    ).doubleValue;
  }

  Future<Transaction> buildApprovalTransaction({
    required EthPrivateKey privateKey,
    required String contractAddress,
    required BigInt amount,
    num gasPrice = 0,
    num? gasLimit,
    int? nonce,
  }) async {
    var credentials = privateKey;
    var address = credentials.address;
    var nextNonce = nonce ??
        await client.getTransactionCount(address,
            atBlock: const BlockNum.pending());

    return Transaction.callContract(
      contract: self,
      gasPrice: EtherAmount.fromBigInt(EtherUnit.gwei, BigInt.from(gasPrice)),
      maxGas: gasLimit ?? Config.maxGas,
      function: self.function('approve'),
      parameters: [EthereumAddress.fromHex(contractAddress), amount],
      nonce: nextNonce,
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
}
