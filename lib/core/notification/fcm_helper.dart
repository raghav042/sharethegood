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



  // TARGET SPECIFIC DEVICE
  final Map<String, dynamic> specificRequest = {
    "message": {
      "token": "token",
      "notification": {
        "body": "content",
        "title": "title"
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

  static Future<void> sendPushMessage({
    String? title,
    String? content}) async {
    final Map<String, String> header = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${AppConstant.cloudMessagingApiKey}",
    };

    // TARGET MULTIPLE PLATFORMS
     Map<String, dynamic> request = {
      "message": {
        "topic": "all",
        "notification": {
          "title": title ?? "title",
          "body": content ?? "content"
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

    // if (token == null) {
    //   debugPrint('Unable to send FCM message, no token exists.');
    //   return;
    // }



    try {
      await http.post(
        Uri.parse(AppConstant.cloudMessagingServerEndpointUrl),
        headers: header,
        body: json.encode(request),
      );
      debugPrint('FCM request for device sent!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
