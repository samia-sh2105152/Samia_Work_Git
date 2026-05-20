import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple QuranViewerScreen for testing
class QuranViewerScreen extends StatelessWidget {
  final int pageNumber;
  const QuranViewerScreen({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Page $pageNumber'),
      ),
      body: const Center(
        child: Text(
          'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

void main() {
  group('QuranViewerScreen Tests', () {
    testWidgets('should display correct page number', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: QuranViewerScreen(pageNumber: 1)));

      // Assert
      expect(find.text('Quran Page 1'), findsOneWidget);
    });

    testWidgets('should display Arabic text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: QuranViewerScreen(pageNumber: 1)));

      // Assert
      expect(find.text('بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ'), findsOneWidget);
    });

    testWidgets('should display different page number', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: QuranViewerScreen(pageNumber: 5)));

      // Assert
      expect(find.text('Quran Page 5'), findsOneWidget);
    });

    testWidgets('should have RTL text direction for Arabic', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: QuranViewerScreen(pageNumber: 1)));

      // Assert
      final arabicText = tester.widget<Text>(find.text('بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ'));
      expect(arabicText.textDirection, TextDirection.rtl);
    });
  });
}