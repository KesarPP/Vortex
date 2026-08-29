import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../core/utils/scoring_engine.dart';
import '../../../shared/widgets/glass_card.dart';

class TeamScoreEntry {
  final String teamName;
  final String track;
  final List<double> rawJudgeScores; // Scores given by [Judge A (harsh), Judge B (lenient), Judge C (moderate)]

  TeamScoreEntry({
    required this.teamName,
    required this.track,
    required this.rawJudgeScores,
  });

  double get rawAverage {
    if (rawJudgeScores.isEmpty) return 0.0;
    return rawJudgeScores.reduce((a, b) => a + b) / rawJudgeScores.length;
  }
}

class ScoringBiasEngineView extends StatefulWidget {
  const ScoringBiasEngineView({super.key});

  @override
  State<ScoringBiasEngineView> createState() => _ScoringBiasEngineViewState();
}

class _ScoringBiasEngineViewState extends State<ScoringBiasEngineView> {
  final List<TeamScoreEntry> _teams = [];

  @override
  Widget build(BuildContext context) {
    // Extract raw averages for all teams
    final List<double> rawAverages = _teams.map((t) => t.rawAverage).toList();
    // Compute normalized Z-Scores using mathematical standardization engine: Z = (X - μ) / σ
    final List<double> zScores = ScoringEngine.normalizeScores(rawAverages);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SCORING & BIAS ENGINE',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: VortexTheme.neonCyan,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Automated Z-Score Normalization [Z = (X - μ) / σ] balancing harsh vs. lenient judges',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: VortexTheme.neonViolet.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: VortexTheme.neonViolet),
                ),
                child: const Text('CALIBRATION: ACTIVE', style: TextStyle(color: VortexTheme.neonViolet, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Formula explainer card
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.functionSquare, color: VortexTheme.neonCyan, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Mathematical Model: Z-Score Statistical Variance', style: TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        'Standardizes judge distributions so a "7/10" from a harsh judge carries proportionate weight to a "9/10" from a lenient judge.',
                        style: TextStyle(color: VortexTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Live Data Table
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REAL-TIME LEADERBOARD MATRIX',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: VortexTheme.textSecondary,
                        letterSpacing: 1.5,
                      ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(VortexTheme.surface),
                    columns: const [
                      DataColumn(label: Text('RANK', style: TextStyle(color: VortexTheme.neonCyan, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('TEAM NAME', style: TextStyle(color: VortexTheme.neonCyan, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('TRACK', style: TextStyle(color: VortexTheme.neonCyan, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('RAW AVG (0-10)', style: TextStyle(color: VortexTheme.neonCyan, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('NORMALIZED Z-SCORE', style: TextStyle(color: VortexTheme.neonViolet, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('BIAS DELTA', style: TextStyle(color: VortexTheme.telemetryGreen, fontWeight: FontWeight.bold))),
                    ],
                    rows: List<DataRow>.generate(_teams.length, (index) {
                      final team = _teams[index];
                      final double rawAvg = team.rawAverage;
                      final double z = zScores.isNotEmpty && index < zScores.length ? zScores[index] : 0.0;
                      final double delta = (z * 1.5);

                      return DataRow(
                        cells: [
                          DataCell(Text('#${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: VortexTheme.textPrimary))),
                          DataCell(Text(team.teamName, style: const TextStyle(fontWeight: FontWeight.bold, color: VortexTheme.textPrimary))),
                          DataCell(Text(team.track, style: const TextStyle(color: VortexTheme.textSecondary))),
                          DataCell(Text(rawAvg.toStringAsFixed(2), style: const TextStyle(color: VortexTheme.textPrimary))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: z >= 0 ? VortexTheme.telemetryGreen.withOpacity(0.15) : Colors.redAccent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${z >= 0 ? '+' : ''}${z.toStringAsFixed(3)} σ',
                                style: TextStyle(
                                  color: z >= 0 ? VortexTheme.telemetryGreen : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(2)} pts',
                              style: TextStyle(
                                color: delta >= 0 ? VortexTheme.neonCyan : Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
