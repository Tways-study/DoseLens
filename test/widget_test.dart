import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doselens/main.dart';

void main() {
  testWidgets('DoseLensApp initial widget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DoseLensApp(),
      ),
    );

    // Initial pump should render without unhandled exceptions
    expect(find.byType(DoseLensApp), findsOneWidget);
  });
}
