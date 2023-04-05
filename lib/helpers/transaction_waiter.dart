class TransactionWaiter {
  static final TransactionWaiter _singleton = TransactionWaiter._internal();

  //
  // Average block time is 13 seconds
  // Based on etherscan at the time of writting,
  // https://etherscan.io/chart/blocktime
  //
  static const WAIT_DURATION = Duration(milliseconds: 29400);
  static const WAIT_EVERY_SECS = 5;

  var _lastTransactionExecutedTime = DateTime.now();

  factory TransactionWaiter() {
    return _singleton;
  }

  TransactionWaiter._internal() {
    reset();
  }

  reset() {
    _lastTransactionExecutedTime = DateTime.now().subtract(WAIT_DURATION);
  }

  Future<dynamic> ready(Function func) async {
    var timeDiff = DateTime.now().difference(_lastTransactionExecutedTime);
    var timePassed = timeDiff.inMilliseconds >= WAIT_DURATION.inMilliseconds;

    if (!timePassed) {
      var waitDuration = WAIT_DURATION - timeDiff;
      await Future.delayed(waitDuration);
    }

    var result = await func();

    _lastTransactionExecutedTime = DateTime.now();

    return result;
  }

  Future<bool> waitUntil(Function func) async {
    var timeDiff = WAIT_DURATION;
    var timeDiffInSeconds = timeDiff.inSeconds;
    while (timeDiffInSeconds > 0) {
      timeDiffInSeconds = timeDiffInSeconds - WAIT_EVERY_SECS;
      await Future.delayed(const Duration(seconds: WAIT_EVERY_SECS));
      var passed = await func();
      if (passed) return true;
    }

    return false;
  }
}

final transactionWaiter = TransactionWaiter();
