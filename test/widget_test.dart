import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/core/theme/vortex_theme.dart';
import 'package:vortex/shared/widgets/glass_card.dart';

void main() {
  testWidgets('Vortex UI Theme and GlassCard sanity test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: VortexTheme.darkTheme,
        home: const Scaffold(
          body: GlassCard(
            child: Text('VORTEX // OS', style: TextStyle(color: VortexTheme.neonCyan)),
          ),
        ),
      ),
    );

    expect(find.text('VORTEX // OS'), findsOneWidget);
    expect(find.byType(GlassCard), findsOneWidget);
  });
}
