import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/event_team_provider.dart';

class EventInfoView extends ConsumerWidget {
  final VoidCallback onNavigateToTeamDashboard;

  const EventInfoView({super.key, required this.onNavigateToTeamDashboard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventTeamProvider);
    final evt = eventState.activeEvent;

    if (evt == null) {
      return const Center(child: CircularProgressIndicator(color: VortexTheme.neonCyan));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EVENT INFO',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: VortexTheme.neonCyan,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'All details for ${evt.title}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              if (evt.isRegistered)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: VortexTheme.telemetryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: VortexTheme.telemetryGreen),
                  ),
                  child: const Text('REGISTERED',
                      style: TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 20),

          GlassCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(colors: [VortexTheme.neonCyan, VortexTheme.neonViolet]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: VortexTheme.neonCyan.withOpacity(0.3), blurRadius: 16),
                        ],
                      ),
                      child: Text(evt.bannerIcon, style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evt.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: VortexTheme.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(evt.tagline, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white10),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 14, color: VortexTheme.neonCyan),
                    const SizedBox(width: 6),
                    Text(evt.date, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                    const SizedBox(width: 16),
                    const Icon(LucideIcons.mapPin, size: 14, color: VortexTheme.neonViolet),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(evt.venue,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(LucideIcons.users, size: 14, color: VortexTheme.telemetryGreen),
                    const SizedBox(width: 6),
                    Text('Required Team Size: ${evt.minTeamSize} – ${evt.maxTeamSize} Members',
                        style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: evt.tracks.map((track) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: VortexTheme.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: VortexTheme.textSecondary.withOpacity(0.2)),
                      ),
                      child: Text('#$track', style: const TextStyle(color: VortexTheme.neonCyan, fontSize: 11)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(eventTeamProvider.notifier).selectEvent(evt.id);
                      if (!evt.isRegistered) {
                        ref.read(eventTeamProvider.notifier).registerForEvent(evt.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registered for ${evt.title}! Opening Team Dashboard...')),
                        );
                      }
                      onNavigateToTeamDashboard();
                    },
                    icon: Icon(evt.isRegistered ? LucideIcons.layoutDashboard : LucideIcons.userCheck, size: 16),
                    label: Text(evt.isRegistered ? 'ENTER TEAM DASHBOARD' : 'REGISTER & FORM TEAM'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: evt.isRegistered ? VortexTheme.neonCyan : VortexTheme.neonViolet,
                      foregroundColor: evt.isRegistered ? Colors.black : Colors.white,
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
