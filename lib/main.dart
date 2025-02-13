import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const WorkClickerApp());
}

/// The main application widget for the Work Clicker app.
class WorkClickerApp extends StatelessWidget {
  const WorkClickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Tasker',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.greenAccent,
          titleTextStyle: TextStyle(color: Colors.greenAccent, fontSize: 22, fontFamily: 'monospace'),
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 70, // Increased AppBar height to accommodate metrics
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.greenAccent, fontFamily: 'monospace'),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent, fontFamily: 'monospace'),
          labelLarge: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 16),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.lightGreenAccent, fontFamily: 'monospace'),
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'monospace'),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
        ),
      ),
      home: const StartScreen(),
    );
  }
}

// **--- Data Layer ---**

/// In-memory data source for work-related data.
class InMemoryWorkDataSource {
  int totalUnits = 0;
  DateTime? startTime;
  List<DateTime> clickTimestamps = [];

  void startWork() {
    startTime = DateTime.now();
    totalUnits = 0;
    clickTimestamps = [];
  }

  void incrementUnits(int count) {
    for (int i = 0; i < count; i++) {
      totalUnits++;
      clickTimestamps.add(DateTime.now());
    }
  }

  WorkData getWorkData() {
    return WorkData(
      totalUnits: totalUnits,
      startTime: startTime,
      clickTimestamps: clickTimestamps,
    );
  }
}

/// Represents the work data model.
class WorkData {
  final int totalUnits;
  final DateTime? startTime;
  final List<DateTime> clickTimestamps;

  WorkData({
    required this.totalUnits,
    required this.startTime,
    required this.clickTimestamps,
  });
}

// **--- Domain Layer ---**

/// Service class for handling work-related logic and calculations.
class WorkService {
  final InMemoryWorkDataSource _dataSource;

  WorkService(this._dataSource);

  void startWork() {
    _dataSource.startWork();
  }

  void clickUnit(int count) {
    _dataSource.incrementUnits(count);
  }

  WorkMetrics getWorkMetrics() {
    final data = _dataSource.getWorkData();
    return _calculateMetrics(data);
  }

  WorkMetrics _calculateMetrics(WorkData data) {
    double clicksPerMinute = 0;
    int totalUnits = data.totalUnits;
    Duration elapsedTime = data.startTime != null ? DateTime.now().difference(data.startTime!) : Duration.zero;

    if (elapsedTime.inMinutes > 0 && totalUnits > 0) {
      clicksPerMinute = totalUnits / elapsedTime.inMinutes;
    } else if (totalUnits > 0 && elapsedTime.inSeconds > 0) {
      clicksPerMinute = (totalUnits * 60) / elapsedTime.inSeconds;
    } else {
      clicksPerMinute = 0;
    }

    return WorkMetrics(
      totalUnits: totalUnits,
      clicksPerMinute: clicksPerMinute,
      elapsedTime: elapsedTime,
    );
  }
}

/// Represents the work metrics model.
class WorkMetrics {
  final int totalUnits;
  final double clicksPerMinute;
  final Duration elapsedTime;

  WorkMetrics({
    required this.totalUnits,
    required this.clicksPerMinute,
    required this.elapsedTime,
  });
}

// **--- Settings Domain and Data ---**

/// Represents the settings data model.
class SettingsData {
  String workUnitLabel;
  String tasksButtonLabel;
  String cpmLabel;
  String timeLabel;
  String startWorkdayLabel;
  String workInProgressLabel;
  String workTaskerLabel;
  String readyToWorkLabel;
  List<int> clickOptions;

  SettingsData({
    this.workUnitLabel = 'Units',
    this.tasksButtonLabel = 'Tasks',
    this.cpmLabel = 'Units/min',
    this.timeLabel = 'Time',
    this.workInProgressLabel = 'Work in Progress!',
    this.workTaskerLabel = 'Work Tasker',
    this.startWorkdayLabel = 'Start Workday!',
    this.readyToWorkLabel = 'Ready to get to work?',
    this.clickOptions = const [1, 5, 10, 25, 50, 100], // Up to 6 click options
  });

