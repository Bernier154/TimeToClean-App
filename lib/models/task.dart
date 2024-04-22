import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ttc_app/helpers/pretty_duration.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;

class Task {
  String id = '';
  String title = '';
  String description = '';
  Duration interval = const Duration(days: 1);
  DateTime lastReset = DateTime.now();

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.interval,
    required this.lastReset,
  });

  Task.create() {
    Uuid uuid = const Uuid();
    id = uuid.v4();
  }

  Task.fromString(String dataString) {
    Map<String, dynamic> obj = jsonDecode(dataString) as Map<String, dynamic>;
    id = obj['id'];
    title = obj['title'];
    description = obj['description'];
    interval = Duration(seconds: obj['interval']);
    lastReset = DateTime.fromMillisecondsSinceEpoch(obj['lastReset']);
  }

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'title': title,
      'description': description,
      'interval': interval.inSeconds,
      'lastReset': lastReset.millisecondsSinceEpoch,
    });
  }

  DateTime get doItBy {
    return lastReset.copyWith().add(interval);
  }

  String get timeLeftPretty {
    if (progressDecimalPercent < 1) {
      return prettyDuration(doItBy.difference(DateTime.now()));
    }
    return 'TIME TO CLEAN';
  }

  double get progressDecimalPercent {
    Duration diff = doItBy.difference(DateTime.now());
    return max(0, min(1, 1 - (diff.inSeconds / interval.inSeconds)));
  }

  void reset() async {
    lastReset = DateTime.now();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    try {
      PendingNotificationRequest pending = pendingNotificationRequests.firstWhere((n) => n.payload == id);
      flutterLocalNotificationsPlugin.cancel(pending.id);
    } catch (e) {
      developer.log(e.toString());
    }

    Random random = Random();
    int notifId = random.nextInt(10000);

    flutterLocalNotificationsPlugin.zonedSchedule(
      notifId,
      'It has to be done.',
      'It\'s time to do: $title',
      tz.TZDateTime.now(tz.local).add(interval),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ttc.task',
          'TTC tasks',
          channelDescription: 'Notify timout tasks',
        ),
      ),
      payload: id,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
