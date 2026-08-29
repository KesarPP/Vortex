import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../events/providers/event_team_provider.dart';
import '../../teams/models/team_model.dart';
import '../../coupons/models/food_coupon.dart';

class TeamDashboardView extends ConsumerStatefulWidget {
  final VoidCallback onBrowseEvents;
  final VoidCallback onOpenMatchmaker;

  const TeamDashboardView({super.key, required this.onBrowseEvents, required this.onOpenMatchmaker});

  @override
  ConsumerState<TeamDashboardView> createState() => _TeamDashboardViewState();
}

class _TeamDashboardViewState extends ConsumerState<TeamDashboardView> {
  final _teamNameController = TextEditingController();
  String _selectedTrack = 'AI/ML & LLMs';

  void _showCreateTeamDialog(String eventId, int maxCapacity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VortexTheme.surface,
        title: Row(
          children: const [
            Icon(LucideIcons.users, color: VortexTheme.neonCyan),
            SizedBox(width: 10),
            Text('CREATE NEW TEAM', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _teamNameController,
              style: const TextStyle(color: VortexTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Team Name',
                hintText: 'e.g. Team NeuralHack',
                filled: true,
                fillColor: VortexTheme.background,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Text('Max Approved Capacity: $maxCapacity Members',
                style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              if (_teamNameController.text.trim().isNotEmpty) {
                ref.read(eventTeamProvider.notifier).createTeam(
                      eventId: eventId,
                      teamName: _teamNameController.text.trim(),
                      track: _selectedTrack,
                      maxCapacity: maxCapacity,
                      requiredSkills: ['Flutter', 'Python'],
                    );
                Navigator.pop(context);
                _teamNameController.clear();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.neonCyan, foregroundColor: Colors.black),
            child: const Text('CREATE SQUAD'),
          ),
        ],
      ),
    );
  }

  void _showCouponQrModal(FoodCoupon coupon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassCard(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coupon.mealType.toUpperCase(),
                          style: const TextStyle(color: VortexTheme.neonCyan, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      Text('Valid: ${coupon.validTimeWindow}', style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                  IconButton(icon: const Icon(LucideIcons.x, color: VortexTheme.textSecondary), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: VortexTheme.neonViolet.withOpacity(0.3), blurRadius: 20),
                  ],
                ),
                child: QrImageView(
                  data: coupon.qrPayload,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(coupon.isRedeemed ? LucideIcons.checkCircle : LucideIcons.scan, size: 16, color: coupon.isRedeemed ? VortexTheme.telemetryGreen : VortexTheme.neonCyan),
                  const SizedBox(width: 8),
                  Text(
                    coupon.isRedeemed
                        ? 'REDEEMED at ${coupon.redeemedLocation ?? "Venue Gate"}'
                        : 'Present to Organizer at Meal Checkpoint',
                    style: TextStyle(
                      color: coupon.isRedeemed ? VortexTheme.telemetryGreen : VortexTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventTeamProvider);
    final activeEvent = eventState.activeEvent;
    final myTeam = eventState.myTeam;

    if (activeEvent == null) {
      return Center(
        child: ElevatedButton(onPressed: widget.onBrowseEvents, child: const Text('Select an Event First')),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Context Banner
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(activeEvent.bannerIcon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activeEvent.title, style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${activeEvent.venue} • Max ${activeEvent.maxTeamSize} Members', style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                TextButton(onPressed: widget.onBrowseEvents, child: const Text('CHANGE EVENT', style: TextStyle(fontSize: 11, color: VortexTheme.neonCyan))),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // IF USER HAS NO TEAM FOR THIS EVENT
          if (myTeam == null) ...[
            Text(
              'TEAM FORMATION REQUIRED',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: VortexTheme.neonCyan, letterSpacing: 2),
            ),
            const SizedBox(height: 4),
            Text(
              'Create your squad or join open teams looking for members (Event Size: ${activeEvent.minTeamSize}-${activeEvent.maxTeamSize})',
              style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateTeamDialog(activeEvent.id, activeEvent.maxTeamSize),
                    icon: const Icon(LucideIcons.plusCircle, size: 16),
                    label: const Text('CREATE NEW TEAM', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VortexTheme.neonCyan,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onOpenMatchmaker,
                    icon: const Icon(LucideIcons.users, size: 16, color: VortexTheme.neonViolet),
                    label: const Text('FIND TEAMS', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: VortexTheme.neonViolet,
                      side: const BorderSide(color: VortexTheme.neonViolet),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            Text('OPEN TEAMS SEEKING MEMBERS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: VortexTheme.textSecondary, letterSpacing: 1.5)),
            const SizedBox(height: 12),

            ...eventState.allTeams.where((t) => t.eventId == activeEvent.id && !t.isFull).map((team) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(team.name, style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: VortexTheme.telemetryGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: VortexTheme.telemetryGreen),
                            ),
                            child: Text('${team.members.length}/${team.maxCapacity} Members',
                                style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Track: ${team.track}', style: const TextStyle(color: VortexTheme.neonViolet, fontSize: 12)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        children: team.requiredSkills.map((sk) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: VortexTheme.surface, borderRadius: BorderRadius.circular(4)),
                          child: Text('#$sk', style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 11)),
                        )).toList(),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ref.read(eventTeamProvider.notifier).requestToJoinTeam(team.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Request sent to ${team.name}!')),
                            );
                          },
                          icon: const Icon(LucideIcons.userPlus, size: 16),
                          label: const Text('REQUEST TO JOIN SQUAD'),
                          style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.neonViolet, foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ] else ...[
            // USER HAS A TEAM
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(myTeam.name.toUpperCase(),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(color: VortexTheme.neonCyan, letterSpacing: 2)),
                      Row(
                        children: [
                          Flexible(child: Text('TRACK: ${myTeam.track}', style: const TextStyle(color: VortexTheme.neonViolet, fontWeight: FontWeight.bold, fontSize: 12))),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: myTeam.isFull ? VortexTheme.telemetryGreen.withOpacity(0.2) : Colors.orangeAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: myTeam.isFull ? VortexTheme.telemetryGreen : Colors.orangeAccent),
                            ),
                            child: Text(
                              myTeam.isFull ? '● SQUAD FULL (${myTeam.members.length}/${myTeam.maxCapacity})' : '● RECRUITING (${myTeam.members.length}/${myTeam.maxCapacity})',
                              style: TextStyle(color: myTeam.isFull ? VortexTheme.telemetryGreen : Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!myTeam.isFull)
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(eventTeamProvider.notifier).addMemberToMyTeam('Devon Miles', 'Frontend Dev', '⚡');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulated Member Added to Team!')));
                    },
                    icon: const Icon(LucideIcons.userPlus, size: 14),
                    label: const Text('ADD MEMBER'),
                    style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.neonCyan, foregroundColor: Colors.black),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // TEAM QR CODE SECTION (NON-SCREENSHOT / ORGANIZER ISSUED)
            if (myTeam.isFull && myTeam.status == TeamStatus.approved) ...[
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: const [
                              Icon(LucideIcons.shieldCheck, color: VortexTheme.telemetryGreen, size: 18),
                              SizedBox(width: 8),
                              Expanded(child: Text('OFFICIAL TEAM QR PASS', style: TextStyle(color: VortexTheme.telemetryGreen, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: VortexTheme.neonViolet.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: VortexTheme.neonViolet),
                          ),
                          child: Text(myTeam.tableNumber, style: const TextStyle(color: VortexTheme.neonViolet, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: VortexTheme.neonCyan.withOpacity(0.3), blurRadius: 20),
                        ],
                      ),
                      child: QrImageView(
                        data: myTeam.teamQrPayload,
                        version: QrVersions.auto,
                        size: 220.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Team: ${myTeam.name}  •  ${myTeam.members.length} Verified Hackers',
                      style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text('Protected by OS-Level FLAG_SECURE (Non-Screenshot)', style: TextStyle(color: VortexTheme.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
            ] else ...[
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(LucideIcons.clock, color: Colors.orangeAccent, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TEAM QR PENDING FORMATION', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            'Add ${myTeam.maxCapacity - myTeam.members.length} more member(s) to reach the required ${myTeam.maxCapacity} hacker limit. Once full, the organizer will issue your official Team QR.',
                            style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // SQUAD MEMBERS LIST
            Text('SQUAD MEMBERS (${myTeam.members.length}/${myTeam.maxCapacity})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: VortexTheme.textSecondary, letterSpacing: 1.5)),
            const SizedBox(height: 12),

            ...myTeam.members.map((member) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(member.avatar, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(child: Text(member.name, style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 14))),
                                if (member.isLeader) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: VortexTheme.neonCyan.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                                    child: const Text('LEAD', style: TextStyle(color: VortexTheme.neonCyan, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                            Text(member.role, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: member.isCheckedIn ? VortexTheme.telemetryGreen.withOpacity(0.15) : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(member.isCheckedIn ? 'CHECKED IN' : 'PENDING GATE',
                            style: TextStyle(color: member.isCheckedIn ? VortexTheme.telemetryGreen : VortexTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // PENDING JOIN REQUESTS
            if (myTeam.joinRequests.isNotEmpty) ...[
              Text('PENDING JOIN REQUESTS (${myTeam.joinRequests.length})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.orangeAccent, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              
              ...myTeam.joinRequests.map((request) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(request.avatar, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(request.name, style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(request.handle, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  ref.read(eventTeamProvider.notifier).declineJoinRequest(myTeam.id, request.userId);
                                },
                                style: TextButton.styleFrom(foregroundColor: VortexTheme.textSecondary),
                                child: const Text('DECLINE'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(eventTeamProvider.notifier).acceptJoinRequest(myTeam.id, request.userId);
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: VortexTheme.neonCyan, foregroundColor: Colors.black),
                                child: const Text('ACCEPT'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // INDIVIDUAL FOOD & MEAL COUPONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('INDIVIDUAL FOOD & MEAL COUPONS',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: VortexTheme.textSecondary, letterSpacing: 1.5)),
                ),
                const Icon(LucideIcons.utensils, size: 16, color: VortexTheme.neonCyan),
              ],
            ),
            const SizedBox(height: 12),

            ...eventState.userCoupons.map((coupon) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  onTap: () => _showCouponQrModal(coupon),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: coupon.isRedeemed ? VortexTheme.surface : VortexTheme.neonViolet.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: coupon.isRedeemed ? Colors.white10 : VortexTheme.neonViolet),
                          ),
                          child: Icon(
                            coupon.isRedeemed ? LucideIcons.check : LucideIcons.qrCode,
                            color: coupon.isRedeemed ? VortexTheme.textSecondary : VortexTheme.neonCyan,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon.mealType,
                                style: TextStyle(
                                  color: coupon.isRedeemed ? VortexTheme.textSecondary : VortexTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: coupon.isRedeemed ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              Text('Valid: ${coupon.validTimeWindow}', style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 11)),
                              if (coupon.isRedeemed && coupon.redeemedLocation != null)
                                Text('📍 ${coupon.redeemedLocation} • ${coupon.redeemedAt}',
                                    style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: coupon.isRedeemed ? VortexTheme.surface : VortexTheme.neonCyan.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: coupon.isRedeemed ? Colors.white10 : VortexTheme.neonCyan),
                          ),
                          child: Text(
                            coupon.isRedeemed ? 'REDEEMED' : 'TAP FOR QR',
                            style: TextStyle(
                              color: coupon.isRedeemed ? VortexTheme.textSecondary : VortexTheme.neonCyan,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
