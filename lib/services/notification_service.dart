import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    tz.initializeTimeZones();
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings(),
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,

      );
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      await _scheduleDailyNotification();
    }
  }

  static Future<void> _scheduleDailyNotification() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Recipe Suggestion',
      'Check out today\'s special recipe!',
      _nextInstanceOfTime(20, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Recipe Suggestions',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _showNotification(message);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'recipe_channel',
      'Recipe Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'New Recipe',
      message.notification?.body ?? 'Check out this new recipe!',
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  static Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }
}
