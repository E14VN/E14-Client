import 'package:e14_client/utils/emergency_receiver_service/local_emit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FireCloudMessaging {
  final fireBaseMessage = FirebaseMessaging.instance;
  late String fireBaseMessageToken;

  initialize() async {
    await fireBaseMessage.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    await fireBaseMessage.requestPermission();

    fireBaseMessage.subscribeToTopic("emergency_service_receiver");

    fireBaseMessageToken = (await fireBaseMessage.getToken()) ?? "";

    FirebaseMessaging.onBackgroundMessage(emergencyPush);
    FirebaseMessaging.onMessage.listen(emergencyPush);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }
}
