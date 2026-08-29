import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/vortex_theme.dart';
import '../../shared/models/user_role.dart';
import '../../features/auth/providers/auth_provider.dart';

class RoleSwitcherOverlay extends ConsumerWidget {
  const RoleSwitcherOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (!auth.isAuthenticated) return const SizedBox.shrink();

    return Positioned(
      bottom: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: VortexTheme.neonCyan.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: VortexTheme.neonCyan.withOpacity(0.2),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.userCog, size: 14, color: VortexTheme.neonCyan),
              const SizedBox(width: 6),
              DropdownButton<UserRole>(
                value: auth.role,
                dropdownColor: VortexTheme.surface,
                underline: const SizedBox(),
                isDense: true,
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(
                      role.name.toUpperCase(),
                      style: const TextStyle(
                        color: VortexTheme.neonCyan,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newRole) {
                  if (newRole != null) {
                    ref.read(authProvider.notifier).quickLogin(newRole);
                  }
                },
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(LucideIcons.logOut, size: 14, color: Colors.redAccent),
                tooltip: 'Sign Out',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => ref.read(authProvider.notifier).signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
