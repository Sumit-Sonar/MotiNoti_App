import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:motinoti/services/notifiService.dart';

void startForegroundTask(NotificationService notificationService) {
  FlutterForegroundTask.startService(
    notificationTitle: 'Lost In Phone?',
    notificationText: "Checkout this post by...",
    callback: foregroundcallback,
  );
}

void foregroundcallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

class ForegroundTaskHandler extends TaskHandler {
  NotificationService? notificationService;

  @override
  void onStart(DateTime timestamp) {
    notificationService = NotificationService();
    scheduleHourlyNotifications();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Perform repeated tasks here if needed
  }

  @override
  void onDestroy(DateTime timestamp) {
    // Clean up tasks here if needed
  }

  @override
  void onNotificationButtonPressed(String id) {
    // Handle button press event here if needed
  }

  @override
  void onNotificationPressed() {
    // Handle notification press event here if needed
  }

  @override
  void onNotificationDismissed() {
    // Handle notification dismiss event here if needed
  }

  void scheduleHourlyNotifications() {
    final now = DateTime.now();
    for (int i = 0; i < 24; i++) {
      final scheduledTime = DateTime(now.year, now.month, now.day, now.hour + i);
      notificationService?.scheduleHourlyNotification(
        id: i,
        title: 'Hey! Lost in phone?',
        body: 'Checkout this quote by...',
        scheduledNotificationDateTime: scheduledTime,
      );
    }
  }
}