  SettingsData copyWith({
    String? workUnitLabel,
    String? tasksButtonLabel,
    String? cpmLabel,
    String? timeLabel,
    String? startWorkdayLabel,
    String? workInProgressLabel,
    String? workTaskerLabel,
    String? readyToWorkLabel,
    List<int>? clickOptions,
  }) {
    return SettingsData(
      workUnitLabel: workUnitLabel ?? this.workUnitLabel,
      tasksButtonLabel: tasksButtonLabel ?? this.tasksButtonLabel,
      cpmLabel: cpmLabel ?? this.cpmLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      startWorkdayLabel: startWorkdayLabel ?? this.startWorkdayLabel,
      workInProgressLabel: workInProgressLabel ?? this.workInProgressLabel,
      workTaskerLabel: workTaskerLabel ?? this.workTaskerLabel,
      readyToWorkLabel: readyToWorkLabel ?? this.readyToWorkLabel,
      clickOptions: clickOptions ?? this.clickOptions,
    );
  }
}

/// Simple in-memory settings service.
class SettingsService {
  final ValueNotifier<SettingsData> settingsNotifier = ValueNotifier(SettingsData());

  ValueNotifier<SettingsData> get settings => settingsNotifier;

  void updateSettings(SettingsData newSettings) {
    settingsNotifier.value = newSettings;
    settingsNotifier.notifyListeners();
  }
}

// **--- Controllers Layer ---**

/// Controller for the Work Screen.
class WorkScreenController {
  final WorkService _workService;
  final SettingsService _settingsService;
  final ValueNotifier<WorkMetrics> metrics = ValueNotifier(WorkMetrics(totalUnits: 0, clicksPerMinute: 0, elapsedTime: Duration.zero));
  Timer? _timer;

  WorkScreenController(this._workService, this._settingsService);

  void initialize() {
    _workService.startWork();
    startTimer();
  }

  void dispose() {
    _timer?.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateMetrics();
    });
  }

  void updateMetrics() {
    metrics.value = _workService.getWorkMetrics();
  }

  void incrementUnits(int count) {
    _workService.clickUnit(count);
    updateMetrics();
  }
}

/// Controller for the Settings Screen.
class SettingsScreenController {
  final SettingsService _settingsService;

  SettingsScreenController(this._settingsService);

  ValueNotifier<SettingsData> get settings => _settingsService.settings;

  void updateSettings(SettingsData newSettings) {
    _settingsService.updateSettings(newSettings);
  }
}


// **--- Presentation Layer ---**

/// **--- Views ---**

