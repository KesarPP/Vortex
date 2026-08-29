import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/shared/widgets/glass_card.dart';

void main() {
  group('GlassCard Widget Tests', () {
    testWidgets('Renders child content inside GlassCard', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: const Text('Cyberpunk Glass Content'),
            ),
          ),
        ),
      );

      expect(find.text('Cyberpunk Glass Content'), findsOneWidget);
    });

    testWidgets('Renders with custom border radius and padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              borderRadius: BorderRadius.circular(24),
              padding: const EdgeInsets.all(20),
              child: const Icon(Icons.shield),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shield), findsOneWidget);
    });
  });
}
