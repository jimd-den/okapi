import '../../domain/entities/work_data.dart';

abstract class WorkDataSource {
  void startWork();
  void incrementUnits(int count);
  WorkData getWorkData();
}

class InMemoryWorkDataSource implements WorkDataSource {
  int totalUnits = 0;
  DateTime? startTime;
  final List<DateTime> clickTimestamps = [];
  static const int maxTimestampHistory =
      100; // Limit history to reduce memory usage

  @override
  void startWork() {
    startTime = DateTime.now();
    totalUnits = 0;
    clickTimestamps.clear();
  }

  @override
  void incrementUnits(int count) {
    totalUnits += count;
    final now = DateTime.now();
    clickTimestamps.add(now);

    // Keep only recent timestamps to limit memory usage
    if (clickTimestamps.length > maxTimestampHistory) {
      clickTimestamps.removeRange(
        0,
        clickTimestamps.length - maxTimestampHistory,
      );
    }
  }

  @override
  WorkData getWorkData() {
    return WorkData(
      totalUnits: totalUnits,
      startTime: startTime,
      clickTimestamps: clickTimestamps,
    );
  }
}
