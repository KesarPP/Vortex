import 'dart:math';

class ScoringStats {
  final double mean;
  final double stdDev;
  final int count;

  const ScoringStats({
    required this.mean,
    required this.stdDev,
    required this.count,
  });
}

class ScoringBiasEngine {
  static ScoringStats calculateStats(List<double> scores) {
    if (scores.isEmpty) {
      return const ScoringStats(mean: 0, stdDev: 0, count: 0);
    }
    final mean = scores.reduce((a, b) => a + b) / scores.length;
    final variance = scores.map((s) => pow(s - mean, 2)).reduce((a, b) => a + b) / scores.length;
    return ScoringStats(
      mean: mean,
      stdDev: sqrt(variance),
      count: scores.length,
    );
  }

  static bool isOutlier(double score, List<double> allScores, {double threshold = 1.5}) {
    if (allScores.length < 3) return false;
    final stats = calculateStats(allScores);
    if (stats.stdDev == 0) return false;
    final zScore = (score - stats.mean).abs() / stats.stdDev;
    return zScore >= threshold;
  }
}
