import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifaction_demo/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      "notification",
      "Demo Notification",
      priority: Priority.max,
      importance: Importance.max,
    );

    DarwinNotificationDetails iosDetail = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      iOS: iosDetail,
      android: androidDetails,
    );

    DateTime scheduleDate = DateTime.now().add(const Duration(seconds: 5));

    await notificationsPlugin.zonedSchedule(
        0,
        "Sample Notification",
        "this is notification Demo",
        TZDateTime.from(scheduleDate, local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: "payload data");
    notificationsPlugin.cancel(0);
    // await notificationsPlugin.schedule(
    //   0,
    //   "Sample Notification",
    //   "this is notification Demo",
    //   scheduleDate,
    //   notificationDetails,
    // );
    // await notificationsPlugin.show(
    //   0,
    //   "Sample Notification",
    //   "this is notification Demo",
    //   notificationDetails,
    // );
  }

  void checkFroNotification() async {
    NotificationAppLaunchDetails? details =
        await notificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;
        if (response != null) {
          String? payload = response.payload;
          log("Notification Payload : $payload");
        }
      }
    }
  }

  @override
  void initState() {
    checkFroNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        child: const Icon(Icons.notification_add),
      ),
      body: const Center(
        child: Text("Home Page"),
      ),
    );
  }
}
