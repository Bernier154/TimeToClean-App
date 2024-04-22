import 'package:flutter/material.dart';

class Shaky extends StatefulWidget {
  const Shaky({super.key, required this.child});
  final Widget child;

  @override
  State<Shaky> createState() => _ShakyState();
}

class _ShakyState extends State<Shaky> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.repeat(reverse: true);
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.2).animate(_controller),
      child: widget.child,
    );
  }
}
