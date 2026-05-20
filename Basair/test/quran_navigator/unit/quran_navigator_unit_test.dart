// test/features/quran_navigator/unit/quran_navigator_unit_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuranNavigator Unit Tests', () {
    
    Widget createTestQuranNavigator() {
      return MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.indigo[50],
            appBar: AppBar(
              backgroundColor: Colors.indigo[200],
              title: const Text('Page Display'),
              bottom: const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'Surah'),
                  Tab(text: 'Juz'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                Center(child: Text('Surah Display')),
                Center(child: Text('Juz Display')),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
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
              onTap: (index) {},
            ),
          ),
        ),
      );
    }

    testWidgets('QuranNavigator builds with correct initial state', (WidgetTester tester) async {
      await tester.pumpWidget(createTestQuranNavigator());

      expect(find.text('Surah'), findsOneWidget);
      expect(find.text('Juz'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Surah Display'), findsOneWidget);
    });

    testWidgets('TabBar displays correct tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createTestQuranNavigator());

      expect(find.text('Surah'), findsOneWidget);
      expect(find.text('Juz'), findsOneWidget);

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.indicatorColor, Colors.black);
      expect(tabBar.labelColor, Colors.black);
      expect(tabBar.unselectedLabelColor, Colors.black54);
    });

    testWidgets('Screen has correct background colors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestQuranNavigator());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect((scaffold.backgroundColor as Color?)?.value, Colors.indigo[50]?.value);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.backgroundColor as Color?)?.value, Colors.indigo[200]?.value);
    });

    testWidgets('BottomNavigationBar has correct items', (WidgetTester tester) async {
      await tester.pumpWidget(createTestQuranNavigator());

      final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.items.length, 2);
      expect(bottomNavBar.items[0].label, 'Contribute');
      expect(bottomNavBar.items[1].label, 'Planner');
    });

    testWidgets('Tab switching works', (WidgetTester tester) async {
      await tester.pumpWidget(createTestQuranNavigator());

      expect(find.text('Surah Display'), findsOneWidget);
      expect(find.text('Juz Display'), findsNothing);

      await tester.tap(find.text('Juz'));
      await tester.pumpAndSettle();

      expect(find.text('Surah Display'), findsNothing);
      expect(find.text('Juz Display'), findsOneWidget);
    });
  });
}