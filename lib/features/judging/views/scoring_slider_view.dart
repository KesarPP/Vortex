import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/providers/event_team_provider.dart';
import '../../teams/models/team_model.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../../shared/widgets/glass_card.dart';

class ScoringSliderView extends ConsumerStatefulWidget {
  const ScoringSliderView({super.key});

  @override
  ConsumerState<ScoringSliderView> createState() => _ScoringSliderViewState();
}

class _ScoringSliderViewState extends ConsumerState<ScoringSliderView> {
  TeamModel? selectedTeam;

  double innovationScore = 5.0;
  double technicalScore = 5.0;
  double uiuxScore = 5.0;
  double pitchScore = 5.0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Judge Evaluation Suite',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NOW PITCHING',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: VortexTheme.neonViolet,
                    letterSpacing: 2,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {}, // Conflict of interest logic
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text('Conflict of Interest'),
                  style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.surface),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<TeamModel>(
                    decoration: const InputDecoration(
                      labelText: 'Select Team to Evaluate',
                      labelStyle: TextStyle(color: VortexTheme.textSecondary),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: VortexTheme.neonViolet)),
                    ),
                    dropdownColor: VortexTheme.surface,
                    value: selectedTeam,
                    items: ref.watch(eventTeamProvider).allTeams.map((team) {
                      return DropdownMenuItem<TeamModel>(
                        value: team,
                        child: Text(team.name, style: const TextStyle(color: VortexTheme.textPrimary)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedTeam = val;
                        innovationScore = val?.innovationScore ?? 5.0;
                        technicalScore = val?.technicalScore ?? 5.0;
                        uiuxScore = val?.uiuxScore ?? 5.0;
                        pitchScore = val?.pitchScore ?? 5.0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selectedTeam != null ? 'Track: ${selectedTeam!.track}' : 'Please select a team to begin scoring.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: VortexTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'BLIND RUBRIC SCORING',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: VortexTheme.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: [
                  _RubricSlider(
                    title: 'Innovation & Creativity',
                    value: innovationScore,
                    onChanged: (val) => setState(() => innovationScore = val),
                  ),
                  _RubricSlider(
                    title: 'Technical Complexity',
                    value: technicalScore,
                    onChanged: (val) => setState(() => technicalScore = val),
                  ),
                  _RubricSlider(
                    title: 'UI/UX & Design',
                    value: uiuxScore,
                    onChanged: (val) => setState(() => uiuxScore = val),
                  ),
                  _RubricSlider(
                    title: 'Pitch & Presentation',
                    value: pitchScore,
                    onChanged: (val) => setState(() => pitchScore = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedTeam == null ? null : () {
                  ref.read(eventTeamProvider.notifier).submitTeamScore(
                    selectedTeam!.id,
                    innovationScore,
                    technicalScore,
                    uiuxScore,
                    pitchScore,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Scores submitted successfully for ${selectedTeam!.name}!'),
                      backgroundColor: VortexTheme.telemetryGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: VortexTheme.telemetryGreen,
                  foregroundColor: VortexTheme.background,
                  disabledBackgroundColor: VortexTheme.surface,
                ),
                child: const Text('SUBMIT EVALUATION'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RubricSlider extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  const _RubricSlider({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: VortexTheme.neonCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: VortexTheme.neonCyan,
              inactiveTrackColor: VortexTheme.surface,
              thumbColor: VortexTheme.textPrimary,
              overlayColor: VortexTheme.neonCyan.withOpacity(0.2),
              trackHeight: 8.0,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 20,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
