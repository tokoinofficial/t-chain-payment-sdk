import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  SharedPreferences? _prefs;

  Future<String?> getPendingApprovalTxHash({
    required String walletAddress,
    required String contractAddress,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();
    String pendingApprovalKey = walletAddress + contractAddress;
    String? result = _prefs?.getString(pendingApprovalKey);
    return result;
  }

  setPendingApprovalTxHash({
    required String txHash,
    required String walletAddress,
    required String contractAddress,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();

    String pendingApprovalKey = walletAddress + contractAddress;
    await _prefs?.setString(pendingApprovalKey, txHash);
  }

  removePendingApprovalTxHash({
    required String walletAddress,
    required String contractAddress,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();

    String pendingApprovalKey = walletAddress + contractAddress;
    await _prefs?.remove(pendingApprovalKey);
  }
}
