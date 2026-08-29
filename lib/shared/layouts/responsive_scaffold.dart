import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/vortex_theme.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  
  const ResponsiveScaffold({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    
    if (isDesktop) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: VortexTheme.surface,
              selectedIndex: 0,
              onDestinationSelected: (index) {
                // Handle navigation logic
              },
              unselectedIconTheme: const IconThemeData(color: VortexTheme.textSecondary),
              selectedIconTheme: const IconThemeData(color: VortexTheme.neonCyan),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(LucideIcons.layoutDashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(LucideIcons.qrCode),
                  label: Text('QR Pass'),
                ),
                NavigationRailDestination(
                  icon: Icon(LucideIcons.star),
                  label: Text('Judging'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1, color: Colors.black26),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: child,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: VortexTheme.surface,
        selectedItemColor: VortexTheme.neonCyan,
        unselectedItemColor: VortexTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layoutDashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.qrCode),
            label: 'QR Pass',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.star),
            label: 'Judging',
          ),
        ],
      ),
    );
  }
}
