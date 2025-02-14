import 'package:flutter/foundation.dart';
import '../../domain/entities/settings_data.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl(this.dataSource);

  @override
  ValueNotifier<SettingsData> get settings => dataSource.settings;

  @override
  void updateSettings(SettingsData newSettings) =>
      dataSource.updateSettings(newSettings);
}
