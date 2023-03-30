import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/data/request_body.dart/gen_qr_code_body.dart';
import 'package:t_chain_payment_sdk/data/response/data_response.dart';

part 't_chain_api.g.dart';

const kAuthorizationKey = 'Authorization';
const kApiKey = 'x-api-key';

@RestApi()
abstract class TChainAPI {
  factory TChainAPI(Dio dio, {String? baseUrl}) = _TChainAPI;

  factory TChainAPI.standard(String baseUrl) {
    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8000), // 8s
      receiveTimeout: const Duration(seconds: 8000), // 8s
      responseType: ResponseType.json,
    );

    Dio dio = Dio(options);

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ));

    return TChainAPI(dio);
  }

  @POST('/t-chain-sdk/generate-qrcode')
  Future<DataResponse<MerchantInfo>> generateQrCode({
    @Header(kApiKey) required String apiKey,
    @Body() required GenQrCodeBody body,
  });
}
