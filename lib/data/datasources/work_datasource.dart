import '../../domain/entities/work_data.dart';

abstract class WorkDataSource {
  void startWork();
  void incrementUnits(int count);
  WorkData getWorkData();
}

class InMemoryWorkDataSource implements WorkDataSource {
  int totalUnits = 0;
  DateTime? startTime;
  List<DateTime> clickTimestamps = [];

  @override
  void startWork() {
    startTime = DateTime.now();
    totalUnits = 0;
    clickTimestamps = [];
  }

  @override
  void incrementUnits(int count) {
    for (int i = 0; i < count; i++) {
      totalUnits++;
      clickTimestamps.add(DateTime.now());
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
