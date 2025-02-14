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

  WorkScreenController(this._workService, this._settingsService);

  void initialize() {
    _workService.startWork();
    startTimer();
  }

  void dispose() {
    _timer?.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateMetrics();
    });
  }

  void updateMetrics() {
    final data = _workService.getWorkData();
    metrics.value = _workService.calculateMetrics(data);
  }

  void incrementUnits(int count) {
    _workService.incrementUnits(count);
    updateMetrics();
  }

  ValueNotifier<SettingsData> get settings => _settingsService.settings;
}
