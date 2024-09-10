import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChaduckNotificationService {
  static final FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload != null) {
          print(details.payload);
        }
      },
    );

    await _requestPermissions();
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    print(id);
    print(title);
    print(body);
    print(payload);
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await notification
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await notification
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      notification.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
    }
  }
}