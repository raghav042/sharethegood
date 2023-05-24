import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sharethegood/core/notification/received_notification.dart';
import 'notification_model.dart';


class NotificationHelper {
  const NotificationHelper._();

  static int id = 0;
  static bool isNotificationPermissionGranted = false;
  static bool isNotificationPluginInitialized = false;
  static List<ReceivedNotification> listReceivedNotification = [];


  static String? selectedNotificationPayload;
  /// A notification action which triggers a url launch event
  static const String urlLaunchActionId = 'id_1';
  /// A notification action which triggers a App navigation event
  static const String navigationActionId = 'id_3';
  /// Defines a iOS/MacOS notification category for text input actions.
  static const String darwinNotificationCategoryText = 'textCategory';
  /// Defines a iOS/MacOS notification category for plain actions.
  static const String darwinNotificationCategoryPlain = 'plainCategory';


  static final FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();
  static final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
  static final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();


  // MethodChannel FlutterLocalNotificationsPlugin
  static final AndroidFlutterLocalNotificationsPlugin? androidImplementation = notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  static final IOSFlutterLocalNotificationsPlugin? iOSImplementation = notificationPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  static final List<DarwinNotificationCategory> darwinNotificationCategories = <DarwinNotificationCategory>[
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

  // Initialization Settings
  static const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  static final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  static final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );
  static final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );

  //  Notification Details
  static const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'message',
    'message channel',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'text_id_1',
        'Enter Text',
        icon: DrawableResourceAndroidBitmap('food'),
        inputs: <AndroidNotificationActionInput>[
          AndroidNotificationActionInput(
            label: 'Enter a message',
          ),
        ],
      ),
    ],
  );
  static const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );
  static const LinuxNotificationDetails linuxNotificationDetails = LinuxNotificationDetails(
    actions: <LinuxNotificationAction>[
      LinuxNotificationAction(
        key: NotificationHelper.urlLaunchActionId,
        label: 'Action 1',
      ),
      LinuxNotificationAction(
        key: NotificationHelper.navigationActionId,
        label: 'Action 2',
      ),
    ],
  );
  static const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );



  static initNotificationStream(){
    //Widget screen(String? payload)
    checkNotificationPermission();
    requestNotificationPermissions();
    configureDidReceiveLocalNotificationSubject();
    configureSelectNotificationSubject();
  }

  static Future<void> checkNotificationPermission() async {
    if (Platform.isAndroid) {
      isNotificationPermissionGranted = await androidImplementation?.areNotificationsEnabled() ?? false;
      debugPrint("isNotificationPermissionGranted: $isNotificationPermissionGranted");
    }
  }

  static Future<void> requestNotificationPermissions() async {
    late bool? _isGranted;
       if(!isNotificationPermissionGranted) {
      if (Platform.isIOS) {
        _isGranted = await iOSImplementation?.requestPermissions(
          alert: true, badge: true, sound: true,);
      } else if (Platform.isAndroid) {
        _isGranted = await androidImplementation?.requestPermission();
      }
    }
    isNotificationPermissionGranted = _isGranted ?? false;
    debugPrint("isNotificationPermissionGranted: $isNotificationPermissionGranted");
  }

  static void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream.listen((ReceivedNotification receivedNotification) {
      listReceivedNotification.add(receivedNotification);
    });
  }

  static void configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      debugPrint(payload ?? "");
      // await Navigator.of(context).push(MaterialPageRoute<void>(
      //   builder: (BuildContext context) => screen(payload),
      // ));
    });
  }


  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    debugPrint('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      debugPrint('notification action tapped with input: ${notificationResponse.input}');
    }
  }

  static Future<void> initNotificationPlugin()async{
    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }



}
