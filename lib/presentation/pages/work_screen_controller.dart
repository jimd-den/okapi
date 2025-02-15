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
  }

  void dispose() {
    _timer?.cancel();
  }

  void startTimer() {
    // Update every 2 seconds instead of every second to reduce resource usage
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Only update if there are units to calculate or if it's been more than 2 seconds
      final now = DateTime.now();
      if (_lastUpdate == null ||
          metrics.value.totalUnits > 0 ||
          now.difference(_lastUpdate!) >= const Duration(seconds: 2)) {
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
