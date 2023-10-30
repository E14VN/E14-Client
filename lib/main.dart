import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'classes/location.dart';
import 'screens/emergency/receive.dart';
import 'providers/credentials.dart';
import 'utils/emergency_receiver_service/fcm_receiver.dart';
import 'utils/emergency_receiver_service/local_emit.dart';
import 'screens/home.dart';
import 'screens/register.dart';
import 'firebase_options.dart';

enum LaunchFlag { normal, emergency }

@pragma('vm:entry-point')
ValueNotifier<LaunchFlag> launchFlag =
    ValueNotifier<LaunchFlag>(LaunchFlag.normal);

dynamic payload = "";

@pragma('vm:entry-point')
launchEmergency(NotificationResponse details) {
  launchFlag.value = LaunchFlag.emergency;
  payload = jsonDecode(details.payload ?? "{}") ?? {};
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var locationPermission = Permission.locationWhenInUse;
  if (await locationPermission.request() ==
      PermissionStatus.permanentlyDenied) {
    Fluttertoast.showToast(msg: "Quyền vị trí bị chặn!");
    Geolocator.openLocationSettings();
  }

  var notificationPermission = Permission.notification;
  if (await notificationPermission.request() ==
      PermissionStatus.permanentlyDenied) {
    Fluttertoast.showToast(msg: "Quyền thông báo bị chặn!");
    openAppSettings();
  }

  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('mipmap/ic_launcher'));
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: launchEmergency,
      onDidReceiveNotificationResponse: launchEmergency);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails != null &&
      notificationAppLaunchDetails.didNotificationLaunchApp &&
      notificationAppLaunchDetails.notificationResponse != null) {
    launchEmergency(notificationAppLaunchDetails.notificationResponse!);
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FireCloudMessaging().initialize();

  runApp(const E14Client());
}

class E14Client extends StatelessWidget {
  const E14Client({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => Credentials())],
        builder: (context, _) => MaterialApp(
            theme: ThemeData(
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                      transitionType: SharedAxisTransitionType.horizontal),
                  TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                      transitionType: SharedAxisTransitionType.horizontal)
                }),
                colorSchemeSeed: Colors.deepPurple,
                useMaterial3: true),
            darkTheme: ThemeData(
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                      transitionType: SharedAxisTransitionType.horizontal),
                  TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                      transitionType: SharedAxisTransitionType.horizontal)
                }),
                brightness: Brightness.dark,
                colorSchemeSeed: Colors.deepPurple,
                useMaterial3: true),
            themeMode: ThemeMode.system,
            home: ValueListenableBuilder(
                valueListenable: launchFlag,
                builder: (context, _, __) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  return launchFlag.value == LaunchFlag.normal
                      ? Consumer<Credentials>(
                          builder: (context, credentials, _) {
                          if (credentials.initialized) {
                            if (credentials.info.registered!) {
                              return const HomePage();
                            }
                            return const Register();
                          }
                          return Container();
                        })
                      : EmergencyShowMap(
                          fireCircle: LocationObject(
                              payload["fireLocation"]["latitude"],
                              payload["fireLocation"]["longitude"],
                              locationApproximate: payload["fireLocation"]
                                  ["locationApproximate"]));
                })));
  }
}
