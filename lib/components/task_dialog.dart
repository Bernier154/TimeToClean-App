import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController daysIntervalController;
  late TextEditingController hoursIntervalController;
  late TextEditingController minutesIntervalController;
  late DateTime lastReset;

  @override
  void initState() {
    id = widget.task.title;
    lastReset = widget.task.lastReset;
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    daysIntervalController = TextEditingController(text: widget.task.interval.inDays.toString());
    hoursIntervalController = TextEditingController(text: (widget.task.interval - Duration(days: widget.task.interval.inDays)).inHours.toString());
    minutesIntervalController = TextEditingController(text: (widget.task.interval - Duration(days: widget.task.interval.inDays, hours: (widget.task.interval - Duration(days: widget.task.interval.inDays)).inHours)).inMinutes.toString());
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    daysIntervalController.dispose();
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
          TextFormField(controller: titleController),
          const SizedBox(height: 30),
          Text(
            'Description',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          TextFormField(controller: descriptionController),
          const SizedBox(height: 30),
          Text(
            'Interval',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  decoration: const InputDecoration(label: Text('Days')),
                  controller: daysIntervalController,
                  onChanged: (value) {
                    String filteredVal = (int.tryParse(daysIntervalController.text) ?? 0).toString();
                    daysIntervalController.text = filteredVal;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              Flexible(
                child: TextFormField(
                  decoration: const InputDecoration(label: Text('Hours')),
                  controller: hoursIntervalController,
                  onChanged: (value) {
                    String filteredVal = (int.tryParse(hoursIntervalController.text) ?? 0).toString();
                    hoursIntervalController.text = filteredVal;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              Flexible(
                child: TextFormField(
                  decoration: const InputDecoration(label: Text('Minutes')),
                  controller: minutesIntervalController,
                  onChanged: (value) {
                    String filteredVal = (int.tryParse(minutesIntervalController.text) ?? 0).toString();
                    minutesIntervalController.text = filteredVal;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
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
                    title: titleController.text,
                    description: descriptionController.text,
                    interval: Duration(
                      days: int.tryParse(daysIntervalController.text) ?? 1,
                      hours: int.tryParse(hoursIntervalController.text) ?? 1,
                      minutes: int.tryParse(minutesIntervalController.text) ?? 1,
                    ),
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
