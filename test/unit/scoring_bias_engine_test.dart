import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/core/utils/scoring_bias_engine.dart';

void main() {
  group('ScoringBiasEngine Statistical Analysis Tests', () {
    test('calculateMeanAndStdDev returns accurate statistics', () {
      final scores = [8.0, 8.5, 9.0, 7.5, 9.5];
      final stats = ScoringBiasEngine.calculateStats(scores);

      expect(stats.mean, closeTo(8.5, 0.1));
      expect(stats.stdDev, greaterThan(0.0));
      expect(stats.count, 5);
    });

    test('detects outlier scores with Z-score threshold', () {
      final scores = [8.0, 8.2, 8.1, 8.0, 1.0]; // 1.0 is extreme outlier
      final isOutlier = ScoringBiasEngine.isOutlier(1.0, scores, threshold: 1.5);

      expect(isOutlier, true);
    });
  });
}
