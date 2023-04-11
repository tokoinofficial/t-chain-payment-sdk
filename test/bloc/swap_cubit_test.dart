import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:t_chain_payment_sdk/bloc/swap/swap_cubit.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/pancake_swap.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

@GenerateNiceMocks([MockSpec<WalletRepository>()])
import 'swap_cubit_test.mocks.dart';

void main() {
  const privateKeyHex =
      '0097ad7d1294e0268bbaaf4642c6ccb4c4a76421bff0285023716e354c605513ee';
  final mockWalletRepos = MockWalletRepository();
  final translations = TChainPaymentLocalizationsEn();

  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  tearDown(() {});

  group('SwapCubit', () {
    num _getAmountOut({
      required Asset assetOut,
      required BigInt amountOutBigInt,
    }) {
      final exponent = TokoinNumber.getExponentWithAsset(assetOut);
      final amountOut = TokoinNumber.fromBigInt(
        amountOutBigInt,
        exponent: exponent,
      ).doubleValue;
      return amountOut;
    }

    blocTest<SwapCubit, SwapState>(
      'emits [] when nothing is called',
      build: () => SwapCubit(
        walletRepository: mockWalletRepos,
        privateKeyHex: privateKeyHex,
      ),
      expect: () => [],
    );

    blocTest<SwapCubit, SwapState>(
      'emits [SwapFailed] when missing amountIn and amountOut',
      build: () => SwapCubit(
        walletRepository: mockWalletRepos,
        privateKeyHex: '',
      ),
      act: (bloc) {
        bloc.confirmSwap(
          gasPrice: 10,
          pancakeSwap: PancakeSwap(
            assetIn: Asset.createAsset(shortName: 'BNB')!,
            assetOut: Asset.createAsset(shortName: 'USDT')!,
          ),
        );
      },
      expect: () => [
        SwapSending(),
        SwapFailed(
          translations.something_went_wrong_please_try_later,
        )
      ],
    );

    blocTest<SwapCubit, SwapState>(
      'emits [SwapAddAllowance] when has not enough allowance',
      build: () => SwapCubit(
        walletRepository: mockWalletRepos,
        privateKeyHex: privateKeyHex,
      ),
      act: (bloc) {
        final pancakeSwap = PancakeSwap(
          assetIn: Asset.createAsset(shortName: 'BNB')!,
          amountIn: 1,
          assetOut: Asset.createAsset(shortName: 'USDT')!,
        );

        when(mockWalletRepos.getSwapAmountOut(pancakeSwap: pancakeSwap))
            .thenAnswer((realInvocation) async => BigInt.from(200));

        when(mockWalletRepos.allowance(
                asset: pancakeSwap.assetIn,
                privateKeyHex: privateKeyHex,
                contractAddress: Config.pancakeRouter))
            .thenAnswer((realInvocation) async => 0);

        bloc.confirmSwap(
          gasPrice: 10,
          pancakeSwap: pancakeSwap,
        );
      },
      expect: () => [
        SwapSending(),
        SwapAddAllowance(
          asset: Asset.createAsset(shortName: 'BNB')!,
          amount: 1,
          contractAddress: Config.pancakeRouter,
        )
      ],
    );

    blocTest<SwapCubit, SwapState>(
      'emits [SwapFailed] when not enough balance',
      build: () => SwapCubit(
        walletRepository: mockWalletRepos,
        privateKeyHex: privateKeyHex,
      ),
      act: (bloc) {
        final pancakeSwap = PancakeSwap(
          assetIn: Asset.createAsset(shortName: 'BNB')!,
          amountIn: 1,
          assetOut: Asset.createAsset(shortName: 'USDT')!,
        );

        when(mockWalletRepos.getSwapAmountOut(pancakeSwap: pancakeSwap))
            .thenAnswer((realInvocation) async => BigInt.from(200));

        when(mockWalletRepos.allowance(
                asset: pancakeSwap.assetIn,
                privateKeyHex: privateKeyHex,
                contractAddress: Config.pancakeRouter))
            .thenAnswer((realInvocation) async => 100);

        when(mockWalletRepos.estimateGas(
          address: anyNamed('address'),
          transaction: anyNamed('transaction'),
        )).thenAnswer((realInvocation) async => 10);

        when(mockWalletRepos.isEnoughBnb(
          privateKeyHex: privateKeyHex,
          asset: pancakeSwap.assetIn,
          amount: pancakeSwap.amountIn,
          gasPrice: anyNamed('gasPrice'),
          estimatedGas: anyNamed('estimatedGas'),
        )).thenAnswer((realInvocation) async => false);

        bloc.confirmSwap(
          gasPrice: 10,
          pancakeSwap: pancakeSwap,
        );
      },
      expect: () => [
        SwapSending(),
        SwapFailed(
          translations.you_are_not_enough_bnb,
        )
      ],
    );

    blocTest<SwapCubit, SwapState>(
      'emits [SwapSuccess] when successfully swap',
      build: () => SwapCubit(
        walletRepository: mockWalletRepos,
        privateKeyHex: privateKeyHex,
      ),
      act: (bloc) async {
        final pancakeSwap = PancakeSwap(
          assetIn: Asset.createAsset(shortName: 'BNB')!,
          amountIn: 1,
          assetOut: Asset.createAsset(shortName: 'USDT')!,
        );

        when(mockWalletRepos.getSwapAmountOut(pancakeSwap: pancakeSwap))
            .thenAnswer((realInvocation) async => BigInt.from(200));

        when(mockWalletRepos.allowance(
                asset: pancakeSwap.assetIn,
                privateKeyHex: privateKeyHex,
                contractAddress: Config.pancakeRouter))
            .thenAnswer((realInvocation) async => 100);

        when(mockWalletRepos.estimateGas(
          address: anyNamed('address'),
          transaction: anyNamed('transaction'),
        )).thenAnswer((realInvocation) async => 10);

        when(mockWalletRepos.isEnoughBnb(
          privateKeyHex: privateKeyHex,
          asset: pancakeSwap.assetIn,
          amount: pancakeSwap.amountIn,
          gasPrice: anyNamed('gasPrice'),
          estimatedGas: anyNamed('estimatedGas'),
        )).thenAnswer((realInvocation) async => true);

        when(mockWalletRepos.waitForReceiptResult(
          any,
          any,
        )).thenAnswer((realInvocation) async => false);

        await bloc.confirmSwap(
          gasPrice: 10,
          pancakeSwap: pancakeSwap,
        );

        when(mockWalletRepos.waitForReceiptResult(
          any,
          any,
        )).thenAnswer((realInvocation) async => true);

        await bloc.confirmSwap(
          gasPrice: 10,
          pancakeSwap: pancakeSwap,
        );
      },
      expect: () => [
        SwapSending(),
        SwapFailed(
          translations.something_went_wrong_please_try_later,
        ),
        SwapSending(),
        SwapSuccess(PancakeSwap(
          assetIn: Asset.createAsset(shortName: 'BNB')!,
          amountIn: 1,
          assetOut: Asset.createAsset(shortName: 'USDT')!,
          amountOut: _getAmountOut(
            assetOut: Asset.createAsset(shortName: 'BNB')!,
            amountOutBigInt: BigInt.from(200),
          ),
        )),
      ],
    );
  });
}
