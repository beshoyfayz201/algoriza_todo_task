import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/views/screens/schedule.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

List<String> repeateVals = ["none", "daily", "weekly", "mounthly"];

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  String initialRoute = "/";

  initNotification(BuildContext context) async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject(context);
    await _configureLocalTimeZone();

//tz.setLocalLocation(tz.getLocation(timeZoneName));
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('b');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? s) async {
      if (s != null) {
        debugPrint('notification payload: ' + s);
      }
      selectNotificationSubject.add(s!);
    });
  }

  void selectNotification(String payload, BuildContext context) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: ((context) => ScheduleScreen())),
    );
  }

  displayNotification(String title, String body) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin()
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  schedulNotification(
      int hours, int minutes, Task task, int remind, DateTime date) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      "Todo Note",
      task.title,

      //   tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),

      _nextInstanceOfTenAM(hours, minutes, remind, date),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int remind, DateTime date) {
    final tz.TZDateTime now = tz.TZDateTime.from(date, tz.local);
    final tz.TZDateTime fd = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);
    print(scheduledDate.year.toString() +
        "\n" +
        scheduledDate.month.toString() +
        "\n" +
        scheduledDate.day.toString() +
        "\n" +
        scheduledDate.hour.toString() +
        "\n" +
        scheduledDate.minute.toString() +
        "\n");

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    switch (remind) {
      case 0:
        scheduledDate = scheduledDate.subtract(Duration(days: 1));

        break;
      case 1:
        scheduledDate = scheduledDate.subtract(Duration(hours: 1));
        break;

      case 2:
        scheduledDate = scheduledDate.subtract(Duration(minutes: 30));

        break;
      case 3:
        scheduledDate = scheduledDate.subtract(Duration(minutes: 10));
        break;

      default:
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  void _configureSelectNotificationSubject(context) {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is ' + payload);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => ScheduleScreen())));
    });
  }
}
