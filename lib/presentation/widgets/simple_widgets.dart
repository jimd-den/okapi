import 'package:flutter/material.dart';

// Simple button without custom styling
class SimpleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const SimpleButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: child);
  }
}

// Simple metric display without custom styling
class MetricDisplay extends StatelessWidget {
  final String label;
  final String value;

  const MetricDisplay({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(label), Text(value)]);
  }
}
