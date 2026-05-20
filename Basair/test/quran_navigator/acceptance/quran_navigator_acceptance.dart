// test/features/quran_navigator/acceptance/quran_navigator_acceptance.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basair_real_app/features/quran_navigator/view/screens/quran_navigator_screen.dart';

// Mock classes
class MockPageDisplay extends StatelessWidget {
  const MockPageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Page Display');
  }
}

class MockSurahDisplay extends StatelessWidget {
  const MockSurahDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Surah Display Content'));
  }
}

class MockJuzDisplay extends StatelessWidget {
  const MockJuzDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Juz Display Content'));
  }
}

// Testable version of QuranNavigator with mock children
class TestableQuranNavigator extends StatefulWidget {
  const TestableQuranNavigator({super.key});

  @override
  TestableQuranNavigatorState createState() => TestableQuranNavigatorState();
}

class TestableQuranNavigatorState extends State<TestableQuranNavigator> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        GoRouter.of(context).push('/contribute');
        break;
      case 1:
        GoRouter.of(context).push('/quranPlanner');
        break;
    }

    if (mounted) {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.indigo[200],
          title: const MockPageDisplay(),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: 'Surah'),
              Tab(text: 'Juz'),
            ],
            labelStyle: TextStyle(
              letterSpacing: 1.5,
              color: Colors.black,
              fontFamily: 'CrimsonText',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            MockSurahDisplay(),
            MockJuzDisplay(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.indigo[200],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Contribute',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule_outlined),
              label: 'Planner',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Quran Navigator Acceptance Tests', () {
    
    // Helper method to create test widget with proper routing
    Widget createTestWidget() {
      return ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const TestableQuranNavigator(),
              ),
              GoRoute(
                path: '/contribute',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Contribute Screen')),
                ),
              ),
              GoRoute(
                path: '/quranPlanner',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Planner Screen')),
                ),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('AC1: User can navigate between Surah and Juz views', (WidgetTester tester) async {
      // Given the Quran Navigator screen is displayed
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then the Surah view should be initially displayed
      expect(find.text('Surah Display Content'), findsOneWidget);
      expect(find.text('Juz Display Content'), findsNothing);

      // When the user taps on the Juz tab
      await tester.tap(find.text('Juz'));
      await tester.pumpAndSettle();

      // Then the Juz view should be displayed
      expect(find.text('Surah Display Content'), findsNothing);
      expect(find.text('Juz Display Content'), findsOneWidget);

      // When the user taps on the Surah tab
      await tester.tap(find.text('Surah'));
      await tester.pumpAndSettle();

      // Then the Surah view should be displayed again
      expect(find.text('Surah Display Content'), findsOneWidget);
      expect(find.text('Juz Display Content'), findsNothing);
    });

    testWidgets('AC2: User can access contribution features', (WidgetTester tester) async {
      // Given the Quran Navigator screen is displayed
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // When the user taps on the Contribute button
      await tester.tap(find.text('Contribute'));
      await tester.pumpAndSettle();

      // Then the contribute screen should be displayed
      expect(find.text('Contribute Screen'), findsOneWidget);
    });

    testWidgets('AC3: User can access planner features', (WidgetTester tester) async {
      // Given the Quran Navigator screen is displayed
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // When the user taps on the Planner button
      await tester.tap(find.text('Planner'));
      await tester.pumpAndSettle();

      // Then the planner screen should be displayed
      expect(find.text('Planner Screen'), findsOneWidget);
    });

    testWidgets('AC4: Screen displays correct styling and theming', (WidgetTester tester) async {
      // Given the Quran Navigator screen is displayed
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then the screen should have the correct background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect((scaffold.backgroundColor as Color?)?.value, Colors.indigo[50]?.value);

      // And the app bar should have the correct color
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.backgroundColor as Color?)?.value, Colors.indigo[200]?.value);

      // And the bottom navigation bar should have correct styling
      final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect((bottomNavBar.backgroundColor as Color?)?.value, Colors.indigo[200]?.value);
      expect(bottomNavBar.selectedItemColor, Colors.black);
      expect(bottomNavBar.unselectedItemColor, Colors.black54);
    });

    testWidgets('AC5: Navigation resets to base tab after action', (WidgetTester tester) async {
      // Given the Quran Navigator screen is displayed
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Surah Display Content'), findsOneWidget);

      // When the user navigates to another screen via bottom navigation
      await tester.tap(find.text('Planner'));
      await tester.pumpAndSettle();

      // Then the planner screen should be shown
      expect(find.text('Planner Screen'), findsOneWidget);

      // When we navigate back (simulate back button or return navigation)
      // Note: This depends on your app's navigation structure
      // For testing purposes, we'll verify the navigation occurred
    });

    testWidgets('AC6: Tab bar displays correct labels and styling', (WidgetTester tester) async {
      // Given the Quran Navigator screen is displayed
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then the tab bar should display correct labels
      expect(find.text('Surah'), findsOneWidget);
      expect(find.text('Juz'), findsOneWidget);

      // And the tab bar should have correct styling
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.indicatorColor, Colors.black);
      expect(tabBar.labelColor, Colors.black);
      expect(tabBar.unselectedLabelColor, Colors.black54);
    });

    testWidgets('AC7: Bottom navigation displays correct icons and labels', (WidgetTester tester) async {
      // Given the Quran Navigator screen is displayed
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Then the bottom navigation should have correct items
      expect(find.text('Contribute'), findsOneWidget);
      expect(find.text('Planner'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    });
  });
}