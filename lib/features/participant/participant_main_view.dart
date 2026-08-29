import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/vortex_theme.dart';
import '../events/views/events_catalog_view.dart';
import '../teams/views/team_dashboard_view.dart';
import 'views/team_matchmaker_view.dart';
import 'views/event_hub_view.dart';
import 'views/schedule_timeline_view.dart';
import 'views/profile_view.dart';
import 'widgets/mentor_ticket_modal.dart';
import '../events/providers/event_team_provider.dart';

class ParticipantMainView extends ConsumerStatefulWidget {
  const ParticipantMainView({super.key});

  @override
  ConsumerState<ParticipantMainView> createState() => _ParticipantMainViewState();
}

class _ParticipantMainViewState extends ConsumerState<ParticipantMainView> {
  int _currentIndex = 1; // Default to Team

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventTeamProvider);
    final activeEvent = eventState.activeEvent;
    final myTeam = eventState.myTeam;

    final List<Widget> pages = [
      EventInfoView(onNavigateToTeamDashboard: () => setState(() => _currentIndex = 1)),
      TeamDashboardView(
        onBrowseEvents: () => setState(() => _currentIndex = 0),
        onOpenMatchmaker: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamMatchmakerView()));
        },
      ),
      const EventHubView(),
      const ScheduleTimelineView(),
      const ProfileView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [VortexTheme.neonCyan, VortexTheme.neonViolet],
                ),
              ),
              child: const Icon(LucideIcons.zap, size: 16, color: Colors.black),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activeEvent?.title ?? 'VORTEX // HACKER OS',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(
                  myTeam != null
                      ? '${myTeam.name} • ${myTeam.tableNumber}'
                      : (activeEvent?.venue ?? 'Select Event'),
                  style: const TextStyle(fontSize: 11, color: VortexTheme.neonCyan),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.lifeBuoy, color: Colors.redAccent),
            tooltip: 'Summon Mentor Ticket',
            onPressed: () => MentorTicketModal.show(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: VortexTheme.neonCyan.withOpacity(0.2), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: VortexTheme.surface,
          selectedItemColor: VortexTheme.neonCyan,
          unselectedItemColor: VortexTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.info), label: 'Event Info'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.shield), label: 'Team'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.layoutGrid), label: 'Hub'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.calendar), label: 'Schedule'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
