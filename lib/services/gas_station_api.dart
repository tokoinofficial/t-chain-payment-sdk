import 'package:dio/dio.dart';

class GasStationAPI {
  static const int kGasStationConversionNumber =
      10; // https://docs.ethgasstation.info/gas-price
  static const int kGweiToWei =
      1000000000; // https://academy.binance.com/en/glossary/wei
  late Dio _dio;

  GasStationAPI() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 6000); //6s
    _dio.options.receiveTimeout = const Duration(seconds: 4000);
    _dio.options.responseType = ResponseType.json;

    _dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      handler.next(options);
    }, onResponse:
        (Response response, ResponseInterceptorHandler handler) async {
      handler.next(response);
    }, onError: (DioError e, ErrorInterceptorHandler handler) async {
      handler.next(e);
    }));
  }

  Future<Response> getBscGas() async {
    return await _dio
        .get("https://api.bscscan.com/api?module=proxy&action=eth_gasPrice");
  }
}
