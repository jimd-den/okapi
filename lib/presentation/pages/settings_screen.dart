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
  late final TextEditingController workInProgressLabelController;
  late final TextEditingController workTaskerLabelController;
  late final TextEditingController startWorkdayLabelController;
  late final TextEditingController readyToWorkLabelController;
  late final TextEditingController multiClickValueController;

  @override
  void initState() {
    super.initState();
    final currentSettings = settingsService.settings.value;
    workUnitController = TextEditingController(text: currentSettings.workUnitLabel);
    workInProgressLabelController = TextEditingController(text: currentSettings.workInProgressLabel);
    workTaskerLabelController = TextEditingController(text: currentSettings.workTaskerLabel);
    startWorkdayLabelController = TextEditingController(text: currentSettings.startWorkdayLabel);
    readyToWorkLabelController = TextEditingController(text: currentSettings.readyToWorkLabel);
    multiClickValueController = TextEditingController(text: currentSettings.multiClickValue.toString());
  }

  @override
  void dispose() {
    workUnitController.dispose();
    workInProgressLabelController.dispose();
    workTaskerLabelController.dispose();
    startWorkdayLabelController.dispose();
    readyToWorkLabelController.dispose();
    multiClickValueController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final newSettings = settingsService.settings.value.copyWith(
        workUnitLabel: workUnitController.text,
        workInProgressLabel: workInProgressLabelController.text,
        workTaskerLabel: workTaskerLabelController.text,
        startWorkdayLabel: startWorkdayLabelController.text,
        readyToWorkLabel: readyToWorkLabelController.text,
        multiClickValue: int.tryParse(multiClickValueController.text) ?? 5,
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
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: workTaskerLabelController,
              decoration: const InputDecoration(labelText: 'App Title'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: workInProgressLabelController,
              decoration: const InputDecoration(labelText: 'Work In Progress'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: startWorkdayLabelController,
              decoration: const InputDecoration(labelText: 'Start Button'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: readyToWorkLabelController,
              decoration: const InputDecoration(labelText: 'Ready Message'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: workUnitController,
              decoration: const InputDecoration(labelText: 'Unit Label'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: multiClickValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Multi-Click Value',
                helperText: 'Number of units for the second button',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final number = int.tryParse(value);
                if (number == null || number <= 1) return 'Must be greater than 1';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
