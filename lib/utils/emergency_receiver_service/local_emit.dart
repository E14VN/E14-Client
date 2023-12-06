import 'dart:convert';
import 'package:e14_client/classes/location.dart';
import 'package:e14_client/utils/emergency_receiver_service/notification_logic.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationDetails androidPlatformSpecificsForFullScreenIntent =
    AndroidNotificationDetails("emergency_notification", "Thông báo khẩn cấp",
        playSound: true,
        category: AndroidNotificationCategory.alarm,
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true,
        visibility: NotificationVisibility.public,
        sound: RawResourceAndroidNotificationSound("ring"),
        fullScreenIntent: true,
        ledOnMs: 1000,
        ledOffMs: 500);

const AndroidNotificationDetails androidPlatformSpecificsForPushNotification =
    AndroidNotificationDetails("emergency_notification", "Thông báo khẩn cấp",
        playSound: true,
        category: AndroidNotificationCategory.message,
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true,
        visibility: NotificationVisibility.public,
        sound: RawResourceAndroidNotificationSound("ring"),
        fullScreenIntent: false,
        ledOnMs: 1000,
        ledOffMs: 500);

@pragma('vm:entry-point')
Future<void> emergencyPush(RemoteMessage details) async {
  EmergencyNotification? check = await shouldSendEmergencyNotification(
      LocationObject(double.parse(details.data["latitude"]),
          double.parse(details.data["longitude"])));

  if (check == null) return;
  if (check.notifyType == NotifyType.fullScreenIntent) {
    showFullScreenIntentNotification(jsonEncode({
      "fireLocation": {
        "latitude": check.fireLocation.latitude,
        "longitude": check.fireLocation.longitude,
        "locationApproximate": check.fireLocation.locationApproximate,
        "addressName": details.data["addressName"],
      }
    }));
  }
}

@pragma('vm:entry-point')
Future<void> showFullScreenIntentNotification(String payload) async {
  await flutterLocalNotificationsPlugin.show(
      0,
      "Báo cháy khẩn cấp",
      "Khu vực của bạn có báo cháy!",
      const NotificationDetails(
          android: androidPlatformSpecificsForFullScreenIntent),
      payload: payload);
}

@pragma('vm:entry-point')
Future<void> showPushNotification(String payload) async {
  await flutterLocalNotificationsPlugin.show(
      1,
      "Báo cháy khẩn cấp",
      "Khu vực của bạn có báo cháy!",
      const NotificationDetails(
          android: androidPlatformSpecificsForPushNotification),
      payload: payload);
}