/// Start screen of the application (Presentation Layer - View).
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ValueListenableBuilder<SettingsData>(
        valueListenable: settingsService.settings,
        builder: (context, settings, child) => Text(settings.workTaskerLabel),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<SettingsData>(
              valueListenable: settingsService.settings,
              builder: (context, settings, child) => Text(
                settings.readyToWorkLabel,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _TerminalButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WorkScreen()),
                );
              },
              child: ValueListenableBuilder<SettingsData>(
                valueListenable: settingsService.settings,
                builder: (context, settings, child) => Text(settings.startWorkdayLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main work screen - ASCII Terminal Style (Presentation Layer - View).
class WorkScreen extends StatefulWidget {
  WorkScreen({super.key});

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late final WorkScreenController _controller;
  // Removed scale notifiers
  // final ValueNotifier<double> _unitsScaleNotifier = ValueNotifier<double>(1.0);
  // final ValueNotifier<double> _cpmScaleNotifier = ValueNotifier<double>(1.0);
  // final ValueNotifier<double> _timerScaleNotifier = ValueNotifier<double>(1.0);
  // Removed button color notifiers
  // final List<ValueNotifier<Color>> _buttonColorNotifiers = []; // List of notifiers for each button

  @override
  void initState() {
    super.initState();
    _controller = WorkScreenController(workService, settingsService);
    _controller.initialize();
    // Removed color notifier initialization
    // _buttonColorNotifiers.addAll(List.generate(settingsService.settings.value.clickOptions.length, (_) => ValueNotifier<Color>(Colors.transparent)));
  }

  @override
  void dispose() {
    _controller.dispose();
    // Removed notifier disposal
    // _unitsScaleNotifier.dispose();
    // _cpmScaleNotifier.dispose();
    // _timerScaleNotifier.dispose();
    // for (final notifier in _buttonColorNotifiers) {
    //   notifier.dispose();
    // }
    super.dispose();
  }

  void _incrementUnits(int index, int count) { // Pass index of button clicked
    _controller.incrementUnits(count);
    // Removed animation calls
    // _animateMetricPop(_unitsScaleNotifier);
    // _animateButtonColorFlash(index); // Flash only clicked button
  }

  void _incrementUnitsByPreset(int index, int count) { // Pass index to preset increment
    _incrementUnits(index, count);
  }

  // Removed animation methods
  // void _animateMetricPop(ValueNotifier<double> notifier) {
  //   notifier.value = 1.2;
  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     notifier.value = 1.0;
  //   });
  // }

  // void _animateButtonColorFlash(int index) {
  //   if (index >= 0 && index < _buttonColorNotifiers.length) { // Check index validity
  //     _buttonColorNotifiers[index].value = Colors.white.withOpacity(0.2); // Quick white flash
  //     Future.delayed(const Duration(milliseconds: 100), () {
  //       _buttonColorNotifiers[index].value = Colors.transparent; // Revert to transparent
  //     });
  //   }
  // }


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
        title: ValueListenableBuilder<SettingsData>(
          valueListenable: settingsService.settings,
          builder: (context, settings, child) => Text(settings.workInProgressLabel),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.greenAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0), // Match AppBar height
          child: ValueListenableBuilder<WorkMetrics>(
            valueListenable: _controller.metrics,
            builder: (context, metrics, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: DefaultTextStyle( // Apply monospace font to metrics row
                style: Theme.of(context).textTheme.bodyMedium!,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetricDisplay( // Generic Metric Display Widget
                      label: 'Time',
                      // Removed notifier
                      // notifier: _timerScaleNotifier,
                      metrics: metrics,
                      valueBuilder: (metrics) => _formatTime(metrics.elapsedTime),
                    ),
                    _MetricDisplay( // Generic Metric Display Widget
                      label: 'Units',
                      // Removed notifier
                      // notifier: _unitsScaleNotifier,
                      metrics: metrics,
                      valueBuilder: (metrics) => '${metrics.totalUnits}',
                    ),
                    _MetricDisplay( // Generic Metric Display Widget
                      label: 'Units/min',
                      // Removed notifier
                      // notifier: _cpmScaleNotifier,
                      metrics: metrics,
                      valueBuilder: (metrics) => metrics.clicksPerMinute.toStringAsFixed(1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: DefaultTextStyle( // Apply monospace font to body
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: ValueListenableBuilder<SettingsData>(
                  valueListenable: settingsService.settings,
                  builder: (context, settings, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: settings.clickOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      int option = entry.value;
                      return Expanded( // Expand each click area to fill row
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical spacing between buttons
                          child: _TerminalClickArea(
                            onTap: () => _incrementUnitsByPreset(index, option), // Pass index here
                            // Removed flash color notifier
                            // flashColorNotifier: _buttonColorNotifiers[index], // Get notifier by index
                            flashColorNotifier: ValueNotifier<Color>(Colors.transparent), // Dummy notifier to keep widget structure, no animation
                            child: Center(child: Text('+${option} ${settings.workUnitLabel}', textAlign: TextAlign.center)), // Center text
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Spacer(flex: 2), // Removed metrics from body, keeping spacer
            ],
          ),
        ),
      ),
    );
  }
}


/// Corrected and Generic Metric Display Widget (DRY & KISS Compliant) - Widget Class
class _MetricDisplay extends StatelessWidget {
  final String label;
  // Removed notifier
  // final ValueNotifier<double> notifier;
  final WorkMetrics metrics;
  final String Function(WorkMetrics) valueBuilder;

  const _MetricDisplay({
    super.key,
    required this.label,
    // Removed notifier
    // required this.notifier,
    required this.metrics,
    required this.valueBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<SettingsData>(
          valueListenable: settingsService.settings,
          builder: (context, settings, child) => Text('$label:', style: Theme.of(context).textTheme.bodyMedium),
        ),
        // Removed ValueListenableBuilder and AnimatedScale
        // ValueListenableBuilder<double>(
        //   valueListenable: notifier,
        //   builder: (context, scale, child) => AnimatedScale(
        //     scale: scale,
        //     duration: const Duration(milliseconds: 300),
        //     child:
            Text(
              valueBuilder(metrics), // Use the valueBuilder function to get value
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.lightGreenAccent),
            ),
        //   ),
        // ),
      ],
    );
  }
}


/// Settings screen - No changes needed - Only Click Options update required in State

/// Settings screen to customize labels and click options (Presentation Layer - View).
class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsScreenController _controller;
  late SettingsData currentSettings;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController workUnitController = TextEditingController();
  final TextEditingController tasksButtonLabelController = TextEditingController();
  final TextEditingController cpmLabelController = TextEditingController();
  final TextEditingController timeLabelController = TextEditingController();
  final TextEditingController workInProgressLabelController = TextEditingController();
  final TextEditingController workTaskerLabelController = TextEditingController();
  final TextEditingController startWorkdayLabelController = TextEditingController();
  final TextEditingController readyToWorkLabelController = TextEditingController();
  List<TextEditingController> clickOptionControllers = []; // Dynamic click options


  @override
  void initState() {
    super.initState();
    _controller = SettingsScreenController(settingsService);
    currentSettings = _controller.settings.value;
    _initializeControllers();
    _initializeClickOptionControllers();
  }

  void _initializeControllers() {
    workUnitController.text = currentSettings.workUnitLabel;
    tasksButtonLabelController.text = currentSettings.tasksButtonLabel;
    cpmLabelController.text = currentSettings.cpmLabel;
    timeLabelController.text = currentSettings.timeLabel;
    workInProgressLabelController.text = currentSettings.workInProgressLabel;
    workTaskerLabelController.text = currentSettings.workTaskerLabel;
    startWorkdayLabelController.text = currentSettings.startWorkdayLabel;
    readyToWorkLabelController.text = currentSettings.readyToWorkLabel;
  }

  void _initializeClickOptionControllers() {
    clickOptionControllers = List.generate(6, (index) { // Generate 6 controllers
      if (index < currentSettings.clickOptions.length) {
        return TextEditingController(text: currentSettings.clickOptions[index].toString());
      } else {
        return TextEditingController(text: '0'); // Default to '0' for extra options
      }
    });
  }


  @override
  void dispose() {
    workUnitController.dispose();
    tasksButtonLabelController.dispose();
    cpmLabelController.dispose();
    timeLabelController.dispose();
    workInProgressLabelController.dispose();
    workTaskerLabelController.dispose();
    startWorkdayLabelController.dispose();
    readyToWorkLabelController.dispose();
    for (var controller in clickOptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }


  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final newSettings = currentSettings.copyWith(
        workUnitLabel: workUnitController.text,
        tasksButtonLabel: tasksButtonLabelController.text,
        cpmLabel: cpmLabelController.text,
        timeLabel: timeLabelController.text,
        workInProgressLabel: workInProgressLabelController.text,
        workTaskerLabel: workTaskerLabelController.text,
        startWorkdayLabel: startWorkdayLabelController.text,
        readyToWorkLabel: readyToWorkLabelController.text,
        clickOptions: clickOptionControllers.map((controller) => int.tryParse(controller.text) ?? 0).where((val) => val > 0).toList(), // Parse and filter
      );
      _controller.updateSettings(newSettings);
      Navigator.pop(context); // Go back to work screen
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              controller: workTaskerLabelController,
              decoration: const InputDecoration(labelText: 'App Title Label'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: workInProgressLabelController,
              decoration: const InputDecoration(labelText: 'Work In Progress Label'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: startWorkdayLabelController,
              decoration: const InputDecoration(labelText: 'Start Workday Button Label'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: readyToWorkLabelController,
              decoration: const InputDecoration(labelText: 'Ready To Work Label'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: tasksButtonLabelController,
              decoration: const InputDecoration(labelText: 'Tasks Button Label'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: workUnitController,
              decoration: const InputDecoration(labelText: 'Work Unit Label (e.g., Units, Items)'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: cpmLabelController,
              decoration: const InputDecoration(labelText: 'Clicks Per Minute Label'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: timeLabelController,
              decoration: const InputDecoration(labelText: 'Time Label'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 15),
            Text("Click Options (at least 1):", style: Theme.of(context).textTheme.bodyMedium),
            ...clickOptionControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (int.tryParse(value) == null) return 'Must be a number';
                    if (int.parse(value) <= 0) return 'Must be positive';
                    return null;
                  },
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveSettings, child: const Text('Save Settings')),
          ],
        ),
      ),
    );
  }
}


/// **--- Custom Widgets for Terminal Look ---**

/// Terminal Style Button - No background, just text with tap feedback.
class _TerminalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const _TerminalButton({required this.onPressed, required this.child});

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


/// Terminal Style Clickable Area - Underlined text area with flash feedback.
class _TerminalClickArea extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  // Removed flashColorNotifier
  // final ValueNotifier<Color> flashColorNotifier;
  final ValueNotifier<Color> flashColorNotifier; // Keep notifier, but it's now a dummy

  const _TerminalClickArea({required this.onTap, required this.child, required this.flashColorNotifier});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ValueListenableBuilder<Color>(
        valueListenable: flashColorNotifier,
        builder: (context, flashColor, child) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Reduced vertical padding
          decoration: BoxDecoration(
            color: flashColor, // flashColor is still here, but no animation logic
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1)), // Underline border
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelLarge!,
            child: child!,
          ),
        ),
        child: child,
      ),
    );
  }
}


/// **--- Global Settings and Services Instances ---**
final settingsService = SettingsService();
final workService = WorkService(InMemoryWorkDataSource());
