import 'package:flutter/foundation.dart';
import '../entities/settings_data.dart';

abstract class SettingsRepository {
  ValueNotifier<SettingsData> get settings;
  void updateSettings(SettingsData newSettings);
}
