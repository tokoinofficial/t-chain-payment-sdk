import 'package:equatable/equatable.dart';

class FcmState extends Equatable {
  final List<Object?>? objProps;

  const FcmState([this.objProps]);

  List<Object?> get props => objProps ?? [];
}

class FcmUninitialized extends FcmState {
  @override
  String toString() => 'FcmUninitialized';
}

class FcmReloadBalance extends FcmState {
  @override
  String toString() => 'FcmReloadBalance';
}

class FcmShowEvent extends FcmState {
  @override
  String toString() => 'FcmShowEvent';
}

class FcmFinished extends FcmState {
  @override
  String toString() => 'FcmFinished';
}
