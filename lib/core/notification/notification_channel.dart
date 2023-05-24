import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannel {
  static const chatChannel = AndroidNotificationChannel(
    'chatChannel', // id
    'Chat Notifications', // title
    description: 'This channel is used for chat notifications.',
    importance: Importance.high,
    playSound: true,
  );

  static const defaultChannel = AndroidNotificationChannel(
    'defaultChannel', // id
    'Default Notifications', // title
    description: 'This channel is used for default notifications.',
    importance: Importance.defaultImportance,
  );

  static const promotionChannel = AndroidNotificationChannel(
    'promotionChannel', // id
    'Promotional Notifications', // title
    description: 'This channel is used for promotion and user engagement notifications.',
    importance: Importance.min,
    playSound: true,
  );
}
