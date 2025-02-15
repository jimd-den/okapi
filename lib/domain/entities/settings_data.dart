class SettingsData {
  final String workUnitLabel;
  final String workTaskerLabel;
  final int multiClickValue;
  final bool useMillisecondUpdates;
  final bool useHighContrast;

  SettingsData({
    this.workUnitLabel = 'Units',
    this.workTaskerLabel = 'Work Tasker',
    this.multiClickValue = 5,
    this.useMillisecondUpdates = false,
    this.useHighContrast = false,
  });

  SettingsData copyWith({
    String? workUnitLabel,
    String? workTaskerLabel,
    int? multiClickValue,
    bool? useMillisecondUpdates,
    bool? useHighContrast,
  }) {
    return SettingsData(
      workUnitLabel: workUnitLabel ?? this.workUnitLabel,
      workTaskerLabel: workTaskerLabel ?? this.workTaskerLabel,
      multiClickValue: multiClickValue ?? this.multiClickValue,
      useMillisecondUpdates:
          useMillisecondUpdates ?? this.useMillisecondUpdates,
      useHighContrast: useHighContrast ?? this.useHighContrast,
    );
  }
}
