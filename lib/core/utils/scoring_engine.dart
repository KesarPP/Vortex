import 'dart:math';

class ScoringEngine {
  /// Z-Score Normalization Engine:
  /// Mathematical standardization of rubric scores across distinct judging panels.
  /// Z = (X - μ) / σ
  /// 
  /// Returns a map of judgeId to their normalized scores.
  static List<double> normalizeScores(List<double> rawScores) {
    if (rawScores.isEmpty) return [];
    if (rawScores.length == 1) return [0.0]; // Can't calculate std dev with 1 score

    // Calculate Mean (μ)
    final double sum = rawScores.fold(0, (prev, element) => prev + element);
    final double mean = sum / rawScores.length;

    // Calculate Standard Deviation (σ)
    final double varianceSum = rawScores.fold(0, (prev, element) => prev + pow(element - mean, 2));
    final double variance = varianceSum / (rawScores.length - 1); // Sample variance
    final double standardDeviation = sqrt(variance);

    if (standardDeviation == 0) {
      // All scores are the same, z-score is 0
      return List.filled(rawScores.length, 0.0);
    }

    // Calculate Z-Scores
    return rawScores.map((score) => (score - mean) / standardDeviation).toList();
  }
}
