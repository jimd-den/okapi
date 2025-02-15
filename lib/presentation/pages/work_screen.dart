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
  bool _showUnitsPerHour = false;

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

  String _formatUnitsRate(double unitsPerMinute) {
    if (_showUnitsPerHour) {
      return (unitsPerMinute * 60).toStringAsFixed(1);
    }
    return unitsPerMinute.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: _controller.settings,
          builder:
              (context, settings, child) => Text(
                settings.workTaskerLabel,
                style: theme.textTheme.titleLarge,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.colorScheme.onBackground),
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
          Container(
            padding: const EdgeInsets.all(16.0),
            color: theme.colorScheme.surface,
            child: ValueListenableBuilder(
              valueListenable: _controller.settings,
              builder:
                  (context, settings, child) => ValueListenableBuilder(
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
                              label: settings.workUnitLabel,
                              value: '${metrics.totalUnits}',
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showUnitsPerHour = !_showUnitsPerHour;
                                });
                              },
                              child: MetricDisplay(
                                label:
                                    _showUnitsPerHour
                                        ? '${settings.workUnitLabel}/hr'
                                        : '${settings.workUnitLabel}/min',
                                value: _formatUnitsRate(
                                  metrics.clicksPerMinute,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _controller.settings,
              builder:
                  (context, settings, child) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: theme.elevatedButtonTheme.style,
                                onPressed: () => _controller.incrementUnits(1),
                                child: Text(
                                  '+1 ${settings.workUnitLabel}',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: theme.elevatedButtonTheme.style,
                              onPressed:
                                  () => _controller.incrementUnits(
                                    settings.multiClickValue,
                                  ),
                              child: Text(
                                '+${settings.multiClickValue} ${settings.workUnitLabel}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
