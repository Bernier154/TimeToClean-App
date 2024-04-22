import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ttc_app/components/content_box.dart';
import 'package:ttc_app/models/task.dart';
import 'package:ttc_app/theme.dart';

class TaskDialog extends StatefulWidget {
  const TaskDialog({super.key, required this.task, this.create = false});

  final Task task;
  final bool create;

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late String id;
  late String title;
  late String description;
  late Duration interval;
  late DateTime lastReset;

  @override
  void initState() {
    id = widget.task.title;
    title = widget.task.title;
    description = widget.task.description;
    interval = widget.task.interval;
    lastReset = widget.task.lastReset;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: bgColor,
      child: ContentBox(
        title: [
          Text(
            'Time to clean',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w300),
          ),
          Text(
            widget.create ? 'Create timer' : 'Edit timer',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
        children: [
          const SizedBox(height: 30),
          Text(
            'Title',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          TextFormField(
            initialValue: title,
            onChanged: (value) => setState(() => title = value),
          ),
          const SizedBox(height: 30),
          Text(
            'Description',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          TextFormField(
            initialValue: description,
            onChanged: (value) => setState(() => description = value),
          ),
          const SizedBox(height: 30),
          Text(
            'Interval (days)',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          TextFormField(
            initialValue: interval.inDays.toString(),
            onChanged: (value) {
              try {
                interval = Duration(days: int.parse(value));
                return;
              } catch (exception) {
                log(exception.toString());
              }
              interval = Duration.zero;
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 20,
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(Task(
                    id: widget.task.id,
                    title: title,
                    description: description,
                    interval: interval,
                    lastReset: lastReset,
                  ));
                },
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
