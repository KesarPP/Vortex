import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';

class TelemetryDashboardContent extends StatelessWidget {
  const TelemetryDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIVE OPERATIONS TELEMETRY',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: VortexTheme.neonCyan,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Real-time throughput metrics across venue sensors and gate checkpoints',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: _StatCard(title: 'Check-in Velocity', value: '142 / hr', color: VortexTheme.telemetryGreen)),
              SizedBox(width: 14),
              Expanded(child: _StatCard(title: 'Active Teams', value: '48', color: VortexTheme.neonCyan)),
              SizedBox(width: 14),
              Expanded(child: _StatCard(title: 'Queue Wait Time', value: '4m 12s', color: Colors.orangeAccent)),
              SizedBox(width: 14),
              Expanded(child: _StatCard(title: 'Judging Progress', value: '64%', color: VortexTheme.neonViolet)),
            ],
          ),
          const SizedBox(height: 28),
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CHECK-IN VELOCITY & GATE THROUGHPUT',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: VortexTheme.textSecondary,
                            letterSpacing: 1.2,
                          ),
                    ),
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: VortexTheme.neonCyan, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('Gate 01', style: TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                        const SizedBox(width: 16),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: VortexTheme.neonViolet, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('Gate 02', style: TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 260,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        getDrawingHorizontalLine: (value) => FlLine(color: VortexTheme.surface, strokeWidth: 1),
                        getDrawingVerticalLine: (value) => FlLine(color: VortexTheme.surface, strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (v, meta) => Text('${v.toInt()}', style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 10)))),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) => Text('${v.toInt()}:00', style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 10)))),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(8, 20),
                            FlSpot(9, 45),
                            FlSpot(10, 110),
                            FlSpot(11, 142),
                            FlSpot(12, 90),
                            FlSpot(13, 120),
                            FlSpot(14, 85),
                          ],
                          isCurved: true,
                          color: VortexTheme.neonCyan,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: VortexTheme.neonCyan.withOpacity(0.12),
                          ),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(8, 10),
                            FlSpot(9, 25),
                            FlSpot(10, 60),
                            FlSpot(11, 80),
                            FlSpot(12, 70),
                            FlSpot(13, 95),
                            FlSpot(14, 60),
                          ],
                          isCurved: true,
                          color: VortexTheme.neonViolet,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: VortexTheme.neonViolet.withOpacity(0.08),
                          ),
                        ),
                      ],
                    ),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: VortexTheme.textSecondary,
                  letterSpacing: 1.1,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
          ),
        ],
      ),
    );
  }
}

class TelemetryDashboardView extends StatelessWidget {
  const TelemetryDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: TelemetryDashboardContent(),
      ),
    );
  }
}
