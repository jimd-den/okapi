import 'package:flutter/material.dart';
import '../widgets/simple_widgets.dart';
import 'app.dart';
import 'settings_screen.dart';
import 'work_screen_controller.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late final WorkScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WorkScreenController(workService, settingsService);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: _controller.settings,
          builder:
              (context, settings, child) => Text(settings.workInProgressLabel),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Metrics display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ValueListenableBuilder(
              valueListenable: _controller.metrics,
              builder:
                  (context, metrics, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MetricDisplay(
                        label: 'Time',
                        value: _formatTime(metrics.elapsedTime),
                      ),
                      MetricDisplay(
                        label: 'Units',
                        value: '${metrics.totalUnits}',
                      ),
                      MetricDisplay(
                        label: 'Units/min',
                        value: metrics.clicksPerMinute.toStringAsFixed(3),
                      ),
                    ],
                  ),
            ),
          ),
          // Click buttons
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _controller.settings,
              builder:
                  (context, settings, child) => ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: settings.clickOptions.length,
                    itemBuilder: (context, index) {
                      final option = settings.clickOptions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _controller.incrementUnits(option),
                          child: Text('+$option ${settings.workUnitLabel}'),
                        ),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
