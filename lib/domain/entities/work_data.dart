class WorkData {
  final int totalUnits;
  final DateTime? startTime;
  final List<DateTime> clickTimestamps;

  const WorkData({
    required this.totalUnits,
    required this.startTime,
    required this.clickTimestamps,
  });
}

class WorkMetrics {
  final int totalUnits;
  final double clicksPerMinute;
  final Duration elapsedTime;

  const WorkMetrics({
    required this.totalUnits,
    required this.clicksPerMinute,
    required this.elapsedTime,
  });
}
