import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sharethegood/core/app_constant.dart';
import 'package:sharethegood/services/preferences.dart';
import 'fcm_notification.dart';



class FcmHelper {
  static String? uid = FirebaseAuth.instance.currentUser?.uid;

  static String? fcmToken = Preferences.getFcmToken();
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // TARGET MULTIPLE PLATFORMS
  static Map<String, dynamic> request = {
    "message": {
      "topic": "news",
      "notification": {
        "title": "Breaking News",
        "body": "New news story available."
      },
      "data": {"story_id": "story_12345"},
      "android": {
        "notification": {"click_action": "TOP_STORY_ACTIVITY"}
      },
      "apns": {
        "payload": {
          "aps": {"category": "NEW_MESSAGE_CATEGORY"}
        }
      }
    }
  };






  static Future<void> requestFcmPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  static Future<void> sendPushMessage(String? token, Map<String, dynamic> data) async {
    final Map<String, String> header = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${AppConstant.cloudMessagingApiKey}",
    };

    if (token == null) {
      debugPrint('Unable to send FCM message, no token exists.');
      return;
    }

    // // TARGET SPECIFIC DEVICE
    // final Map<String, dynamic> specificRequest = {
    //   "message": {
    //     "token": token,
    //     "notification": {
    //       "body": "this is an FCM notification message!",
    //       "title": "FCM Message"
    //     }
    //   }
    // };

    try {
      await http.post(
        Uri.parse(AppConstant.cloudMessagingServerEndpointUrl),
        headers: header,
        body: json.encode(data),
      );
      debugPrint('FCM request for device sent!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
