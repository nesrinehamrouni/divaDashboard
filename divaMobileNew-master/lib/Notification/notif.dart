import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSetUp {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_launcher_icon',
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'Chat notifications',
          importance: NotificationImportance.Max,
          vibrationPattern: highVibrationPattern,
          channelShowBadge: true,
          channelDescription: 'Chat notifications.',
        ),
      ],
    );

    final bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> configurePushNotifications(BuildContext context) async {
    await initializeNotification();

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) await getIOSPermission();

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Received message: ${message.notification?.body}");
      if (message.notification != null) {
        await createOrderNotifications(
          title: message.notification!.title,
          body: message.notification!.body,
        );
      }

      // Increment notification counter
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = prefs.getInt('notification_counter') ?? 0;
      counter++;
      await prefs.setInt('notification_counter', counter);
      NotificationController.notificationCounter = counter;

      // Trigger a rebuild to update the notification badge
      NotificationController.notificationListener?.call();
    });

    // Get the token and send it to your server
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
      // TODO: Send this token to your server
    }

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      print("FCM Token refreshed: $token");
      // TODO: Send this refreshed token to your server
    });
  }

  Future<void> createOrderNotifications({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
      ),
    );
  }

  void eventListenerCallback(BuildContext context) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  Future<void> getIOSPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }
}

@pragma("vm:entry-point")
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class NotificationController {
  static int notificationCounter = 0;
  static VoidCallback? notificationListener;

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    print("Notification action received: ${receivedAction.id}");

  }
}