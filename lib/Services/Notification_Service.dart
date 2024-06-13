import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

  
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        // Handle notification tap
      },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle notification tap
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          print('Notification payload: $payload');
        }
      },
    );

    // Request iOS permissions
    requestIOSPermissions();
  }

  static Future<void> scheduleDailyNotification() async {
    print("Scheduling daily notification");
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Unique ID for this notification
      'Quote of the day', // Notification title
      'Check out today\'s inspiring quote!', // Notification body
      _nextInstanceOf3PM(), // Schedule time
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel', // Channel ID
          'Daily Notification', // Channel name
          channelDescription: 'Shows daily quote of the day', // Channel description
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Ensures the notification repeats daily
    );
  }

  static tz.TZDateTime _nextInstanceOf3PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20, 
      0, 
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static void requestIOSPermissions() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
