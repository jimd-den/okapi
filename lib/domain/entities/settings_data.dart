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
  final int multiClickValue;

  SettingsData({
    this.workUnitLabel = 'Units',
    this.tasksButtonLabel = 'Tasks',
    this.cpmLabel = 'Units/min',
    this.timeLabel = 'Time',
    this.workInProgressLabel = 'Work in Progress!',
    this.workTaskerLabel = 'Work Tasker',
    this.startWorkdayLabel = 'Start Workday!',
    this.readyToWorkLabel = 'Ready to get to work?',
    this.multiClickValue = 5,
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
    int? multiClickValue,
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
      multiClickValue: multiClickValue ?? this.multiClickValue,
    );
  }
}
