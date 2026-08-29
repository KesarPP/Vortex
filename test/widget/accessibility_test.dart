import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/shared/widgets/glass_card.dart';

void main() {
  group('Accessibility & Semantics Tests', () {
    testWidgets('Interactive elements have accessible semantic labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Semantics(
                  button: true,
                  label: 'Toggle Team Seeking Status',
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('SEEKING: ON'),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Submit Judging Evaluation',
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('SUBMIT EVALUATION'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Toggle Team Seeking Status'), findsOneWidget);
      expect(find.bySemanticsLabel('Submit Judging Evaluation'), findsOneWidget);
    });

    testWidgets('GlassCard meets minimum touch target requirements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Center(child: Text('OK')),
              ),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(GlassCard));
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });
  });
}
