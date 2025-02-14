import '../entities/work_data.dart';

abstract class WorkRepository {
  void startWork();
  void incrementUnits(int count);
  WorkData getWorkData();
  WorkMetrics calculateMetrics(WorkData data);
}
