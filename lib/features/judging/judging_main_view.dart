import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../auth/providers/auth_provider.dart';
import '../../core/theme/vortex_theme.dart';
import 'views/scoring_slider_view.dart';
import 'views/public_stage_view.dart';

import '../events/providers/event_team_provider.dart';

class JudgingMainView extends ConsumerStatefulWidget {
  const JudgingMainView({super.key});

  @override
  ConsumerState<JudgingMainView> createState() => _JudgingMainViewState();
}

class _JudgingMainViewState extends ConsumerState<JudgingMainView> {
  int _activeMode = 0; // 0: Judge Evaluation Sheet, 1: Stage Projector

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventTeamProvider.notifier).fetchOnlyFromFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [VortexTheme.neonViolet, VortexTheme.neonCyan],
                ),
              ),
              child: const Icon(LucideIcons.award, size: 16, color: Colors.black),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'VORTEX // JUDGING & STAGE',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (MediaQuery.of(context).size.width >= 850)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    icon: Icon(LucideIcons.sliders, size: 16),
                    label: Text('Evaluation Sheet'),
                  ),
                  ButtonSegment(
                    value: 1,
                    icon: Icon(LucideIcons.projector, size: 16),
                    label: Text('Stage Display (16:9)'),
                  ),
                ],
                selected: {_activeMode},
                onSelectionChanged: (set) => setState(() => _activeMode = set.first),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return VortexTheme.neonViolet.withOpacity(0.3);
                    }
                    return VortexTheme.surface;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return VortexTheme.neonCyan;
                    }
                    return VortexTheme.textSecondary;
                  }),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 16, color: VortexTheme.neonCyan),
            tooltip: 'Sync Live Firebase Data',
            onPressed: () {
              ref.read(eventTeamProvider.notifier).fetchOnlyFromFirebase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⚡ Synced live from Firebase Cloud Firestore.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.logOut, color: Colors.redAccent),
            tooltip: 'Sign Out',
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _activeMode == 0 ? const ScoringSliderView() : const PublicStageView(),
      bottomNavigationBar: MediaQuery.of(context).size.width < 850
          ? BottomNavigationBar(
              currentIndex: _activeMode,
              backgroundColor: VortexTheme.surface,
              selectedItemColor: VortexTheme.neonCyan,
              unselectedItemColor: VortexTheme.textSecondary,
              onTap: (index) => setState(() => _activeMode = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(LucideIcons.sliders), label: 'Evaluation'),
                BottomNavigationBarItem(icon: Icon(LucideIcons.projector), label: 'Stage'),
              ],
            )
          : null,
    );
  }
}
