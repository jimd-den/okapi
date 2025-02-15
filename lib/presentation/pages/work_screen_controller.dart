import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/settings_data.dart';
import '../../domain/entities/work_data.dart';
import '../../domain/repositories/work_repository.dart';
import '../../domain/repositories/settings_repository.dart';

class WorkScreenController {
  final WorkRepository _workService;
  final SettingsRepository _settingsService;
  final ValueNotifier<WorkMetrics> metrics = ValueNotifier(
    WorkMetrics(totalUnits: 0, clicksPerMinute: 0, elapsedTime: Duration.zero),
  );
  Timer? _timer;
  DateTime? _lastUpdate;

  WorkScreenController(this._workService, this._settingsService);

  void initialize() {
    _workService.startWork();
    startTimer();
    // Listen to settings changes to update timer interval
    _settingsService.settings.addListener(_onSettingsChanged);
  }

  void dispose() {
    _timer?.cancel();
    _settingsService.settings.removeListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    // Restart timer with new interval when settings change
    _timer?.cancel();
    startTimer();
  }

  void startTimer() {
    final useMilliseconds =
        _settingsService.settings.value.useMillisecondUpdates;
    final interval =
        useMilliseconds
            ? const Duration(milliseconds: 1)
            : const Duration(seconds: 2);

    _timer = Timer.periodic(interval, (timer) {
      final now = DateTime.now();
      if (_lastUpdate == null ||
          metrics.value.totalUnits > 0 ||
          now.difference(_lastUpdate!) >= interval) {
        updateMetrics();
        _lastUpdate = now;
      }
    });
  }

  void updateMetrics() {
    final data = _workService.getWorkData();
    metrics.value = _workService.calculateMetrics(data);
  }

  void incrementUnits(int count) {
    _workService.incrementUnits(count);
    updateMetrics();
    _lastUpdate = DateTime.now();
  }

  ValueNotifier<SettingsData> get settings => _settingsService.settings;
}
