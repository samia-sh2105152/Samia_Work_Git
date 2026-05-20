import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:basair_real_app/features/plan_quran_completion/view/screens/quran_planner_adding_screen.dart';
import 'package:basair_real_app/features/plan_quran_completion/view/screens/quran_planner_home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basair_real_app/features/plan_quran_completion/view_model/providers/quran_plan_provider.dart';
import 'package:basair_real_app/features/plan_quran_completion/model/entities/quran_plan.dart';

// Use the same base class for integration tests
class IntegrationTestQuranPlanNotifier extends QuranPlanNotifier {
  @override
  Future<List<QuranPlan>> build() async {
    return []; // Empty list for testing
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quran Planner Flow Test', () {
    testWidgets('Complete Quran planner flow - Adding Screen', (WidgetTester tester) async {
      // Build our app with test provider
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            quranPlanNotifierProvider.overrideWith(() => IntegrationTestQuranPlanNotifier()),
          ],
          child: MaterialApp(
            home: QuranPlannerAddingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the screen loads
      expect(find.text('Add Quran Plan'), findsOneWidget);
      expect(find.text('Plan Name'), findsOneWidget);
      expect(find.text('Select Plan Type'), findsOneWidget);
      expect(find.text('Target Days'), findsOneWidget);

      // Enter plan name
      await tester.enterText(find.bySemanticsLabel('Plan Name'), 'Test Integration Plan');
      await tester.pump();

      // Find and tap the plan type dropdown
      final planTypeFinder = find.text('Select Plan Type');
      expect(planTypeFinder, findsOneWidget);
      
      // Use ensureVisible to make sure the widget is visible and tappable
      await tester.ensureVisible(planTypeFinder);
      await tester.tap(planTypeFinder, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Select Surah plan type
      await tester.tap(find.text('Surah').last);
      await tester.pumpAndSettle();

      // Verify Surah dropdown appears
      expect(find.text('Select Surah'), findsOneWidget);

      // Tap Surah dropdown
      await tester.ensureVisible(find.text('Select Surah'));
      await tester.tap(find.text('Select Surah'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Select a surah
      await tester.tap(find.text('1').last);
      await tester.pumpAndSettle();

      // Enter target days
      await tester.enterText(find.bySemanticsLabel('Target Days'), '7');
      await tester.pump();

      // Verify all fields are filled
      expect(find.text('Test Integration Plan'), findsOneWidget);
      expect(find.text('Surah'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('Home Screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            quranPlanNotifierProvider.overrideWith(() => IntegrationTestQuranPlanNotifier()),
          ],
          child: MaterialApp(
            home: QuranPlannerHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify home screen elements
      expect(find.text('Quran Planner'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });
  });
}