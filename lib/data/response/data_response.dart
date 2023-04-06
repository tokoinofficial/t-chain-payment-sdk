import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/data/merchant_transaction.dart';
import 'package:t_chain_payment_sdk/data/response/t_chain_error.dart';

class DataResponse<T> {
  DataResponse({required this.result, this.error});

  final T? result;

  final TChainError? error;

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    final errorJson = json['error'] as Map<String, dynamic>?;
    TChainError? error;
    if (errorJson != null) {
      try {
        error = TChainError.fromJson(errorJson);
      } catch (_) {}
    }

    final resultJson = json['result'] as Map<String, dynamic>?;
    final dataJson = resultJson?['data'];
    T? result;
    bool isNotJson = dataJson is bool ||
        dataJson is int ||
        dataJson is String ||
        dataJson is double;
    if (isNotJson) {
      result = dataJson as T?;
    } else {
      try {
        var resultJson = dataJson as Map<String, dynamic>?;

        if (resultJson != null) {
          switch (T) {
            case MerchantInfo:
              result = MerchantInfo.fromJson(resultJson) as T;
              break;

            case MerchantTransaction:
              result = MerchantTransaction.fromJson(resultJson) as T;
              break;

            default:
              result = resultJson as T?;
          }
        } else {
          result = resultJson as T?;
        }
      } catch (_) {
        result = dataJson as T?;
      }
    }

    return DataResponse(result: result, error: error);
  }
}
