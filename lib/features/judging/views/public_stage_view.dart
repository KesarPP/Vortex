import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../events/providers/event_team_provider.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';

class PublicStageView extends ConsumerStatefulWidget {
  const PublicStageView({super.key});

  @override
  ConsumerState<PublicStageView> createState() => _PublicStageViewState();
}

class _PublicStageViewState extends ConsumerState<PublicStageView> {
  int _pitchSecondsLeft = 180; // 3 minutes pitch timer
  late Timer _timer;
  bool _isLeaderboardMode = false;
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_pitchSecondsLeft > 0) {
        setState(() => _pitchSecondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isLowTime = _pitchSecondsLeft <= 30;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Top Stage Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'STAGE 01 // MAIN ARENA BROADCAST',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: VortexTheme.textSecondary,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _isLeaderboardMode = !_isLeaderboardMode),
                    icon: Icon(_isLeaderboardMode ? LucideIcons.presentation : LucideIcons.trophy, size: 16),
                    label: Text(_isLeaderboardMode ? 'SHOW PITCH TIMER' : 'REVEAL CEREMONY LEADERBOARD'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isLeaderboardMode ? VortexTheme.neonCyan : Colors.amberAccent,
                      side: BorderSide(color: _isLeaderboardMode ? VortexTheme.neonCyan : Colors.amberAccent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => setState(() => _pitchSecondsLeft = 180),
                    style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.surface),
                    child: const Text('RESET 3:00'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main 16:9 Stage Area
          Expanded(
            child: _isLeaderboardMode
                ? _buildLeaderboardReveal()
                : _buildPitchingArena(isLowTime),
          ),
        ],
      ),
    );
  }

  Widget _buildPitchingArena(bool isLowTime) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left 65%: Now Pitching & Giant Countdown Clock
        Expanded(
          flex: 65,
          child: GlassCard(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: VortexTheme.neonViolet.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: VortexTheme.neonViolet),
                  ),
                  child: const Text('NOW ON STAGE', style: TextStyle(color: VortexTheme.neonViolet, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ),
                const SizedBox(height: 20),
                Text(
                  'Team CypherFlow',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: VortexTheme.neonCyan,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Autonomous Real-Time Multimodal Voice Agent Framework',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: VortexTheme.textSecondary,
                      ),
                ),
                const Spacer(),
                Center(
                  child: Column(
                    children: [
                      Text(
                        _formatTime(_pitchSecondsLeft),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 110,
                          fontWeight: FontWeight.bold,
                          color: isLowTime ? Colors.redAccent : VortexTheme.textPrimary,
                          shadows: [
                            Shadow(
                              color: isLowTime ? Colors.redAccent.withOpacity(0.8) : VortexTheme.neonCyan.withOpacity(0.6),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        isLowTime ? '⚠️ TIME WRAPPING UP - JUDGE Q&A NEXT' : 'PITCHING & LIVE DEMO IN PROGRESS',
                        style: TextStyle(
                          color: isLowTime ? Colors.redAccent : VortexTheme.telemetryGreen,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Right 35%: On Deck Queue
        Expanded(
          flex: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ON DECK QUEUE',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: VortexTheme.textSecondary,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 16),
              _OnDeckCard(slot: 'Next Up (14:35)', team: 'Team VoidZero', track: 'DevTools'),
              const SizedBox(height: 12),
              _OnDeckCard(slot: 'Slot #03 (14:45)', team: 'Team QuantumPulse', track: 'HealthTech AI'),
              const SizedBox(height: 12),
              _OnDeckCard(slot: 'Slot #04 (14:55)', team: 'Team NovaMesh', track: 'Web3 & Infra'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardReveal() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(LucideIcons.sparkles, color: Colors.amberAccent, size: 28),
              SizedBox(width: 12),
              Text(
                'CLOSING CEREMONY // FINAL STANDINGS',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              SizedBox(width: 12),
              Icon(LucideIcons.sparkles, color: Colors.amberAccent, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Normalized with Automated Z-Score Judge Bias Balancing',
              style: TextStyle(color: VortexTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 32),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final allTeams = ref.watch(eventTeamProvider).allTeams.where((t) => t.totalScore > 0).toList();
                allTeams.sort((a, b) => b.totalScore.compareTo(a.totalScore));
                
                if (allTeams.isEmpty) {
                  return const Center(child: Text('No scores submitted yet.', style: TextStyle(color: VortexTheme.textSecondary)));
                }

                return ListView.builder(
                  itemCount: allTeams.length,
                  itemBuilder: (context, index) {
                    final team = allTeams[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.amberAccent.withOpacity(0.15) : VortexTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: index == 0 ? Colors.amberAccent : VortexTheme.neonCyan.withOpacity(0.3),
                            width: index == 0 ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '#${index + 1}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: index == 0 ? Colors.amberAccent : VortexTheme.neonCyan,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(team.name,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: VortexTheme.textPrimary)),
                                  Text(team.track, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 13)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: index == 0 ? Colors.amberAccent : VortexTheme.neonViolet.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${team.totalScore.toStringAsFixed(1)} PTS',
                                style: TextStyle(
                                  color: index == 0 ? Colors.black : VortexTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class _OnDeckCard extends StatelessWidget {
  final String slot;
  final String team;
  final String track;

  const _OnDeckCard({required this.slot, required this.team, required this.track});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(slot, style: const TextStyle(color: VortexTheme.neonCyan, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(team, style: const TextStyle(color: VortexTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(track, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
