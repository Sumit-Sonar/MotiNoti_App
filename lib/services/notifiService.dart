import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context,
      {required NotificationService notificationService}) async {
    await _requestPermission();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('applogo');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        if (notificationResponse.payload == '/MotiQuotesUI') {
          Navigator.of(context).pushNamed(notificationResponse.payload!);
        }
      }
    });
  }

  Future<void> _requestPermission() async {
    var status = await Permission.notification.status;
    if (status != PermissionStatus.granted) {
      await Permission.notification.request();
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledNotificationDateTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      icon: 'applogo', // use your icon name without the file extension
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.zonedSchedule(
      id = 1,
      title,
      body,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '/MotiQuotesUI', // Set this to the route you want to navigate to
    );
  }

  Future<void> scheduleHourlyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledNotificationDateTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      icon: 'applogo', // use your icon name without the file extension
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.periodicallyShow(
      id = 2,
      title,
      body,
      RepeatInterval.hourly,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,

      payload: '/MotiQuotesUI', // Set this to the route you want to navigate to
    );
  }

  Future<void> stopHourlyNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
