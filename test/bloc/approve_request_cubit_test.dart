import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:t_chain_payment_sdk/bloc/approve_request/approve_request_cubit.dart';
import 'package:t_chain_payment_sdk/common/transaction_waiter.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:t_chain_payment_sdk/repo/storage_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:web3dart/web3dart.dart';

@GenerateNiceMocks(
    [MockSpec<WalletRepository>(), MockSpec<StorageRepository>()])
import 'approve_request_cubit_test.mocks.dart';

void main() {
  const privateKeyHex =
      '0097ad7d1294e0268bbaaf4642c6ccb4c4a76421bff0285023716e354c605513ee';
  final mockWalletRepos = MockWalletRepository();
  late MockStorageRepository mockStorageRepos;
  final translations = TChainPaymentLocalizationsEn();
  late Account account;

  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  tearDown(() {});

  group('ApproveRequestCubit', () {
    Asset? bnb;

    setUp(() {
      bnb = Asset.createAsset(shortName: 'BNB');

      TransactionWaiter().waitDuration = const Duration(seconds: 10);
      mockStorageRepos = MockStorageRepository();
      account = Account.fromPrivateKeyHex(hex: privateKeyHex);
    });

    blocTest<ApproveRequestCubit, ApproveRequestState>(
      'emits [] when nothing is called',
      build: () => ApproveRequestCubit(
        walletRepository: mockWalletRepos,
        storageRepository: mockStorageRepos,
        account: account,
      ),
      expect: () => [],
    );

    blocTest<ApproveRequestCubit, ApproveRequestState>(
      'test loadTokenInfo',
      build: () => ApproveRequestCubit(
        walletRepository: mockWalletRepos,
        storageRepository: mockStorageRepos,
        account: account,
      ),
      act: (bloc) async {
        when(mockWalletRepos.balanceOf(
                smcAddressHex: bnb!.contractAddress,
                privateKey: account.privateKey))
            .thenAnswer((realInvocation) async => 100);

        // emit ApproveRequestError when cannot get gas fee
        await bloc.loadTokenInfo(asset: bnb!);

        when(mockWalletRepos.getBSCGasFees())
            .thenAnswer((realInvocation) async => [const GasFee(10, 5)]);

        // emit ApproveRequestReady
        await bloc.loadTokenInfo(asset: bnb!);
      },
      expect: () => [
        ApproveRequestLoading(),
        ApproveRequestError(
          error: translations.cannot_get_gas_fee,
        ),
        ApproveRequestLoading(),
        ApproveRequestReady(
          asset: bnb!,
          balance: 100,
          gasFee: const GasFee(10, 5),
        ),
      ],
    );

    blocTest<ApproveRequestCubit, ApproveRequestState>(
      'emits [ApproveRequestSuccess] when getting sufficient allowance',
      build: () => ApproveRequestCubit(
        walletRepository: mockWalletRepos,
        storageRepository: mockStorageRepos,
        account: account,
      ),
      act: (bloc) async {
        when(mockWalletRepos.allowance(
                privateKey: account.privateKey,
                asset: bnb!,
                contractAddress: 'smc'))
            .thenAnswer((realInvocation) async => 10000);

        // emit ApproveRequestSuccess
        await bloc.approve(
          asset: bnb!,
          amount: 100,
          resend: false,
          gasPrice: 10,
          contractAddress: 'smc',
        );
      },
      expect: () => [
        ApproveRequestLoading(),
        ApproveRequestSuccess(),
      ],
    );

    blocTest<ApproveRequestCubit, ApproveRequestState>(
      'test approve(...) when there is no pending approval tnx',
      build: () => ApproveRequestCubit(
        walletRepository: mockWalletRepos,
        storageRepository: mockStorageRepos,
        account: account,
      ),
      act: (bloc) async {
        when(mockWalletRepos.allowance(
                privateKey: account.privateKey,
                asset: bnb!,
                contractAddress: 'smc'))
            .thenAnswer((realInvocation) async => 0);

        when(mockWalletRepos.estimateGas(
          address: anyNamed('address'),
          transaction: anyNamed('transaction'),
        )).thenAnswer((realInvocation) async => 10);

        when(mockWalletRepos.isEnoughBnb(
          privateKey: account.privateKey,
          asset: bnb!,
          amount: 100,
          gasPrice: 10,
          estimatedGas: 10,
        )).thenAnswer((realInvocation) async => false);

        // emit ApproveRequestError when not enough bnb
        await bloc.approve(
          asset: bnb!,
          amount: 100,
          resend: false,
          gasPrice: 10,
          contractAddress: 'smc',
        );

        when(mockWalletRepos.isEnoughBnb(
          privateKey: account.privateKey,
          asset: bnb!,
          amount: 100,
          gasPrice: 10,
          estimatedGas: 10,
        )).thenAnswer((realInvocation) async => true);

        when(mockWalletRepos.allowance(
                privateKey: account.privateKey,
                asset: bnb!,
                contractAddress: 'smc'))
            .thenAnswer((realInvocation) async => 0);

        // emit ApproveRequestWaiting
        await bloc.approve(
          asset: bnb!,
          amount: 100,
          resend: false,
          gasPrice: 10,
          contractAddress: 'smc',
        );

        when(mockWalletRepos.allowance(
                privateKey: account.privateKey,
                asset: bnb!,
                contractAddress: 'smc'))
            .thenAnswer((realInvocation) async => 10000);

        // emit ApproveRequestSuccess
        await bloc.approve(
          asset: bnb!,
          amount: 100,
          resend: false,
          gasPrice: 10,
          contractAddress: 'smc',
        );
      },
      expect: () => [
        ApproveRequestLoading(),
        ApproveRequestError(error: translations.you_are_not_enough_bnb),
        ApproveRequestLoading(),
        ApproveRequestWaiting(),
        ApproveRequestLoading(),
        ApproveRequestSuccess(),
      ],
    );

    blocTest<ApproveRequestCubit, ApproveRequestState>(
      'test approve(...) when there is a pending approval tnx',
      build: () => ApproveRequestCubit(
        walletRepository: mockWalletRepos,
        storageRepository: mockStorageRepos,
        account: account,
      ),
      act: (bloc) async {
        when(mockWalletRepos.allowance(
                privateKey: account.privateKey,
                asset: bnb!,
                contractAddress: 'smc'))
            .thenAnswer((realInvocation) async => 0);

        when(mockStorageRepos.getPendingApprovalTxHash(
          walletAddress: anyNamed('walletAddress'),
          contractAddress: 'smc',
        )).thenAnswer((realInvocation) async => '0xPendingTnx');

        when(mockWalletRepos.getTransactionByHash(bnb!, '0xPendingTnx'))
            .thenAnswer(
          (realInvocation) async => TransactionInformation.fromMap({
            'from': '0x0123456789012345678901234567890123456789',
            'gas': '10',
            'gasPrice': '10',
            'hash': 'hash',
            'input': '0x01234567890000',
            'nonce': '10000',
            'value': '100',
            'v': '0xaa',
            'r': '0xaa',
            's': '0xaa',
          }),
        );

        // emit ApproveRequestPending
        await bloc.approve(
          asset: bnb!,
          amount: 100,
          resend: false,
          gasPrice: 10,
          contractAddress: 'smc',
        );

        when(mockWalletRepos.getTransactionReceipt(bnb!, '0xPendingTnx'))
            .thenAnswer(
          (realInvocation) async => TransactionReceipt(
            status: true,
            transactionHash: 'PendingTnx'.toBytes32(),
            transactionIndex: 1,
            blockHash: 'blockHash'.toBytes32(),
            cumulativeGasUsed: BigInt.one,
          ),
        );

        when(mockWalletRepos.allowance(
                privateKey: account.privateKey,
                asset: bnb!,
                contractAddress: 'smc'))
            .thenAnswer((realInvocation) async => 10000);

        // emit ApproveRequestWaiting
        await bloc.approve(
          asset: bnb!,
          amount: 100,
          resend: false,
          gasPrice: 10,
          contractAddress: 'smc',
        );
      },
      expect: () => [
        ApproveRequestLoading(),
        ApproveRequestPending(),
        ApproveRequestLoading(),
        ApproveRequestSuccess(),
      ],
    );
  });
}
