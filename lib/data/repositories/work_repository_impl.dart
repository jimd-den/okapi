import '../../domain/entities/work_data.dart';
import '../../domain/repositories/work_repository.dart';
import '../datasources/work_datasource.dart';

class WorkRepositoryImpl implements WorkRepository {
  final WorkDataSource dataSource;

  WorkRepositoryImpl(this.dataSource);

  @override
  void startWork() => dataSource.startWork();

  @override
  void incrementUnits(int count) => dataSource.incrementUnits(count);

  @override
  WorkData getWorkData() => dataSource.getWorkData();

  @override
  WorkMetrics calculateMetrics(WorkData data) {
    double clicksPerMinute = 0;
    int totalUnits = data.totalUnits;
    Duration elapsedTime =
        data.startTime != null
            ? DateTime.now().difference(data.startTime!)
            : Duration.zero;

    // Calculate clicks per minute using total seconds for more accuracy
    if (totalUnits > 0 && elapsedTime.inMilliseconds > 0) {
      // Convert to minutes including fractional part
      double minutes = elapsedTime.inMilliseconds / (1000 * 60);
      clicksPerMinute = totalUnits / minutes;
    }

    return WorkMetrics(
      totalUnits: totalUnits,
      clicksPerMinute: clicksPerMinute,
      elapsedTime: elapsedTime,
    );
  }
}
