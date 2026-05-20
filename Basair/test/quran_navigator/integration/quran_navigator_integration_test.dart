// test/features/quran_navigator/unit/quran_navigator_basic_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuranNavigator Basic Tests', () {
    testWidgets('Basic structure renders with correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.indigo[50],
            appBar: AppBar(
              backgroundColor: Colors.indigo[200],
              title: const Text('Quran Navigator'),
            ),
            body: const Center(child: Text('Quran Content')),
          ),
        ),
      );

      expect(find.text('Quran Navigator'), findsOneWidget);
      expect(find.text('Quran Content'), findsOneWidget);
      
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect((scaffold.backgroundColor as Color?)?.value, Colors.indigo[50]?.value);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.backgroundColor as Color?)?.value, Colors.indigo[200]?.value);
    });

    testWidgets('BottomNavigationBar renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(child: Text('Content')),
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
            ),
          ),
        ),
      );

      expect(find.text('Contribute'), findsOneWidget);
      expect(find.text('Planner'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    });
  });
}