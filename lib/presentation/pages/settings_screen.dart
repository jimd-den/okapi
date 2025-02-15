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
  late final TextEditingController workTaskerLabelController;
  late final TextEditingController multiClickValueController;

  @override
  void initState() {
    super.initState();
    final currentSettings = settingsService.settings.value;
    workUnitController = TextEditingController(
      text: currentSettings.workUnitLabel,
    );
    workTaskerLabelController = TextEditingController(
      text: currentSettings.workTaskerLabel,
    );
    multiClickValueController = TextEditingController(
      text: currentSettings.multiClickValue.toString(),
    );
  }

  @override
  void dispose() {
    workUnitController.dispose();
    workTaskerLabelController.dispose();
    multiClickValueController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final newSettings = settingsService.settings.value.copyWith(
        workUnitLabel: workUnitController.text,
        workTaskerLabel: workTaskerLabelController.text,
        multiClickValue: int.tryParse(multiClickValueController.text) ?? 5,
      );
      settingsService.updateSettings(newSettings);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          ValueListenableBuilder(
            valueListenable: settingsService.settings,
            builder:
                (context, settings, child) => IconButton(
                  icon: Icon(
                    settings.useHighContrast
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: theme.colorScheme.onBackground,
                  ),
                  onPressed: () {
                    final newSettings = settings.copyWith(
                      useHighContrast: !settings.useHighContrast,
                    );
                    settingsService.updateSettings(newSettings);
                  },
                  tooltip:
                      settings.useHighContrast
                          ? 'Switch to Light Mode'
                          : 'Switch to Dark Mode',
                ),
          ),
          IconButton(
            icon: Icon(Icons.save, color: theme.colorScheme.onBackground),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Labels', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: workTaskerLabelController,
                      decoration: const InputDecoration(labelText: 'App Title'),
                      validator:
                          (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: workUnitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Label',
                      ),
                      validator:
                          (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Counter Settings',
                      style: theme.textTheme.titleMedium,
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
                        if (number == null || number <= 1)
                          return 'Must be greater than 1';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Display', style: theme.textTheme.titleMedium),
                    ValueListenableBuilder(
                      valueListenable: settingsService.settings,
                      builder:
                          (context, settings, child) => Column(
                            children: [
                              SwitchListTile(
                                title: const Text('High-precision Updates'),
                                subtitle: const Text(
                                  'Update rate display every millisecond',
                                ),
                                value: settings.useMillisecondUpdates,
                                onChanged: (bool value) {
                                  final newSettings = settings.copyWith(
                                    useMillisecondUpdates: value,
                                  );
                                  settingsService.updateSettings(newSettings);
                                },
                              ),
                              SwitchListTile(
                                title: const Text('High Contrast Theme'),
                                subtitle: const Text(
                                  'Use dark mode with high contrast colors',
                                ),
                                value: settings.useHighContrast,
                                onChanged: (bool value) {
                                  final newSettings = settings.copyWith(
                                    useHighContrast: value,
                                  );
                                  settingsService.updateSettings(newSettings);
                                },
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
