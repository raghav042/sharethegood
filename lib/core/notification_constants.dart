import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sharethegood/core/modal/notification_modal.dart';
import 'package:sharethegood/core/notification_constants.dart';

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<NotificationModal> didReceiveLocalNotificationStream = StreamController<NotificationModal>.broadcast();

final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

class NotificationConstants {
  NotificationConstants();

  // for android
  static int messageCount = 0;
  static const channelId = 'channelId';
  static const channelName = 'channelName';
  static const channelDescription = 'channelDescription';

  //for ios
  static const String urlLaunchActionId = 'id_1';
  static const String navigationActionId = 'id_3';
  static const String darwinNotificationCategoryText = 'textCategory';
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  // local notification
  static bool isNotificationInitialized = false;
  String? selectedNotificationPayload;

  static const channel = AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.high,
  );

  static const androidNotificationDetails = AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static const iosNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );

  static const notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );

  static const androidInitSettings = AndroidInitializationSettings('app_icon');

  static final iosInitSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        NotificationModal(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );

  static final initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: iosInitSettings,
  );

  static const MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');

  static const String portName = 'notification_send_port';

  static final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];
}
