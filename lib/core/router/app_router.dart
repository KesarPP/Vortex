import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_role.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/participant/participant_main_view.dart';
import '../../features/organizer/organizer_main_view.dart';
import '../../features/judging/judging_main_view.dart';
final routerNotifierProvider = Provider<RouterNotifier>((ref) => RouterNotifier(ref));

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggingIn = state.uri.path == '/login';

      if (authState.isInitializing) {
        return null;
      }

      if (!authState.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn || state.uri.path == '/') {
        switch (authState.role) {
          case UserRole.participant:
            return '/participant';
          case UserRole.organizer:
            return '/organizer';
          case UserRole.judge:
            return '/judge';
        }
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return child;
        },
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginView(),
          ),
          GoRoute(
            path: '/participant',
            builder: (context, state) => const ParticipantMainView(),
          ),
          GoRoute(
            path: '/organizer',
            builder: (context, state) => const OrganizerMainView(),
          ),
          GoRoute(
            path: '/judge',
            builder: (context, state) => const JudgingMainView(),
          ),
        ],
      ),
    ],
  );
});
