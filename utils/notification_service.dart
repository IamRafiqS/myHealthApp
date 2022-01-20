import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:my_health/models/user_notification.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "123";

  Future<void> init() async {

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid, iOS: null, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    tz.initializeTimeZones();
    String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    debugPrint('Timezone is: ' + currentTimeZone);
  }

  Future selectNotification(String? payload) async {

  }

  void showNotification(UserNotification userNotification) async {
    await flutterLocalNotificationsPlugin.show(
        userNotification.hashCode,
        'MyHealth',
        'Don\'t forget to update you Daily Health Data!',
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, 'MyHealth',
                'To remind you about upcoming birthdays')
        ),
        payload: jsonEncode(userNotification.hashCode)
    );
  }

  Future<void> scheduleNotification(UserNotification userNotification, String notificationMessage) async {
    DateTime now = DateTime.now();
    DateTime notificationTime = userNotification.timeOfDay;
    Duration difference = now.isAfter(notificationTime)
        ? now.difference(notificationTime)
        : notificationTime.difference(now);

    _wasApplicationLaunchedFromNotification()
        .then((bool didApplicationLaunchFromNotification) => {
      if (didApplicationLaunchFromNotification && difference.inDays == 0) {
        scheduleNotificationForNextDay(userNotification)}
      else if (!didApplicationLaunchFromNotification && difference.inDays == 0) {
        showNotification(userNotification)}
    });

    await flutterLocalNotificationsPlugin.zonedSchedule(
        userNotification.hashCode,
        'MyHealth',
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(difference),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, 'MyHealth',
                'To remind you about upcoming birthdays')),
        payload: jsonEncode(userNotification),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  void scheduleNotificationForNextDay(UserNotification userBirthday) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        userBirthday.hashCode,
        'MyHealth',
        'Don\'t forget to update you Daily Health Data!',
        tz.TZDateTime.now(tz.local).add(new Duration(days: 1)),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, 'MyHealth',
                'To remind you for upcoming days')),
        payload: jsonEncode(userBirthday),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotification(UserNotification userNotification) async {
    await flutterLocalNotificationsPlugin.cancel(userNotification.hashCode);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    return notificationAppLaunchDetails!.didNotificationLaunchApp;
  }
}


