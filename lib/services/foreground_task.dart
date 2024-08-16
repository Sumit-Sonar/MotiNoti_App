import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:motinoti_app/services/notifiService.dart';

void startForegroundTask(NotificationService notificationService) {
  FlutterForegroundTask.startService(
      notificationTitle: 'Lost In Phone?',
      notificationText: "Checkout this post by...",
      callback: foregroundcallback);
}

void foregroundcallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

class ForegroundTaskHandler extends TaskHandler {
  NotificationService? notificationService;

  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // Perform repeated tasks here if needed
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // Clean up tasks here if needed
  }

  void onButtonPressed(String id) {
    // Handle button press event here if needed
  }

  @override
  void onNotificationPressed() {
    // Handle notification press event here if needed
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onRepeatEvent
  }

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) {
    notificationService = NotificationService();
    scheduleHourlyNotifications();
  }

  void scheduleHourlyNotifications() {
    final now = DateTime.now();
    for (int i = 0; i < 24; i++) {
      final scheduledTime = DateTime(now.year, now.month, now.day, now.hour + i);
      notificationService?.scheduleHourlyNotification(
        id: i,
        title: 'Hey! Lost in phone?',
        body: 'Checkout this quote by...', scheduledNotificationDateTime: scheduledTime,
      );
    }
  }
}
