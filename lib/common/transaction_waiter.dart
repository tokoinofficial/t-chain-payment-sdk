class TransactionWaiter {
  static final TransactionWaiter _singleton = TransactionWaiter._internal();

  //
  // Average block time is 13 seconds
  // Based on etherscan at the time of writting,
  // https://etherscan.io/chart/blocktime
  //
  static const kWaitDuration = Duration(milliseconds: 29400);
  static const kWaitEverySecs = 5;
  Duration waitDuration = kWaitDuration;

  var _lastTransactionExecutedTime = DateTime.now();

  factory TransactionWaiter() {
    return _singleton;
  }

  TransactionWaiter._internal() {
    reset();
  }

  reset() {
    _lastTransactionExecutedTime = DateTime.now().subtract(waitDuration);
  }

  Future<dynamic> ready(Function func) async {
    var timeDiff = DateTime.now().difference(_lastTransactionExecutedTime);
    var timePassed = timeDiff.inMilliseconds >= waitDuration.inMilliseconds;

    if (!timePassed) {
      var duration = waitDuration - timeDiff;
      await Future.delayed(duration);
    }

    var result = await func();

    _lastTransactionExecutedTime = DateTime.now();

    return result;
  }

  Future<bool> waitUntil(Function func) async {
    var timeDiff = waitDuration;
    var timeDiffInSeconds = timeDiff.inSeconds;
    while (timeDiffInSeconds > 0) {
      timeDiffInSeconds = timeDiffInSeconds - kWaitEverySecs;
      await Future.delayed(const Duration(seconds: kWaitEverySecs));
      var passed = await func();
      if (passed) return true;
    }

    return false;
  }
}

final transactionWaiter = TransactionWaiter();
