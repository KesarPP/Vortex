import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/models/user_role.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  UserRole _selectedRole = UserRole.participant;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passcodeController = TextEditingController();
  bool _obscurePassword = true;

  void _showPasscodeDialog(UserRole role) {
    _passcodeController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VortexTheme.surface,
        title: Row(
          children: [
            Icon(LucideIcons.shieldAlert, color: role == UserRole.organizer ? VortexTheme.telemetryGreen : VortexTheme.neonViolet),
            const SizedBox(width: 10),
            Text(
              '${role.name.toUpperCase()} AUTH KEY',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the secure event management passcode to access ${role.name.toUpperCase()} privileges.',
              style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passcodeController,
              obscureText: true,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: VortexTheme.textPrimary, letterSpacing: 6, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'PIN: 2026',
                hintStyle: TextStyle(color: VortexTheme.textSecondary.withOpacity(0.4), letterSpacing: 2, fontSize: 14),
                filled: true,
                fillColor: VortexTheme.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('Default Organizer Passkey: 2026',
                  style: TextStyle(color: VortexTheme.neonCyan, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: VortexTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final code = _passcodeController.text.trim();
              if (code == '2026' || code == 'JUDGE2026') {
                Navigator.pop(context);
                ref.read(authProvider.notifier).quickLogin(role);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.redAccent, content: Text('Invalid Passcode! Access Denied.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: role == UserRole.organizer ? VortexTheme.telemetryGreen : VortexTheme.neonViolet,
              foregroundColor: Colors.black,
            ),
            child: const Text('AUTHENTICATE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.isInitializing) {
      return const Scaffold(
        backgroundColor: VortexTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: VortexTheme.neonCyan),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: VortexTheme.background,
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.2,
            colors: [
              VortexTheme.neonCyan.withOpacity(0.08),
              VortexTheme.neonViolet.withOpacity(0.05),
              VortexTheme.background,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Brand Header
                  Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [VortexTheme.neonCyan, VortexTheme.neonViolet],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: VortexTheme.neonCyan.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        )
                      ],
                    ),
                    child: const Icon(LucideIcons.zap, size: 34, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'VORTEX OS',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 36,
                          color: VortexTheme.textPrimary,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'SMART EVENT MANAGEMENT PLATFORM',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: VortexTheme.neonCyan,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Auth Card
                  GlassCard(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PRIMARY GOOGLE LOGIN
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: auth.isLoading
                                ? null
                                : () {
                                    ref.read(authProvider.notifier).signIn(
                                          email: '',
                                          password: '',
                                          role: UserRole.participant,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(LucideIcons.globe, color: Colors.blueAccent, size: 20),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'CONTINUE WITH GOOGLE',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.white10)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text('OR EMAIL LOGIN', style: TextStyle(color: VortexTheme.textSecondary, fontSize: 10)),
                            ),
                            Expanded(child: Divider(color: Colors.white10)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: VortexTheme.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Participant Email',
                            prefixIcon: const Icon(LucideIcons.mail, color: VortexTheme.neonCyan, size: 18),
                            filled: true,
                            fillColor: VortexTheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: VortexTheme.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(LucideIcons.lock, color: VortexTheme.neonCyan, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye, color: VortexTheme.textSecondary, size: 18),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: VortexTheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: auth.isLoading
                                ? null
                                : () {
                                    ref.read(authProvider.notifier).signIn(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          role: UserRole.participant,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VortexTheme.neonCyan,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: auth.isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                : const Text('ENTER AS PARTICIPANT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // PROTECTED ORGANIZER & JUDGE PORTAL ACCESS
                  Text('EVENT STAFF & JUDGING ACCESS',
                      style: TextStyle(color: VortexTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showPasscodeDialog(UserRole.organizer),
                          icon: const Icon(LucideIcons.shieldAlert, size: 14, color: VortexTheme.telemetryGreen),
                          label: const Text('ORGANIZER PORTAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: VortexTheme.telemetryGreen,
                            side: const BorderSide(color: VortexTheme.telemetryGreen),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showPasscodeDialog(UserRole.judge),
                          icon: const Icon(LucideIcons.award, size: 14, color: VortexTheme.neonViolet),
                          label: const Text('JUDGE PORTAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: VortexTheme.neonViolet,
                            side: const BorderSide(color: VortexTheme.neonViolet),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
