import 'package:equatable/equatable.dart';
import 'package:example/data/fcm_notification.dart';

class FcmState extends Equatable {
  final List<Object?>? objProps;

  const FcmState([this.objProps]);

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
