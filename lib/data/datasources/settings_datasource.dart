import 'package:flutter/foundation.dart';
import '../../domain/entities/settings_data.dart';

abstract class SettingsDataSource {
  ValueNotifier<SettingsData> get settings;
  void updateSettings(SettingsData newSettings);
}

class InMemorySettingsDataSource implements SettingsDataSource {
  final ValueNotifier<SettingsData> _settingsNotifier = ValueNotifier(
    SettingsData(),
  );

  @override
  ValueNotifier<SettingsData> get settings => _settingsNotifier;

  @override
  void updateSettings(SettingsData newSettings) {
    _settingsNotifier.value = newSettings;
  }
}
