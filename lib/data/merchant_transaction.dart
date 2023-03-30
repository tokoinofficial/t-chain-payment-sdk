class MerchantTransaction {
  final String transactionID;
  final String offchain;
  final double amount;
  final String amountUint256;
  final double fee;
  final String feeUint256;
  final String signedHash;
  final int expiredTime;
  final double rate;

  MerchantTransaction({
    required this.transactionID,
    required this.offchain,
    required this.amount,
    required this.amountUint256,
    required this.fee,
    required this.feeUint256,
    required this.signedHash,
    required this.expiredTime,
    required this.rate,
  });

  static const KEY_TRANSACTION_ID = 'transaction_id';
  static const KEY_OFFCHAIN = 'offchain';
  static const KEY_AMOUNT = 'amount';
  static const KEY_AMOUNT_UINT_256 = 'amount_usd_big';
  static const KEY_SIGNED_HASH = 'signed_hash';
  static const KEY_EXPIRED_TIME = 'expired_time';
  static const KEY_FEE = 'fee';
  static const KEY_FEE_UINT_256 = 'fee_uint_256';
  static const KEY_RATE = 'rate';

  factory MerchantTransaction.fromMap(Map<String, dynamic> map) {
    double amount = double.tryParse(map[KEY_AMOUNT].toString()) ?? 0;
    double fee = double.tryParse(map[KEY_FEE].toString()) ?? 0;

    return MerchantTransaction(
      transactionID: map[KEY_TRANSACTION_ID] as String? ?? '',
      offchain: map[KEY_OFFCHAIN] as String? ?? '',
      amount: amount,
      amountUint256: map[KEY_AMOUNT_UINT_256] as String? ?? '',
      fee: fee,
      feeUint256: map[KEY_FEE_UINT_256] as String? ?? '',
      signedHash: map[KEY_SIGNED_HASH] as String? ?? '',
      expiredTime: map[KEY_EXPIRED_TIME] as int? ?? 0,
      rate: map[KEY_RATE] as double? ?? 0,
    );
  }

  MerchantTransaction copyWith({
    String? transactionID,
    String? offchain,
    double? amount,
    String? amountUint256,
    double? fee,
    String? feeUint256,
    String? signedHash,
    int? expiredTime,
    double? rate,
  }) =>
      MerchantTransaction(
        transactionID: transactionID ?? this.transactionID,
        offchain: offchain ?? this.offchain,
        amount: amount ?? this.amount,
        amountUint256: amountUint256 ?? this.amountUint256,
        fee: fee ?? this.fee,
        feeUint256: feeUint256 ?? this.feeUint256,
        signedHash: signedHash ?? this.signedHash,
        expiredTime: expiredTime ?? this.expiredTime,
        rate: rate ?? this.rate,
      );

  Map<String, dynamic> toJson() => {
        KEY_TRANSACTION_ID: transactionID,
        KEY_OFFCHAIN: offchain,
        KEY_AMOUNT: amount,
        KEY_AMOUNT_UINT_256: amountUint256,
        KEY_FEE: fee,
        KEY_FEE_UINT_256: feeUint256,
        KEY_SIGNED_HASH: signedHash,
        KEY_EXPIRED_TIME: expiredTime,
        KEY_RATE: rate,
      };
}
