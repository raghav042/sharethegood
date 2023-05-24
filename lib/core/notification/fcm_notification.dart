import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/core/notification/notification_helper.dart';


void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    NotificationHelper.notificationPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationHelper.notificationDetails,
    );
  }
}

Future<void> handleMessage(RemoteMessage message) async{

  if(message.contentAvailable){
    debugPrint("data is: ${message.data}");
    showFlutterNotification(message);
    // if(message.data['type'] == 'chat'){
    //    Navigator.push(context, MaterialPageRoute(builder: (_)=> ConversationScreen(snapshot: snapshot)));
    // }
  }

  // var msg = await FirebaseMessaging.instance.getInitialMessage();
  // if(msg!.contentAvailable){
  //   showFlutterNotification(message);
  // }

  // debugPrint(message.data.toString());
  // showFlutterNotification(message);

  // if (message.data['type'] == 'chat') {
  //   Navigator.pushNamed(context, '/chat',
  //     arguments: ChatArguments(message),
  //   );
  // }
}


Future<void> onActionSelected(String value) async {
  switch (value) {
    case 'subscribe':
      {
        debugPrint(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
        );
        await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
        debugPrint(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
        );
      }
      break;
    case 'unsubscribe':
      {
        debugPrint(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
        );
        await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
        debugPrint(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
        );
      }
      break;
    case 'get_apns_token':
      {
        if (Platform.isIOS) {
          debugPrint('FlutterFire Messaging Example: Getting APNs token...');
          String? token = await FirebaseMessaging.instance.getAPNSToken();
          debugPrint('FlutterFire Messaging Example: Got APNs token: $token');
        } else {
          debugPrint(
            'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
          );
        }
      }
      break;
    default:
      break;
  }
}





