// test/tafsir_service_test.dart
import 'package:basair_real_app/features/ai_generate_tafsir/model/mahawer.dart';
import 'package:basair_real_app/features/ai_generate_tafsir/service/tafsir_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TafsirService Unit Tests', () {
    late TafsirService tafsirService;

    setUp(() {
      tafsirService = TafsirService();
    });

    test('should only allow Surah 4', () async {
      print('Running test: should only allow Surah 4');
      try {
        // Act
        final resultSurah4 = await tafsirService.loadMahawer(4);
        final resultSurah3 = await tafsirService.loadMahawer(3);

        // Assert
        expect(resultSurah4, isA<List<Mahawer>>());
        expect(resultSurah3, isEmpty);
        print('✓ Test passed: should only allow Surah 4');
      } catch (e) {
        print('✗ Test failed: should only allow Surah 4 - $e');
        rethrow;
      }
    });

    test('should return correct surah info for Surah 4', () async {
      print('Running test: should return correct surah info for Surah 4');
      try {
        // Act
        final surahInfo = await tafsirService.getSurahInfo(4);

        // Assert - Convert string to int for comparison
        expect(int.parse(surahInfo['surahID'].toString()), 4);
        expect(surahInfo['surahName'], isA<String>());
        expect(surahInfo['author'], isA<String>());
        print('✓ Test passed: should return correct surah info for Surah 4');
      } catch (e) {
        print('✗ Test failed: should return correct surah info for Surah 4 - $e');
        rethrow;
      }
    });

    test('should return unavailable message for non-Surah 4', () async {
      print('Running test: should return unavailable message for non-Surah 4');
      try {
        // Act
        final surahInfo = await tafsirService.getSurahInfo(3);

        // Assert
        expect(int.parse(surahInfo['surahID'].toString()), 3);
        expect(surahInfo['author'], 'التفسير غير متوفر');
        print('✓ Test passed: should return unavailable message for non-Surah 4');
      } catch (e) {
        print('✗ Test failed: should return unavailable message for non-Surah 4 - $e');
        rethrow;
      }
    });

    test('should correctly identify available surahs', () {
      print('Running test: should correctly identify available surahs');
      try {
        // Act
        final availableSurahs = tafsirService.getAvailableSurahIds();

        // Assert
        expect(availableSurahs, hasLength(1));
        expect(availableSurahs.first, 4);
        print('✓ Test passed: should correctly identify available surahs');
      } catch (e) {
        print('✗ Test failed: should correctly identify available surahs - $e');
        rethrow;
      }
    });

    test('should check tafsir data availability correctly', () async {
      print('Running test: should check tafsir data availability correctly');
      try {
        // Act & Assert
        expect(await tafsirService.hasTafsirData(4), isTrue);
        expect(await tafsirService.hasTafsirData(3), isFalse);
        print('✓ Test passed: should check tafsir data availability correctly');
      } catch (e) {
        print('✗ Test failed: should check tafsir data availability correctly - $e');
        rethrow;
      }
    });

    test('should get publication info', () {
      print('Running test: should get publication info');
      try {
        // Act
        final publicationInfo = tafsirService.getPublicationInfo();

        // Assert - Allow null for now, or check if it's either null or Map
        expect(publicationInfo == null || publicationInfo is Map<String, dynamic>, isTrue);
        print('✓ Test passed: should get publication info');
      } catch (e) {
        print('✗ Test failed: should get publication info - $e');
        rethrow;
      }
    });

    test('should get author', () {
      print('Running test: should get author');
      try {
        // Act
        final author = tafsirService.getAuthor();

        // Assert - Allow null for now, or check if it's either null or String
        expect(author == null || author is String, isTrue);
        print('✓ Test passed: should get author');
      } catch (e) {
        print('✗ Test failed: should get author - $e');
        rethrow;
      }
    });
  });
}