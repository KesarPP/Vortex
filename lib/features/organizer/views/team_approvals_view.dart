import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../events/providers/event_team_provider.dart';
import '../../teams/models/team_model.dart';

class TeamApprovalsView extends ConsumerStatefulWidget {
  const TeamApprovalsView({super.key});

  @override
  ConsumerState<TeamApprovalsView> createState() => _TeamApprovalsViewState();
}

class _TeamApprovalsViewState extends ConsumerState<TeamApprovalsView> {
  final _tableInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventTeamProvider);

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
                    'TEAM APPROVALS & QR ISSUANCE',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: VortexTheme.neonCyan,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Verify squad capacity limits, assign physical tables, and dispatch Team QR Passes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: VortexTheme.telemetryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: VortexTheme.telemetryGreen),
                ),
                child: Text('${eventState.allTeams.length} REGISTERED SQUADS',
                    style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ...eventState.allTeams.map((team) {
            final isApproved = team.status == TeamStatus.approved;
            final isFull = team.isFull;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(team.name, style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isApproved ? VortexTheme.telemetryGreen.withOpacity(0.2) : Colors.orangeAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isApproved ? VortexTheme.telemetryGreen : Colors.orangeAccent),
                              ),
                              child: Text(
                                isApproved ? 'APPROVED (QR ACTIVE)' : isFull ? 'PENDING TABLE ASSIGNMENT' : 'RECRUITING (${team.members.length}/${team.maxCapacity})',
                                style: TextStyle(color: isApproved ? VortexTheme.telemetryGreen : Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Text('Track: ${team.track}', style: const TextStyle(color: VortexTheme.neonViolet, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Team Members Chip Row
                    Text('Verified Members (${team.members.length}/${team.maxCapacity}):',
                        style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: team.members.map((m) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: VortexTheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.avatar, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text('${m.name} (${m.role})', style: const TextStyle(color: VortexTheme.textPrimary, fontSize: 12)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 14, color: VortexTheme.neonCyan),
                            const SizedBox(width: 6),
                            Text('Assigned Location: ${team.tableNumber}', style: const TextStyle(color: VortexTheme.neonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        if (!isApproved)
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.read(eventTeamProvider.notifier).approveTeamByOrganizer(team.id, 'Table B-${team.members.length * 7}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Approved ${team.name}! Official Team QR Pass dispatched.')),
                              );
                            },
                            icon: const Icon(LucideIcons.checkCheck, size: 14),
                            label: const Text('APPROVE & ISSUE TEAM QR'),
                            style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.neonCyan, foregroundColor: Colors.black),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: VortexTheme.surface, borderRadius: BorderRadius.circular(6)),
                            child: const Text('✅ QR Active & Synced on Participant Dashboard', style: TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
