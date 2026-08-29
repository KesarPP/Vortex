import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vortex/main.dart';

void main() {
  testWidgets('VortexApp boots up smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: VortexApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VortexApp), findsOneWidget);
  });
}
