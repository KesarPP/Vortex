import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../core/utils/matchmaker_engine.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/team_invitation.dart';
import '../providers/participant_provider.dart';

import '../../events/providers/event_team_provider.dart';
import '../../teams/models/team_model.dart';

class TeamMatchmakerView extends ConsumerStatefulWidget {
  const TeamMatchmakerView({super.key});

  @override
  ConsumerState<TeamMatchmakerView> createState() => _TeamMatchmakerViewState();
}

class _TeamMatchmakerViewState extends ConsumerState<TeamMatchmakerView> {
  int _activeTab = 0; // 0: Discover Teams, 1: Invites Inbox

  @override
  Widget build(BuildContext context) {
    final myProfile = ref.watch(participantProfileProvider);
    final invitations = ref.watch(invitationsProvider);
    final pendingInvitesCount = invitations.where((i) => i.status == InvitationStatus.pending).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matchmaker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
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
                            'TEAM MATCHMAKER',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: VortexTheme.neonCyan,
                                  letterSpacing: 2,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Skill-gap vector pairing engine',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: VortexTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: VortexTheme.neonViolet),
                      ),
                      child: Row(
                        children: const [
                          Icon(LucideIcons.sparkles, size: 14, color: VortexTheme.neonViolet),
                          SizedBox(width: 6),
                          Text('AI MATCH ACTIVE', style: TextStyle(color: VortexTheme.neonViolet, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tabs: Discover vs Invites Inbox
                SegmentedButton<int>(
                  segments: [
                    const ButtonSegment(value: 0, icon: Icon(LucideIcons.compass, size: 16), label: Text('Discover Teams')),
                    ButtonSegment(
                      value: 1,
                      icon: Icon(LucideIcons.mail, size: 16),
                      label: Text('Inbox ($pendingInvitesCount)'),
                    ),
                  ],
                  selected: {_activeTab},
                  onSelectionChanged: (set) => setState(() => _activeTab = set.first),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) return VortexTheme.neonCyan.withOpacity(0.2);
                      return VortexTheme.surface;
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                if (_activeTab == 0) ...[
                  // User skills matching banner
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.target, size: 18, color: VortexTheme.neonCyan),
                        const SizedBox(width: 10),
                        Text('Matching: ', style: TextStyle(color: VortexTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            children: myProfile.lookingFor.map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: VortexTheme.neonCyan.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: VortexTheme.neonCyan.withOpacity(0.4)),
                              ),
                              child: Text('#$tag', style: const TextStyle(color: VortexTheme.neonCyan, fontSize: 11)),
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Candidate Teams
                  ...ref.watch(eventTeamProvider).allTeams.where((t) => t.status == TeamStatus.recruiting).map((team) {
                    final int matchScore = MatchmakerEngine.calculateCompatibility(
                      userSkills: myProfile.skills,
                      userLookingFor: myProfile.lookingFor,
                      targetSkills: team.requiredSkills.toSet(),
                      targetLookingFor: [],
                    );

                    final Color scoreColor = matchScore >= 80
                        ? VortexTheme.telemetryGreen
                        : matchScore >= 60
                            ? VortexTheme.neonCyan
                            : Colors.orangeAccent;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: VortexTheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: scoreColor.withOpacity(0.5)),
                                  ),
                                  child: const Text('👥', style: TextStyle(fontSize: 24)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              team.name,
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: VortexTheme.textPrimary,
                                                  ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: scoreColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: scoreColor),
                                            ),
                                            child: Text(
                                              '$matchScore% Match',
                                              style: TextStyle(
                                                color: scoreColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Track: ${team.track} • ${team.members.length}/${team.maxCapacity} Members',
                                        style: const TextStyle(color: VortexTheme.neonViolet, fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('Recruiting for our hackathon project!', style: TextStyle(color: VortexTheme.textSecondary, fontSize: 13)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: team.requiredSkills.map((skill) {
                                final isDesired = myProfile.lookingFor.contains(skill) || myProfile.skills.contains(skill);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDesired ? VortexTheme.telemetryGreen.withOpacity(0.2) : VortexTheme.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isDesired ? VortexTheme.telemetryGreen : VortexTheme.textSecondary.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Text(
                                    '#$skill',
                                    style: TextStyle(
                                      color: isDesired ? VortexTheme.telemetryGreen : VortexTheme.textSecondary,
                                      fontSize: 11,
                                      fontWeight: isDesired ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ref.read(eventTeamProvider.notifier).requestToJoinTeam(team.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: VortexTheme.surface,
                                          content: Row(
                                            children: [
                                              const Icon(LucideIcons.checkCircle, color: VortexTheme.telemetryGreen),
                                              const SizedBox(width: 8),
                                              Text('Request sent to ${team.name}!'),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(LucideIcons.userPlus, size: 16),
                                    label: const Text('REQUEST TO JOIN TEAM'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: VortexTheme.neonCyan,
                                      foregroundColor: VortexTheme.background,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ] else ...[
                  // Inbox Tab
                  if (invitations.isEmpty)
                    const Center(child: Text('No invitations in inbox.', style: TextStyle(color: VortexTheme.textSecondary)))
                  else
                    ...invitations.map((inv) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(inv.avatar, style: const TextStyle(fontSize: 22)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(inv.senderName, style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold)),
                                              Text('Invites you to join ${inv.teamName}', style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: VortexTheme.telemetryGreen.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('${inv.compatibilityScore}% Match', style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (inv.status == InvitationStatus.pending)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => ref.read(invitationsProvider.notifier).declineInvitation(inv.id),
                                      style: TextButton.styleFrom(foregroundColor: VortexTheme.textSecondary),
                                      child: const Text('DECLINE'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.read(invitationsProvider.notifier).acceptInvitation(inv.id);
                                        ref.read(participantProfileProvider.notifier).updateProfile(teamName: inv.teamName);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.neonCyan, foregroundColor: Colors.black),
                                      child: const Text('ACCEPT & JOIN'),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  inv.status == InvitationStatus.accepted ? '✅ ACCEPTED & TEAM JOINED' : '❌ DECLINED',
                                  style: TextStyle(
                                    color: inv.status == InvitationStatus.accepted ? VortexTheme.telemetryGreen : Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
