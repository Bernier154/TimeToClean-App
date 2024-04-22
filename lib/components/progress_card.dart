import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ttc_app/components/shaky.dart';
import 'package:ttc_app/main.dart';
import 'package:ttc_app/models/task.dart';
import 'package:ttc_app/theme.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({
    super.key,
    required this.task,
    this.onDelete,
    this.onReset,
    this.onTap,
  });

  final Task task;
  final Function(String)? onDelete;
  final Function(String)? onReset;
  final Function(String)? onTap;

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  double bgOpacity = 0;
  Duration updateFrequency = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDismissUpdate(DismissUpdateDetails details) {
    setState(() {
      bgOpacity = details.progress;
    });
  }

  Future<bool?> confirmDismiss(DismissDirection dir) async {
    return await showDialog(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Delete timer"),
        content: Text("Are you sure you want to delete the timer: ${widget.task.title}?"),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete timer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Dismissible(
        direction: DismissDirection.endToStart,
        onUpdate: onDismissUpdate,
        key: Key(widget.task.id),
        confirmDismiss: confirmDismiss,
        onDismissed: (DismissDirection dir) => widget.onDelete != null ? widget.onDelete!(widget.task.id) : null,
        background: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: bgOpacity,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Shaky(
                      child: Icon(
                        Icons.delete,
                        color: Colors.redAccent.shade700,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 50),
          opacity: 1 - bgOpacity,
          child: Card.filled(
            color: palePrimaryColor,
            margin: const EdgeInsets.symmetric(vertical: 10),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => widget.onTap != null ? widget.onTap!(widget.task.id) : null,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Wrap(
                            children: [
                              Text(
                                widget.task.title,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white, height: 1),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          visualDensity: VisualDensity.compact,
                          iconSize: 25,
                          onPressed: () {
                            widget.task.reset();
                            if (widget.onReset != null) {
                              widget.onReset!(widget.task.id);
                            }
                          },
                          icon: const Icon(Icons.replay),
                          color: Colors.white,
                        )
                      ],
                    ),
                    if (widget.task.description != '')
                      Text(
                        widget.task.description,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
                      ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        LinearProgressIndicator(
                          backgroundColor: const Color.fromARGB(50, 10, 56, 28),
                          color: Colors.white,
                          minHeight: 30,
                          value: widget.task.progressDecimalPercent,
                        ),
                        Positioned(
                          right: 15,
                          height: 30,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.task.timeLeftPretty,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      // color: Theme.of(context).primaryColor,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
