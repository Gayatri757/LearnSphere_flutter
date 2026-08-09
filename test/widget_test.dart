import 'package:flutter_test/flutter_test.dart';
import 'package:apex_clinician/main.dart';

void main() {
  testWidgets(
    'App loads successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const LearnSphereApp(),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(LearnSphereApp),
        findsOneWidget,
      );
    },
  );
}