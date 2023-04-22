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
  late MerchantInfo merchantInfoTestnet;
  const int kMainnetChainId = 56;
  const int kTestnetChainId = 97;

  setUp(() {
    Config.setEnvironment(TChainPaymentEnv.dev);

    merchantInfoTestnet = MerchantInfo(
      merchantId: 'merchantId',
      currency: Currency.idr.shortName,
      qrCode: 'qrCode',
      chainId: Config.bscChainId.toString(),
      status: 1,
    );
  });

  tearDown(() {});

  group('PaymentInfoCubit', () {
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
        await bloc.getPaymentInfo(currentChainId: kTestnetChainId.toString());
        await bloc.getPaymentInfo(
            qrCode: '', currentChainId: kTestnetChainId.toString());

        when(mockPaymentRepos.getMerchantInfo(qrCode: 'qrCode')).thenAnswer(
            (realInvocation) async =>
                DataResponse(result: merchantInfoTestnet));

        await bloc.getPaymentInfo(
          qrCode: 'qrCode',
          currentChainId: kMainnetChainId.toString(),
        );
        await bloc.getPaymentInfo(
          qrCode: 'qrCode',
          currentChainId: kTestnetChainId.toString(),
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
