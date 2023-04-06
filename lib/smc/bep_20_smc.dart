import 'package:web3dart/web3dart.dart';

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
    final function = self.abi.functions[0];

    final params = [walletAddress];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }
}
