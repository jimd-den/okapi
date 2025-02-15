import 'package:flutter/material.dart';
import 'app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController workUnitController;
  late final TextEditingController tasksButtonLabelController;
  late final TextEditingController cpmLabelController;
  late final TextEditingController timeLabelController;
  late final TextEditingController workInProgressLabelController;
  late final TextEditingController workTaskerLabelController;
  late final TextEditingController startWorkdayLabelController;
  late final TextEditingController readyToWorkLabelController;
  late final List<TextEditingController> clickOptionControllers;

  @override
  void initState() {
    super.initState();
    final currentSettings = settingsService.settings.value;
    workUnitController = TextEditingController(
      text: currentSettings.workUnitLabel,
    );
    tasksButtonLabelController = TextEditingController(
      text: currentSettings.tasksButtonLabel,
    );
    cpmLabelController = TextEditingController(text: currentSettings.cpmLabel);
    timeLabelController = TextEditingController(
      text: currentSettings.timeLabel,
    );
    workInProgressLabelController = TextEditingController(
      text: currentSettings.workInProgressLabel,
    );
    workTaskerLabelController = TextEditingController(
      text: currentSettings.workTaskerLabel,
    );
    startWorkdayLabelController = TextEditingController(
      text: currentSettings.startWorkdayLabel,
    );
    readyToWorkLabelController = TextEditingController(
      text: currentSettings.readyToWorkLabel,
    );
    clickOptionControllers = List.generate(
      6,
      (index) => TextEditingController(
        text:
            index < currentSettings.clickOptions.length
                ? currentSettings.clickOptions[index].toString()
                : '0',
      ),
    );
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
      final newSettings = settingsService.settings.value.copyWith(
        workUnitLabel: workUnitController.text,
        tasksButtonLabel: tasksButtonLabelController.text,
        cpmLabel: cpmLabelController.text,
        timeLabel: timeLabelController.text,
        workInProgressLabel: workInProgressLabelController.text,
        workTaskerLabel: workTaskerLabelController.text,
        startWorkdayLabel: startWorkdayLabelController.text,
        readyToWorkLabel: readyToWorkLabelController.text,
        clickOptions:
            clickOptionControllers
                .map((controller) => int.tryParse(controller.text) ?? 0)
                .where((val) => val > 0)
                .toList(),
      );
      settingsService.updateSettings(newSettings);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveSettings),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextField(
              controller: workTaskerLabelController,
              decoration: const InputDecoration(labelText: 'App Title'),
            ),
            TextField(
              controller: workInProgressLabelController,
              decoration: const InputDecoration(labelText: 'Work In Progress'),
            ),
            TextField(
              controller: startWorkdayLabelController,
              decoration: const InputDecoration(labelText: 'Start Button'),
            ),
            TextField(
              controller: readyToWorkLabelController,
              decoration: const InputDecoration(labelText: 'Ready Message'),
            ),
            TextField(
              controller: workUnitController,
              decoration: const InputDecoration(labelText: 'Unit Label'),
            ),
            TextField(
              controller: cpmLabelController,
              decoration: const InputDecoration(labelText: 'Speed Label'),
            ),
            TextField(
              controller: timeLabelController,
              decoration: const InputDecoration(labelText: 'Time Label'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text('Click Values'),
            ),
            ...clickOptionControllers.asMap().entries.map((entry) {
              return TextField(
                controller: entry.value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Value ${entry.key + 1}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
