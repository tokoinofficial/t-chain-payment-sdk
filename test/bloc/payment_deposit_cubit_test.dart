import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:t_chain_payment_sdk/bloc/payment/payment_deposit_cubit.dart';
import 'package:t_chain_payment_sdk/bloc/payment/payment_info_cubit.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
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
  final mockWalletRepos = MockWalletRepository();

  final mockPaymentRepos = MockPaymentRepository();
  final translations = TChainPaymentLocalizationsEn();

  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  tearDown(() {});

  group('PaymentDepositCubit', () {
    Asset? bnb;
    Asset? toko;
    Asset? cake;
    final gasFee = GasFee(10, 10);
    const discountInfo = PaymentDiscountInfo(
      discountFeePercent: 50,
      deductAmount: 1000,
    );

    setUp(() {
      bnb = Asset.createAsset(shortName: 'BNB')!.copyWith(balance: 0.0);

      toko = Asset.createAsset(shortName: 'TOKO')!.copyWith(balance: 0.0);
      cake = Asset.createAsset(shortName: 'CAKE')!.copyWith(balance: 0.0);

      TChainPaymentSDK.shared.account = Account(privateKeyHex: privateKeyHex);
    });

    final merchantInfoTestnet = MerchantInfo(
      merchantId: 'merchantId',
      currency: Currency.idr.shortName,
      qrCode: 'qrCode',
      chainId: kTestnetChainID.toString(),
      status: 1,
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'emits [] when nothing is called',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.idr,
        privateKeyHex: privateKeyHex,
      ),
      expect: () => [],
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'emits [PaymentDepositUnsupportedWallet] when cannot find any assets',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.usd,
        privateKeyHex: '',
      ),
      act: (cubit) {
        cubit.setup();
      },
      expect: () => [
        PaymentDepositUnsupportedWallet(),
      ],
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'emits [PaymentDepositSetUpCompleted] when everything ready',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.usd,
        privateKeyHex: privateKeyHex,
      ),
      act: (cubit) async {
        when(mockWalletRepos.isReady).thenReturn(false);
        await cubit.setup();

        when(mockWalletRepos.isReady).thenReturn(true);
        await cubit.setup();
      },
      expect: () => [
        PaymentDepositError(
          error: translations.something_went_wrong_please_try_later,
        ),
        PaymentDepositSetUpCompleted(),
      ],
    );

    blocTest<PaymentDepositCubit, PaymentDepositState>(
      'test getAllInfo and getExchangeRate',
      build: () => PaymentDepositCubit(
        walletRepository: mockWalletRepos,
        paymentRepository: mockPaymentRepos,
        amount: 1,
        currency: Currency.usd,
        privateKeyHex: privateKeyHex,
      ),
      act: (cubit) async {
        cubit.emit(const PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: false,
          transferDataList: [],
        ));

        when(mockWalletRepos.isEnoughBnb(
          privateKeyHex: privateKeyHex,
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
                contractAddress: Config.bnbContractAddress, amount: 1))
            .thenAnswer((realInvocation) => Future.value(discountInfo));
        when(mockWalletRepos.getPaymentDiscountFee(
                contractAddress: Config.bscTokoinContractAddress, amount: 1))
            .thenAnswer((realInvocation) => Future.value(discountInfo));
        when(mockWalletRepos.getPaymentDiscountFee(
                contractAddress: Config.bscCakeContractAddress, amount: 1))
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
            TransferData(
              asset: cake!,
              tokoAsset: toko,
              exchangeRate: 3.672811044613,
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
            TransferData(
              asset: cake!,
              tokoAsset: toko,
              discountInfo: discountInfo,
              gasFee: gasFee,
              serviceFeePercent: 2.0,
              exchangeRate: 3.672811044613,
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
  });
}
