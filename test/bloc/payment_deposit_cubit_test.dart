import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:t_chain_payment_sdk/bloc/payment/payment_deposit_cubit.dart';
import 'package:t_chain_payment_sdk/common/transaction_waiter.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/merchant_transaction.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/data/response/data_response.dart';
import 'package:t_chain_payment_sdk/data/transfer_data.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

@GenerateNiceMocks(
    [MockSpec<PaymentRepository>(), MockSpec<WalletRepository>()])
import 'payment_deposit_cubit_test.mocks.dart';

void main() {
  const privateKeyHex =
      '0097ad7d1294e0268bbaaf4642c6ccb4c4a76421bff0285023716e354c605513ee';
  const merchantId = '0x00';
  final mockWalletRepos = MockWalletRepository();

  final mockPaymentRepos = MockPaymentRepository();
  final translations = TChainPaymentLocalizationsEn();
  final account = Account.fromPrivateKeyHex(hex: privateKeyHex);

  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);

    TransactionWaiter().waitDuration = const Duration(seconds: 10);
  });

  tearDown(() {});

  group('PaymentDepositCubit', () {
    Asset? bnb;
    Asset? toko;
    Asset? usdt;
    const gasFee = GasFee(10, 10);
    const discountInfo = PaymentDiscountInfo(
      discountFeePercent: 1,
      deductAmount: 1000,
    );
    late TransferData tokoTransferData;
    late TransferData bnbTransferData;

    setUp(() {
      Config.setEnvironment(TChainPaymentEnv.dev);

      bnb = Asset.createAsset(shortName: 'BNB')!.copyWith(balance: 0.0);
      toko = Asset.createAsset(shortName: 'TOKO')!.copyWith(balance: 0.0);
      usdt = Asset.createAsset(shortName: 'USDT')!.copyWith(balance: 0.0);

      tokoTransferData = TransferData(
        asset: toko!,
        tokoAsset: toko,
        discountInfo: discountInfo,
        gasFee: gasFee,
        serviceFeePercent: 0,
        exchangeRate: 0.0031312488078522826,
        amount: 1,
        currency: Currency.usd,
      );

      bnbTransferData = TransferData(
        asset: bnb!,
        tokoAsset: toko,
        discountInfo: discountInfo,
        gasFee: gasFee,
        serviceFeePercent: 2.0,
        exchangeRate: 328.54587667254754,
        amount: 1.0,
        currency: Currency.usd,
      );

      TChainPaymentSDK.shared.account =
          Account.fromPrivateKeyHex(hex: privateKeyHex);
    });

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'emits [] when nothing is called',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.idr,
        account: account,
      ),
      expect: () => [],
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'emits [PaymentDepositSetUpCompleted] when everything ready',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.usd,
        account: account,
      ),
      act: (cubit) async {
        when(mockWalletRepos.isReady).thenReturn(false);
        await cubit.setup();

        when(mockWalletRepos.isReady).thenReturn(true);
        await cubit.setup();
      },
      expect: () => [
        PaymentDepositWaitForSetup(),
        PaymentDepositError(
          error: translations.something_went_wrong_please_try_later,
        ),
        PaymentDepositWaitForSetup(),
        PaymentDepositSetUpCompleted(),
      ],
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'test getAllInfo(...) and getExchangeRate(...)',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.usd,
        account: account,
      ),
      act: (cubit) async {
        cubit.emit(const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [],
        ));

        when(mockWalletRepos.getBSCGasFees())
            .thenAnswer((realInvocation) => Future.value([gasFee]));

        when(mockWalletRepos.getPaymentDepositFee())
            .thenAnswer((realInvocation) => Future.value(2));

        when(mockWalletRepos.getPaymentDiscountFee(
                contractAddress: Config.bnbContractAddress, amount: 1))
            .thenAnswer((realInvocation) => Future.value(discountInfo));
        when(mockWalletRepos.getPaymentDiscountFee(
                contractAddress: Config.bscTokoinContractAddress, amount: 1))
            .thenAnswer((realInvocation) => Future.value(discountInfo));

        when(mockPaymentRepos.getExchangeRate())
            .thenAnswer((realInvocation) async => DataResponse(result: {
                  "BNB": 327.54587667254754,
                  "BTC": 28241.672811044613,
                  "TOKO": 0.0031312488078522826,
                  "CAKE": 3.672811044613,
                }));

        await cubit.getAllInfo();

        when(mockPaymentRepos.getExchangeRate())
            .thenAnswer((realInvocation) async => DataResponse(result: {
                  "BNB": 328.54587667254754,
                  "BTC": 28241.672811044613,
                  "TOKO": 1.0031312488078522826,
                }));

        await cubit.getExchangeRate();
      },
      expect: () => [
        const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [],
        ),
        const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loading,
          isEnoughBnb: false,
          transferDataList: [],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loading,
          isEnoughBnb: false,
          transferDataList: [
            TransferData(
              asset: bnb!,
              tokoAsset: toko,
              exchangeRate: 327.54587667254754,
              amount: 1.0,
              currency: Currency.usd,
            ),
            TransferData(
              asset: toko!,
              tokoAsset: toko,
              serviceFeePercent: 0.0,
              exchangeRate: 0.0031312488078522826,
              amount: 1.0,
              currency: Currency.usd,
            ),
          ],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [
            TransferData(
              asset: bnb!,
              tokoAsset: toko,
              discountInfo: discountInfo,
              gasFee: gasFee,
              serviceFeePercent: 2.0,
              exchangeRate: 327.54587667254754,
              amount: 1.0,
              currency: Currency.usd,
            ),
            TransferData(
              asset: toko!,
              tokoAsset: toko,
              discountInfo: discountInfo,
              gasFee: gasFee,
              serviceFeePercent: 0.0,
              exchangeRate: 0.0031312488078522826,
              amount: 1.0,
              currency: Currency.usd,
            ),
          ],
        ),
        const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loading,
          isEnoughBnb: false,
          transferDataList: [],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [
            TransferData(
              asset: bnb!,
              tokoAsset: toko,
              discountInfo: discountInfo,
              gasFee: gasFee,
              serviceFeePercent: 2,
              exchangeRate: 328.54587667254754,
              amount: 1,
              currency: Currency.usd,
            ),
            TransferData(
              asset: toko!,
              tokoAsset: toko,
              discountInfo: discountInfo,
              gasFee: gasFee,
              serviceFeePercent: 0,
              exchangeRate: 1.0031312488078522826,
              amount: 1,
              currency: Currency.usd,
            ),
          ],
        )
      ],
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'test deposit(...) emits [PaymentDepositSwapRequest]',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.usd,
        account: account,
      ),
      act: (cubit) async {
        cubit.emit(const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [],
        ));

        when(mockWalletRepos.isEnoughBnb(
          privateKey: account.privateKey,
          amount: 1,
          asset: bnb!,
          gasPrice: 10,
          estimatedGas: 10,
        )).thenAnswer((realInvocation) async => true);

        when(mockWalletRepos.getBSCGasFees())
            .thenAnswer((realInvocation) => Future.value([gasFee]));

        when(mockWalletRepos.getPaymentDepositFee())
            .thenAnswer((realInvocation) => Future.value(2));

        when(mockWalletRepos.getPaymentDiscountFee(
                contractAddress: bnb!.contractAddress, amount: 1))
            .thenAnswer((realInvocation) => Future.value(discountInfo));

        when(mockPaymentRepos.getExchangeRate())
            .thenAnswer((realInvocation) async => DataResponse(result: {
                  "BNB": 328.54587667254754,
                }));

        await cubit.getAllInfo();

        // increase toko allowance
        when(mockWalletRepos.allowance(
                privateKey: account.privateKey,
                asset: toko!,
                contractAddress: anyNamed('contractAddress')))
            .thenAnswer((realInvocation) async => 10000);

        // emits PaymentDepositSwapRequest event
        await cubit.deposit(
          asset: bnb!,
          useToko: true,
          notes: 'notes',
          merchantId: merchantId,
          chainId: 'chainId',
        );
      },
      expect: () => [
        const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [],
        ),
        const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loading,
          isEnoughBnb: false,
          transferDataList: [],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loading,
          isEnoughBnb: false,
          transferDataList: [
            TransferData(
              asset: bnb!,
              tokoAsset: toko,
              serviceFeePercent: null,
              exchangeRate: 328.54587667254754,
              amount: 1.0,
              currency: Currency.usd,
            ),
          ],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [bnbTransferData],
        ),
        // call deposit
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.depositing,
          isEnoughBnb: false,
          transferDataList: [bnbTransferData],
        ),
        PaymentDepositSwapRequest(
          fromAsset: bnb!,
          toAsset: usdt!,
          amount: 1 / 328.54587667254754 +
              discountInfo.getDiscountedServiceFee(
                serviceFeePercent: 2,
                amount: 1 / 328.54587667254754,
                useToko: true,
              ),
          gasFee: gasFee,
          transferDataList: [bnbTransferData],
        ),
      ],
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'test deposit(...) emits [PaymentDepositCompleted]',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.usd,
        account: account,
      ),
      act: (cubit) async {
        cubit.emit(const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [],
        ));

        when(mockWalletRepos.isEnoughBnb(
          privateKey: account.privateKey,
          amount: 1,
          asset: bnb!,
          gasPrice: 10,
          estimatedGas: 10,
        )).thenAnswer((realInvocation) async => true);

        when(mockWalletRepos.getBSCGasFees())
            .thenAnswer((realInvocation) => Future.value([gasFee]));

        when(mockWalletRepos.getPaymentDepositFee())
            .thenAnswer((realInvocation) => Future.value(2));

        when(mockWalletRepos.getPaymentDiscountFee(
                contractAddress: Config.bscTokoinContractAddress, amount: 1))
            .thenAnswer((realInvocation) => Future.value(discountInfo));

        when(mockPaymentRepos.getExchangeRate())
            .thenAnswer((realInvocation) async => DataResponse(result: {
                  "TOKO": 0.0031312488078522826,
                }));

        await cubit.getAllInfo();

        when(mockWalletRepos.allowance(
          privateKey: account.privateKey,
          asset: toko!,
          contractAddress: anyNamed('contractAddress'),
        )).thenAnswer((realInvocation) async => 0);

        // emits PaymentDepositAddAllowance event
        await cubit.deposit(
          asset: toko!,
          useToko: true,
          notes: 'notes',
          merchantId: merchantId,
          chainId: 'chainId',
        );

        when(mockWalletRepos.allowance(
          privateKey: account.privateKey,
          asset: toko!,
          contractAddress: anyNamed('contractAddress'),
        )).thenAnswer((realInvocation) async => 10000);

        when(mockPaymentRepos.createMerchantTransaction(
          address: anyNamed('address'),
          amount: anyNamed('amount'),
          currency: anyNamed('currency'),
          notes: anyNamed('notes'),
          tokenName: anyNamed('tokenName'),
          externalMerchantId: anyNamed('externalMerchantId'),
          chainId: anyNamed('chainId'),
        )).thenAnswer((realInvocation) async => MerchantTransaction(
              merchantId: merchantId,
              transactionId: 'id',
              offchain: 'bb',
              amount: 1,
              amountUint256: BigInt.one.toString(),
              fee: 10,
              feeUint256: BigInt.one.toString(),
              signedHash: 'aa',
              expiredTime: 1,
              rate: 1,
            ));

        when(mockWalletRepos.balanceOf(
          smcAddressHex: anyNamed('smcAddressHex'),
          privateKey: account.privateKey,
        )).thenAnswer((_) async => 10000);

        when(mockWalletRepos.estimateGas(
            address: anyNamed('address'),
            transaction: anyNamed(
              'transaction',
            ))).thenAnswer((realInvocation) async => 1);

        when(mockWalletRepos.isEnoughBnb(
          privateKey: account.privateKey,
          asset: toko!,
          amount: 1.0 / 0.0031312488078522826,
          gasPrice: 10,
          estimatedGas: 1,
        )).thenAnswer((realInvocation) async => true);

        when(mockWalletRepos.sendPaymentTransaction(
          privateKey: account.privateKey,
          tx: anyNamed('tx'),
        )).thenAnswer((realInvocation) async => 'txHash');

        when(mockWalletRepos.waitForReceiptResult(toko!, 'txHash'))
            .thenAnswer((realInvocation) async => true);

        // emits PaymentDepositCompleted event
        await cubit.deposit(
          asset: toko!,
          useToko: true,
          notes: 'notes',
          merchantId: merchantId,
          chainId: 'chainId',
        );
      },
      expect: () => [
        const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [],
        ),
        const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loading,
          isEnoughBnb: false,
          transferDataList: [],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loading,
          isEnoughBnb: false,
          transferDataList: [
            TransferData(
              asset: toko!,
              tokoAsset: toko,
              serviceFeePercent: 0.0,
              exchangeRate: 0.0031312488078522826,
              amount: 1.0,
              currency: Currency.usd,
            ),
          ],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [
            TransferData(
              asset: toko!,
              tokoAsset: toko,
              discountInfo: discountInfo,
              gasFee: gasFee,
              serviceFeePercent: 0.0,
              exchangeRate: 0.0031312488078522826,
              amount: 1.0,
              currency: Currency.usd,
            ),
          ],
        ),
        // call deposit
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.depositing,
          isEnoughBnb: false,
          transferDataList: [tokoTransferData],
        ),
        PaymentDepositAddAllowance(
          asset: toko!,
          amount: 1.0 /
              0.0031312488078522826 *
              1.01, // useToko: fee 2% - 1% discount
          contractAddress: Config.paymentTokenRegistry,
          transferDataList: [tokoTransferData],
        ),
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [tokoTransferData],
        ),
        // call deposit
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.depositing,
          isEnoughBnb: false,
          transferDataList: [tokoTransferData],
        ),
        const PaymentDepositProceeding(txn: 'txHash'),
        const PaymentDepositCompleted(txn: 'txHash'),
      ],
    );
  });
}
