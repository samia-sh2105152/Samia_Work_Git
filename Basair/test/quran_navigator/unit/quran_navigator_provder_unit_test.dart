// test/features/quran_navigator/unit/quran_navigator_unit_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basair_real_app/features/quran_navigator/view/screens/quran_navigator_screen.dart';

void main() {
  group('QuranNavigator Unit Tests', () {
    
    // Helper method to wrap widget with necessary providers
    Widget wrapWithProviders(Widget child) {
      return ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => child,
              ),
              GoRoute(
                path: '/contribute',
                builder: (context, state) => const Scaffold(body: Center(child: Text('Contribute Screen'))),
              ),
              GoRoute(
                path: '/quranPlanner',
                builder: (context, state) => const Scaffold(body: Center(child: Text('Planner Screen'))),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('QuranNavigator builds with correct initial state', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithProviders(const QuranNavigator()),
      );

      // Verify initial UI components
      expect(find.text('Surah'), findsOneWidget);
      expect(find.text('Juz'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('TabBar displays correct tabs and styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithProviders(const QuranNavigator()),
      );

      // Verify tab labels
      expect(find.text('Surah'), findsOneWidget);
      expect(find.text('Juz'), findsOneWidget);

      // Verify tab styling
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.indicatorColor, Colors.black);
      expect(tabBar.labelColor, Colors.black);
      expect(tabBar.unselectedLabelColor, Colors.black54);
    });

    testWidgets('Screen has correct background and theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithProviders(const QuranNavigator()),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect((scaffold.backgroundColor as Color?)?.value, Colors.indigo[50]?.value);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.backgroundColor as Color?)?.value, Colors.indigo[200]?.value);
    });

    testWidgets('BottomNavigationBar has correct items and styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithProviders(const QuranNavigator()),
      );

      final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.items.length, 2);
      expect(bottomNavBar.items[0].label, 'Contribute');
      expect(bottomNavBar.items[1].label, 'Planner');
      expect(bottomNavBar.selectedItemColor, Colors.black);
      expect(bottomNavBar.unselectedItemColor, Colors.black54);
      expect((bottomNavBar.backgroundColor as Color?)?.value, Colors.indigo[200]?.value);
    });
  });
}