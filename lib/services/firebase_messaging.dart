import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'local_notification.dart';

@pragma('vm:entry-point')
Future<void> initializeFcm() async {
  //Request permission to receive messages
  // [https://firebase.google.com/docs/cloud-messaging/flutter/receive#request_permission_to_receive_messages_apple_and_web]

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  // Foreground messages
  // [https://firebase.google.com/docs/cloud-messaging/flutter/receive#foreground_messages]
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint('Message notification is: ${message.notification}');
    }
  });

  // Background Messages
  //[https://firebase.google.com/docs/cloud-messaging/flutter/receive#apple_platforms_and_android]
  FirebaseMessaging.onBackgroundMessage((message) async {
    await LocalNotification().setupFlutterNotifications();
    LocalNotification().showFlutterNotification(message);
    debugPrint("Handling a background message: ${message.messageId}");
  });
}

/*
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> getFcmToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    // TODO: If necessary send token to application server.

    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
  }).onError((err) {
    // Error getting token.
  });
}

Future<void> getFcmPermission() async {
  // Request permission to receive messages (Apple and Web)

  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint(
      'User granted permission: ${notificationSettings.authorizationStatus}');
}

@pragma('vm:entry-point')
Future<void> handleBackgroundFcm(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

Future<void> handleTerminatedFcm(RemoteMessage message) async {
  FirebaseMessaging.onBackgroundMessage(handleBackgroundFcm);

  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
}

void handleForegroundFcm() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
    }
  });
}

Future<void> handleTerminatedAppMessages() async {
  // Get any messages which caused the application to open from a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat", navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
}

void handleBackgroundAppMessages() {
  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void handleForegroundAppMessages() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
    }
  });
}

Future<void> initializeFcm() async {
  await getFcmPermission();
  getFcmToken();
  //FirebaseMessaging.onBackgroundMessage((message) {});
  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) {},
  );
  FirebaseMessaging.onMessage.listen((event) {});
  handleForegroundFcm();
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  debugPrint(message.data['type']);
  // if (message.data['type'] == 'chat') {
  //   Navigator.pushNamed(context, '/chat',
  //     arguments: ChatArguments(message),
  //   );
  // }
}

//==============================================================================


 */
