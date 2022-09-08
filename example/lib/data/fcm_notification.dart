class NotificationAction {
  final value;

  const NotificationAction._internal(this.value);

  toString() => 'Enum.$value';

  static const ReloadBalance = const NotificationAction._internal('balance');
  static const ShowEvent = const NotificationAction._internal('Tet-event'); // Show HongBao activity

  static getType(String value) {
    if (value == ReloadBalance.value) return ReloadBalance;
    return ShowEvent;
  }
}

class FcmNotification {
  NotificationAction? action;

  FcmNotification({
    this.action,
  });

  static const KEY_KEY = 'key';

  FcmNotification.fromMap(Map<String, dynamic> map) {
    action = NotificationAction.getType(map[KEY_KEY]);
  }
}
