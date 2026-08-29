import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/features/auth/providers/auth_provider.dart';
import 'package:vortex/shared/models/user_role.dart';

void main() {
  group('Auth Model and State Tests', () {
    test('AuthUserState defaults and copyWith', () {
      final initial = AuthUserState(isInitializing: false);
      expect(initial.isAuthenticated, false);
      expect(initial.role, UserRole.participant);
      expect(initial.uid, isNull);

      final loggedIn = initial.copyWith(
        isAuthenticated: true,
        uid: 'user-777',
        email: 'hacker@vortex.dev',
        role: UserRole.organizer,
      );

      expect(loggedIn.isAuthenticated, true);
      expect(loggedIn.uid, 'user-777');
      expect(loggedIn.email, 'hacker@vortex.dev');
      expect(loggedIn.role, UserRole.organizer);
    });
  });
}
