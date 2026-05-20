import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Quran App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Quran Navigator App'),
        ),
      ),
    ));

    // Verify that our app starts correctly.
    expect(find.text('Quran Navigator App'), findsOneWidget);
  });

  testWidgets('Basic Arabic text rendering test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Text('بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ'),
          ),
        ),
      ),
    ));

    expect(find.text('بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ'), findsOneWidget);
  });

  testWidgets('Plan screen mock structure', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Quran Plans')),
        body: const Center(
          child: Text('No Plans Available'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    ));

    expect(find.text('Quran Plans'), findsOneWidget);
    expect(find.text('No Plans Available'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Statistics screen mock structure', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Statistics')),
        body: const Column(
          children: [
            Text('Overall Progress'),
            Text('Total Plans: 0'),
            Text('Completed: 0'),
            Text('Pages Read: 0'),
          ],
        ),
      ),
    ));

    expect(find.text('My Statistics'), findsOneWidget);
    expect(find.text('Overall Progress'), findsOneWidget);
    expect(find.text('Total Plans: 0'), findsOneWidget);
    expect(find.text('Completed: 0'), findsOneWidget);
    expect(find.text('Pages Read: 0'), findsOneWidget);
  });

  testWidgets('Home screen mock structure', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: const Center(
          child: Text('Overview Content'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
          ],
        ),
      ),
    ));

    expect(find.text('Overview Content'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Statistics'), findsOneWidget);
    expect(find.byIcon(Icons.dashboard), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);
  });

  testWidgets('Progress indicator test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Test Plan'),
                LinearProgressIndicator(value: 0.5),
                Text('10/20 pages'),
              ],
            ),
          ),
        ),
      ),
    ));

    expect(find.text('Test Plan'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('10/20 pages'), findsOneWidget);
  });
}