import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'start_screen.dart';
import '../../data/datasources/settings_datasource.dart';
import '../../data/datasources/work_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/work_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/work_repository.dart';

// Global instances - in a real app, use dependency injection
final SettingsRepository settingsService = SettingsRepositoryImpl(
  InMemorySettingsDataSource(),
);
final WorkRepository workService = WorkRepositoryImpl(InMemoryWorkDataSource());

class WorkClickerApp extends StatelessWidget {
  const WorkClickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Tasker',
      theme: AppTheme.theme,
      home: const StartScreen(),
    );
  }
}
