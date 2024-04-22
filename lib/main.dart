import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ttc_app/components/content_box.dart';
import 'package:ttc_app/components/progress_card.dart';
import 'package:ttc_app/components/task_dialog.dart';
import 'package:ttc_app/models/task.dart';
import 'package:ttc_app/provider/task_provider.dart';
import 'package:ttc_app/theme.dart';
import 'package:timezone/data/latest_all.dart' as tz;

GlobalKey scaffoldKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (notificationResponse) {});

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TaskProvider taskProvider;
  Timer? timer;

  void showCreateDialog(Task task, bool create) async {
    dynamic res = await showDialog(
      context: scaffoldKey.currentContext!,
      builder: (context) => TaskDialog(
        task: task,
        create: create,
      ),
    );
    if (res != null) {
      taskProvider.createOrUpdate(res);
    }
  }

  @override
  void initState() {
    taskProvider = TaskProvider();
    taskProvider.fetch();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Time to clean',
        theme: appTheme,
        home: Builder(
          builder: (context) => Scaffold(
            backgroundColor: bgColor,
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () => showCreateDialog(Task.create(), true),
              backgroundColor: palePrimaryColor,
              foregroundColor: Colors.white,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: const Icon(Icons.add_task),
            ),
            body: ContentBox(
              title: [
                Text(
                  'Time to clean',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w300),
                ),
                Text(
                  'Your current timers',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
              children: [
                if (taskProvider.sortedTaskList.isEmpty)
                  Text(
                    'There are no task to display.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ...taskProvider.sortedTaskList.map((t) => ProgressCard(
                      key: Key('card#${t.id}'),
                      task: t,
                      onTap: (taskId) => showCreateDialog(t, false),
                      onDelete: taskProvider.deleteTask,
                      onReset: (taskId) {
                        taskProvider.save();
                        setState(() {});
                      },
                    ))
              ],
            ),
          ),
        ));
  }
}
