import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:sharethegood/core/notification/fcm_helper.dart';
import 'package:sharethegood/core/notification/fcm_notification.dart';
import 'package:sharethegood/core/notification/notification_helper.dart';
import 'package:sharethegood/services/preferences.dart';
import 'app.dart';
import 'services/firebase_crashlytics.dart';
import 'services/system_style.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  handleMessage(message);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  catchError();
  await Preferences.initPreferences();
  await NotificationHelper.initNotificationStream();
  await FcmHelper.requestFcmPermission();

  await FirebaseMessaging.instance.subscribeToTopic("all");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((event) => handleMessage(event));
  FirebaseMessaging.onMessage.listen((event) => handleMessage(event));

  setUIStyle();
  runApp(const Application());
}