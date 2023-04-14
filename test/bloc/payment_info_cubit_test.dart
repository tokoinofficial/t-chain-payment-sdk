import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:t_chain_payment_sdk/bloc/payment/payment_info_cubit.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/response/data_response.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

@GenerateNiceMocks([MockSpec<PaymentRepository>()])
import 'payment_info_cubit_test.mocks.dart';

void main() {
  final mockPaymentRepos = MockPaymentRepository();

  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);
  });

  tearDown(() {});

  group('PaymentInfoCubit', () {
    final merchantInfoTestnet = MerchantInfo(
      merchantId: 'merchantId',
      currency: Currency.idr.shortName,
      qrCode: 'qrCode',
      chainId: kTestnetChainID.toString(),
      status: 1,
    );

    blocTest<PaymentInfoCubit, PaymentInfoState>(
      'emits [] when nothing is called',
      build: () => PaymentInfoCubit(
        paymentRepository: mockPaymentRepos,
      ),
      expect: () => [],
    );

    blocTest<PaymentInfoCubit, PaymentInfoState>(
      'test getPaymentInfo(...)',
      build: () => PaymentInfoCubit(
        paymentRepository: mockPaymentRepos,
      ),
      act: (bloc) async {
        await bloc.getPaymentInfo(currentChainId: kTestnetChainID.toString());
        await bloc.getPaymentInfo(
            qrCode: '', currentChainId: kTestnetChainID.toString());

        when(mockPaymentRepos.getMerchantInfo(qrCode: 'qrCode')).thenAnswer(
            (realInvocation) async =>
                DataResponse(result: merchantInfoTestnet));

        await bloc.getPaymentInfo(
          qrCode: 'qrCode',
          currentChainId: kMainnetChainID.toString(),
        );
        await bloc.getPaymentInfo(
          qrCode: 'qrCode',
          currentChainId: kTestnetChainID.toString(),
        );
      },
      expect: () => [
        PaymentInfoLoading(),
        PaymentInfoUnsupported(),
        PaymentInfoLoading(),
        PaymentInfoUnsupported(),
        PaymentInfoLoading(),
        PaymentInfoUnsupported(),
        PaymentInfoLoading(),
        PaymentInfoLoaded(merchantInfo: merchantInfoTestnet),
      ],
    );
  });
}
