import 'package:flutter/material.dart';

// Simple button with theme-aware styling
class SimpleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const SimpleButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
        child: child,
      ),
    );
  }
}

// Simple metric display with theme-aware styling
class MetricDisplay extends StatelessWidget {
  final String label;
  final String value;

  const MetricDisplay({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
