import 'package:flutter/material.dart';
import '../widgets/terminal_widgets.dart';
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
            icon: const Icon(Icons.settings, color: Colors.greenAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: ValueListenableBuilder(
            valueListenable: _controller.metrics,
            builder:
                (context, metrics, child) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  child: Row(
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
                        value: metrics.clicksPerMinute.toStringAsFixed(
                          3,
                        ), // Changed to 3 decimal places
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ValueListenableBuilder(
            valueListenable: _controller.settings,
            builder:
                (context, settings, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            settings.clickOptions
                                .map(
                                  (option) => Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: TerminalClickArea(
                                        onTap:
                                            () => _controller.incrementUnits(
                                              option,
                                            ),
                                        child: Center(
                                          child: Text(
                                            '+$option ${settings.workUnitLabel}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
