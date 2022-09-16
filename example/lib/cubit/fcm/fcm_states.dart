part of 'fcm_cubit.dart';

class FcmState extends Equatable {
  final List<Object?>? objProps;

  const FcmState([this.objProps]);

  @override
  List<Object?> get props => objProps ?? [];
}

class FcmUninitialized extends FcmState {
  @override
  String toString() => 'FcmUninitialized';
}

class FcmMessageReceived extends FcmState {
  final FcmNotification fcmNotification;

  FcmMessageReceived({required this.fcmNotification})
      : super([fcmNotification]);

  @override
  String toString() => 'FcmMessageReceived';
}

class FcmFinished extends FcmState {
  @override
  String toString() => 'FcmFinished';
}
