// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'dart:convert';
// import 'dart:io';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async {
//     print("Notification receive");
//   }

//   static Future<void> init() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings("@mipmap/ic_launcher");

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotification,
//       onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//   }

//  static Future<void> showInstantNotification(String title, String body) async {
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: AndroidNotificationDetails(
//           'instant_notification_channel_id',
//           'Instant Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'instant_notification',
//     );
//   }

//   static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'reminder_channel',
//           'Reminder Channel',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.dateAndTime,
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//     );
//   }
// }