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
      appBar: AppBar(title: const Text('Settings')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              controller: workTaskerLabelController,
              decoration: const InputDecoration(labelText: 'App Title Label'),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: workInProgressLabelController,
              decoration: const InputDecoration(
                labelText: 'Work In Progress Label',
              ),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: startWorkdayLabelController,
              decoration: const InputDecoration(
                labelText: 'Start Workday Button Label',
              ),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: readyToWorkLabelController,
              decoration: const InputDecoration(
                labelText: 'Ready To Work Label',
              ),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: tasksButtonLabelController,
              decoration: const InputDecoration(
                labelText: 'Tasks Button Label',
              ),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: workUnitController,
              decoration: const InputDecoration(
                labelText: 'Work Unit Label (e.g., Units, Items)',
              ),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: cpmLabelController,
              decoration: const InputDecoration(
                labelText: 'Clicks Per Minute Label',
              ),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: timeLabelController,
              decoration: const InputDecoration(labelText: 'Time Label'),
              validator:
                  (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 15),
            Text(
              "Click Options (at least 1):",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
