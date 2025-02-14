import 'package:flutter/foundation.dart';

class SettingsData {
  final String workUnitLabel;
  final String tasksButtonLabel;
  final String cpmLabel;
  final String timeLabel;
  final String startWorkdayLabel;
  final String workInProgressLabel;
  final String workTaskerLabel;
  final String readyToWorkLabel;
  final List<int> clickOptions;

  SettingsData({
    this.workUnitLabel = 'Units',
    this.tasksButtonLabel = 'Tasks',
    this.cpmLabel = 'Units/min',
    this.timeLabel = 'Time',
    this.workInProgressLabel = 'Work in Progress!',
    this.workTaskerLabel = 'Work Tasker',
    this.startWorkdayLabel = 'Start Workday!',
    this.readyToWorkLabel = 'Ready to get to work?',
    this.clickOptions = const [1, 5, 10, 25, 50, 100],
  });

  SettingsData copyWith({
    String? workUnitLabel,
    String? tasksButtonLabel,
    String? cpmLabel,
    String? timeLabel,
    String? startWorkdayLabel,
    String? workInProgressLabel,
    String? workTaskerLabel,
    String? readyToWorkLabel,
    List<int>? clickOptions,
  }) {
    return SettingsData(
      workUnitLabel: workUnitLabel ?? this.workUnitLabel,
      tasksButtonLabel: tasksButtonLabel ?? this.tasksButtonLabel,
      cpmLabel: cpmLabel ?? this.cpmLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      startWorkdayLabel: startWorkdayLabel ?? this.startWorkdayLabel,
      workInProgressLabel: workInProgressLabel ?? this.workInProgressLabel,
      workTaskerLabel: workTaskerLabel ?? this.workTaskerLabel,
      readyToWorkLabel: readyToWorkLabel ?? this.readyToWorkLabel,
      clickOptions: clickOptions ?? this.clickOptions,
    );
  }
}
