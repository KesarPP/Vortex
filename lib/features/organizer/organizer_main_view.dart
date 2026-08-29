import 'package:flutter/material.dart';
import '../auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/vortex_theme.dart';
import 'views/telemetry_dashboard_view.dart';
import 'views/team_approvals_view.dart';
import 'views/scanner_hub_view.dart';
import 'views/mentor_dispatch_grid_view.dart';
import 'views/broadcast_console_view.dart';
import 'views/scoring_bias_engine_view.dart';

import '../events/providers/event_team_provider.dart';

class OrganizerMainView extends ConsumerStatefulWidget {
  const OrganizerMainView({super.key});

  @override
  ConsumerState<OrganizerMainView> createState() => _OrganizerMainViewState();
}

class _OrganizerMainViewState extends ConsumerState<OrganizerMainView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventTeamProvider.notifier).fetchOnlyFromFirebase();
    });
  }

  final List<Widget> _views = const [
    TelemetryDashboardContent(),
    TeamApprovalsView(),
    ScannerHubView(),
    MentorDispatchGridView(),
    BroadcastConsoleView(),
    ScoringBiasEngineView(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [VortexTheme.neonCyan, VortexTheme.telemetryGreen],
                ),
              ),
              child: const Icon(LucideIcons.shieldCheck, size: 16, color: Colors.black),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'VORTEX // COMMAND CENTER',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (isDesktop)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: VortexTheme.telemetryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VortexTheme.telemetryGreen),
              ),
              child: Row(
                children: const [
                  Icon(LucideIcons.activity, size: 14, color: VortexTheme.telemetryGreen),
                  SizedBox(width: 6),
                  Text('SYSTEMS ONLINE', style: TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
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
      body: isDesktop
          ? Row(
              children: [
                NavigationRail(
                  backgroundColor: VortexTheme.surface,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  unselectedIconTheme: const IconThemeData(color: VortexTheme.textSecondary),
                  selectedIconTheme: const IconThemeData(color: VortexTheme.neonCyan),
                  labelType: NavigationRailLabelType.all,
                  selectedLabelTextStyle: const TextStyle(color: VortexTheme.neonCyan, fontWeight: FontWeight.bold, fontSize: 11),
                  unselectedLabelTextStyle: const TextStyle(color: VortexTheme.textSecondary, fontSize: 10),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(LucideIcons.layoutDashboard), label: Text('Telemetry')),
                    NavigationRailDestination(icon: Icon(LucideIcons.userCheck), label: Text('Approvals')),
                    NavigationRailDestination(icon: Icon(LucideIcons.scanLine), label: Text('Scanner Hub')),
                    NavigationRailDestination(icon: Icon(LucideIcons.lifeBuoy), label: Text('Mentors')),
                    NavigationRailDestination(icon: Icon(LucideIcons.radio), label: Text('Broadcast')),
                    NavigationRailDestination(icon: Icon(LucideIcons.scale), label: Text('Scoring Engine')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1, color: Colors.white10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _views[_selectedIndex],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _views[_selectedIndex],
                  ),
                ),
                BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  backgroundColor: VortexTheme.surface,
                  selectedItemColor: VortexTheme.neonCyan,
                  unselectedItemColor: VortexTheme.textSecondary,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) => setState(() => _selectedIndex = index),
                  items: const [
                    BottomNavigationBarItem(icon: Icon(LucideIcons.layoutDashboard), label: 'Telemetry'),
                    BottomNavigationBarItem(icon: Icon(LucideIcons.userCheck), label: 'Approvals'),
                    BottomNavigationBarItem(icon: Icon(LucideIcons.scanLine), label: 'Scanner'),
                    BottomNavigationBarItem(icon: Icon(LucideIcons.lifeBuoy), label: 'Mentors'),
                    BottomNavigationBarItem(icon: Icon(LucideIcons.radio), label: 'Broadcast'),
                    BottomNavigationBarItem(icon: Icon(LucideIcons.scale), label: 'Scoring'),
                  ],
                ),
              ],
            ),
    );
  }
}
