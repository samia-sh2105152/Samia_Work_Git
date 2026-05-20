import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple QuranNavigator for testing
class QuranNavigator extends StatefulWidget {
  const QuranNavigator({super.key});

  @override
  State<QuranNavigator> createState() => _QuranNavigatorState();
}

class _QuranNavigatorState extends State<QuranNavigator> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Navigator'),
      ),
      body: Center(
        child: Text(
          _selectedIndex == 0 ? 'Surah Display' : 'Other Screen',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Surah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Other',
          ),
        ],
      ),
    );
  }
}

void main() {
  group('QuranNavigator Tests', () {
    testWidgets('should display initial screen', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: QuranNavigator()));

      // Assert
      expect(find.text('Quran Navigator'), findsOneWidget);
      expect(find.text('Surah Display'), findsOneWidget);
    });

    testWidgets('should have bottom navigation', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: QuranNavigator()));

      // Assert
      expect(find.text('Surah'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('should switch screens when bottom nav is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: QuranNavigator()));

      // Act
      await tester.tap(find.text('Other'));
      await tester.pump();

      // Assert
      expect(find.text('Other Screen'), findsOneWidget);
    });

    testWidgets('should switch back to Surah screen', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: QuranNavigator()));

      // Go to Other first
      await tester.tap(find.text('Other'));
      await tester.pump();

      // Act - Go back to Surah
      await tester.tap(find.text('Surah'));
      await tester.pump();

      // Assert
      expect(find.text('Surah Display'), findsOneWidget);
    });
  });
}