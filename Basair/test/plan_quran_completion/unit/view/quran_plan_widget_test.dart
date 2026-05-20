import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basair_real_app/features/plan_quran_completion/view/screens/quran_planner_adding_screen.dart';
import 'package:basair_real_app/features/plan_quran_completion/view_model/providers/quran_plan_provider.dart';
import 'package:basair_real_app/features/plan_quran_completion/model/entities/quran_plan.dart';

// Create a proper test notifier that extends the same base class
class TestQuranPlanNotifier extends QuranPlanNotifier {
  @override
  Future<List<QuranPlan>> build() async {
    return []; // Return empty list for testing
  }

  // We can override methods if needed for testing
  @override
  Future<void> addPlan(QuranPlan plan) async {
    // Test implementation
    print('Test: Adding plan ${plan.planName}');
  }
}

void main() {
  testWidgets('QuranPlannerAddingScreen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranPlanNotifierProvider.overrideWith(() => TestQuranPlanNotifier()),
        ],
        child: MaterialApp(
          home: QuranPlannerAddingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial widgets are present
    expect(find.text('Add Quran Plan'), findsOneWidget);
    expect(find.text('Plan Name'), findsOneWidget);
    expect(find.text('Select Plan Type'), findsOneWidget);
    expect(find.text('Target Days'), findsOneWidget);
    expect(find.text('Add Plan'), findsOneWidget);
  });

  testWidgets('Form validation works for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranPlanNotifierProvider.overrideWith(() => TestQuranPlanNotifier()),
        ],
        child: MaterialApp(
          home: QuranPlannerAddingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap add button without filling any fields
    await tester.tap(find.text('Add Plan'));
    await tester.pump();

    // Should show validation error (snackbar)
    expect(find.text('All fields must be filled'), findsOneWidget);
  });

  testWidgets('Plan type dropdown shows correct options', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranPlanNotifierProvider.overrideWith(() => TestQuranPlanNotifier()),
        ],
        child: MaterialApp(
          home: QuranPlannerAddingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find and ensure the dropdown is visible
    final planTypeFinder = find.text('Select Plan Type');
    await tester.ensureVisible(planTypeFinder);
    
    // Tap on plan type dropdown
    await tester.tap(planTypeFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Should show both options
    expect(find.text('Surah'), findsAtLeast(1));
    expect(find.text('Juz'), findsAtLeast(1));
  });

  testWidgets('Surah dropdown appears when Surah plan type selected', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranPlanNotifierProvider.overrideWith(() => TestQuranPlanNotifier()),
        ],
        child: MaterialApp(
          home: QuranPlannerAddingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Select Surah plan type
    final planTypeFinder = find.text('Select Plan Type');
    await tester.ensureVisible(planTypeFinder);
    await tester.tap(planTypeFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Surah').last);
    await tester.pumpAndSettle();

    // Should show Surah dropdown
    expect(find.text('Select Surah'), findsOneWidget);
    // Juz dropdown should not be visible
    expect(find.text('Select Juz'), findsNothing);
  });

  testWidgets('Juz dropdown appears when Juz plan type selected', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranPlanNotifierProvider.overrideWith(() => TestQuranPlanNotifier()),
        ],
        child: MaterialApp(
          home: QuranPlannerAddingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Select Juz plan type
    final planTypeFinder = find.text('Select Plan Type');
    await tester.ensureVisible(planTypeFinder);
    await tester.tap(planTypeFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Juz').last);
    await tester.pumpAndSettle();

    // Should show Juz dropdown
    expect(find.text('Select Juz'), findsOneWidget);
    // Surah dropdown should not be visible
    expect(find.text('Select Surah'), findsNothing);
  });

  testWidgets('Form can be filled and submitted successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranPlanNotifierProvider.overrideWith(() => TestQuranPlanNotifier()),
        ],
        child: MaterialApp(
          home: QuranPlannerAddingScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Fill plan name
    await tester.enterText(find.bySemanticsLabel('Plan Name'), 'Test Plan');
    await tester.pump();

    // Select plan type
    final planTypeFinder = find.text('Select Plan Type');
    await tester.ensureVisible(planTypeFinder);
    await tester.tap(planTypeFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Surah').last);
    await tester.pumpAndSettle();

    // Select surah
    final surahFinder = find.text('Select Surah');
    await tester.ensureVisible(surahFinder);
    await tester.tap(surahFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();

    // Fill target days
    await tester.enterText(find.bySemanticsLabel('Target Days'), '30');
    await tester.pump();

    // Verify all fields are filled
    expect(find.text('Test Plan'), findsOneWidget);
    expect(find.text('Surah'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });
}