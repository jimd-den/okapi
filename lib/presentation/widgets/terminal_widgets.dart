import 'package:flutter/material.dart';

class TerminalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const TerminalButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.labelLarge!,
          child: child,
        ),
      ),
    );
  }
}

class TerminalClickArea extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const TerminalClickArea({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.labelLarge!,
          child: child,
        ),
      ),
    );
  }
}

class MetricDisplay extends StatelessWidget {
  final String label;
  final String value;

  const MetricDisplay({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$label:', style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.lightGreenAccent),
        ),
      ],
    );
  }
}
