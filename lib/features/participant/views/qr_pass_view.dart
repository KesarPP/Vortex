import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../core/utils/security_utils.dart';
import '../../../shared/widgets/glass_card.dart';

class QrPassContent extends StatefulWidget {
  const QrPassContent({super.key});

  @override
  State<QrPassContent> createState() => _QrPassContentState();
}

class _QrPassContentState extends State<QrPassContent> {
  final String userId = 'vortex-hacker-9042';
  late String currentHash;
  late Timer _timer;
  int countdown = 20;

  @override
  void initState() {
    super.initState();
    _updateHash();
    _startTimer();
  }

  void _updateHash() {
    setState(() {
      currentHash = SecurityUtils.generateDynamicQRHash(userId);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          countdown = 20;
          _updateHash();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DYNAMIC ACCESS PASS',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: VortexTheme.neonCyan,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: VortexTheme.telemetryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: VortexTheme.telemetryGreen),
                  ),
                  child: const Text('● CHECKED IN (GATE 01)', style: TextStyle(color: VortexTheme.telemetryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: VortexTheme.neonViolet.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: VortexTheme.neonViolet),
                  ),
                  child: const Text('TABLE #B-24', style: TextStyle(color: VortexTheme.neonViolet, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GlassCard(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: VortexTheme.neonCyan.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: QrImageView(
                      data: currentHash,
                      version: QrVersions.auto,
                      size: 220.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer_outlined, size: 18, color: VortexTheme.telemetryGreen),
                      const SizedBox(width: 6),
                      Text(
                        'Anti-Screenshot Hash: Refreshes in ${countdown}s',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: VortexTheme.telemetryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),
                  Text(
                    'DYNAMIC MEAL & SWAG CHIPS',
                    style: TextStyle(
                      color: VortexTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _CouponChip(label: 'Breakfast (8 AM)', isRedeemed: true),
                      _CouponChip(label: 'Lunch (1 PM)', isRedeemed: true),
                      _CouponChip(label: 'Midnight Snack', isRedeemed: false),
                      _CouponChip(label: 'Swag Pack', isRedeemed: false),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponChip extends StatelessWidget {
  final String label;
  final bool isRedeemed;

  const _CouponChip({required this.label, required this.isRedeemed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isRedeemed ? VortexTheme.surface : VortexTheme.neonViolet.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRedeemed ? VortexTheme.textSecondary.withOpacity(0.2) : VortexTheme.neonViolet,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRedeemed ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isRedeemed ? VortexTheme.textSecondary : VortexTheme.neonCyan,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isRedeemed ? VortexTheme.textSecondary : VortexTheme.textPrimary,
              decoration: isRedeemed ? TextDecoration.lineThrough : null,
              fontSize: 12,
              fontWeight: isRedeemed ? FontWeight.normal : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
