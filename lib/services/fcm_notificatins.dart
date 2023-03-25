// Crude counter to make messages unique
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

int _messageCount = 0;
String? _token;

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String? token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}
Future<void> sendPushMessage() async {
  if (_token == null) {
    debugPrint('Unable to send FCM message, no token exists.');
    return;
  }

  try {

    // FirebaseMessaging.instance.sendMessage(
    //   to:
    // );

    await http.post(
      Uri.parse('https://api.rnfirebase.io/messaging/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: constructFCMPayload(_token),
    );
    debugPrint('FCM request for device sent!');
  } catch (e) {
    debugPrint(e.toString());
  }
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
