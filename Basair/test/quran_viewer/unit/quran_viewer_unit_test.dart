// test/unit/quran_viewer_unit_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:basair_real_app/features/quran_viewer/view/screens/quran_viewer_screen.dart';

void main() {
  group('kAudioUrl Function Tests', () {
    test('should generate correct audio URL with 3-digit padding', () {
      expect(kAudioUrl(1, 1), 'https://everyayah.com/data/Alafasy_128kbps/001001.mp3');
      expect(kAudioUrl(10, 15), 'https://everyayah.com/data/Alafasy_128kbps/010015.mp3');
      expect(kAudioUrl(114, 6), 'https://everyayah.com/data/Alafasy_128kbps/114006.mp3');
    });

    test('should handle edge cases correctly', () {
      expect(kAudioUrl(9, 1), 'https://everyayah.com/data/Alafasy_128kbps/009001.mp3');
      expect(kAudioUrl(99, 99), 'https://everyayah.com/data/Alafasy_128kbps/099099.mp3');
    });
  });

  group('kAyahCount Map Tests', () {
    test('should contain all 114 surahs', () {
      expect(kAyahCount.length, 114);
    });

    test('should have correct ayah counts for specific surahs', () {
      expect(kAyahCount[1], 7); // Al-Fatihah
      expect(kAyahCount[2], 286); // Al-Baqarah
      expect(kAyahCount[36], 83); // Ya-Seen
      expect(kAyahCount[55], 78); // Ar-Rahman
      expect(kAyahCount[112], 4); // Al-Ikhlas
      expect(kAyahCount[114], 6); // An-Nas
    });

    test('should not contain invalid surah numbers', () {
      expect(kAyahCount.containsKey(0), false);
      expect(kAyahCount.containsKey(115), false);
      expect(kAyahCount.containsKey(-1), false);
    });
  });

  group('Global Player Navigation Logic', () {
    test('nextGlobal should move to next ayah in same surah', () {
      expect(_testNextGlobal(1, 1), (1, 2));
      expect(_testNextGlobal(1, 6), (1, 7));
      expect(_testNextGlobal(2, 100), (2, 101));
    });

    test('nextGlobal should move to next surah when at last ayah', () {
      expect(_testNextGlobal(1, 7), (2, 1)); // Fatihah to Baqarah
      expect(_testNextGlobal(113, 5), (114, 1)); // Al-Falaq to An-Nas
    });

    test('nextGlobal should wrap from surah 114 to surah 1', () {
      expect(_testNextGlobal(114, 6), (1, 1)); // End of Quran to beginning
    });

    test('prevGlobal should move to previous ayah in same surah', () {
      expect(_testPrevGlobal(1, 2), (1, 1));
      expect(_testPrevGlobal(2, 10), (2, 9));
      expect(_testPrevGlobal(114, 6), (114, 5));
    });

    test('prevGlobal should move to previous surah when at first ayah', () {
      expect(_testPrevGlobal(2, 1), (1, 7)); // Baqarah to Fatihah
      expect(_testPrevGlobal(114, 1), (113, 5)); // An-Nas to Al-Falaq
    });

    test('prevGlobal should wrap from surah 1 to surah 114', () {
      expect(_testPrevGlobal(1, 1), (114, 6)); // Beginning to end of Quran
    });
  });

  group('Download Surah Logic Tests', () {
    test('should calculate correct download counts for different surahs', () {
      // Surah 1 (Al-Fatihah) - starts from 1, no Bismillah to skip
      expect(_testDownloadCount(1), (1, 7));
      
      // Surah 9 (At-Tawbah) - no Bismillah
      expect(_testDownloadCount(9), (1, 129));
      
      // Surah 2 (Al-Baqarah) - has Bismillah
      expect(_testDownloadCount(2), (0, 287)); // 0-286 + Bismillah
      
      // Surah 114 (An-Nas) - has Bismillah
      expect(_testDownloadCount(114), (0, 7)); // 0-6 + Bismillah
    });

    test('should handle all surah types correctly', () {
      // First surah
      expect(_testDownloadCount(1), (1, 7));
      
      // Surah without Bismillah
      expect(_testDownloadCount(9), (1, 129));
      
      // Regular surah with Bismillah
      expect(_testDownloadCount(10), (0, 110)); // 0-109 + Bismillah
      
      // Last surah
      expect(_testDownloadCount(114), (0, 7));
    });
  });

  group('Page Navigation Logic', () {
    test('should allow navigation within valid page range', () {
      expect(_testCanNavigateToPage(1, 'prev'), false);
      expect(_testCanNavigateToPage(1, 'next'), true);
      expect(_testCanNavigateToPage(604, 'next'), false);
      expect(_testCanNavigateToPage(604, 'prev'), true);
      expect(_testCanNavigateToPage(300, 'next'), true);
      expect(_testCanNavigateToPage(300, 'prev'), true);
    });
  });
}

// Helper functions to test the navigation logic without accessing private classes
(int, int) _testNextGlobal(int currentSurah, int currentAyah) {
  final totalAyahs = kAyahCount[currentSurah]!;
  if (currentAyah < totalAyahs) {
    return (currentSurah, currentAyah + 1);
  } else {
    final nextSurah = (currentSurah < 114) ? currentSurah + 1 : 1;
    return (nextSurah, 1);
  }
}

(int, int) _testPrevGlobal(int currentSurah, int currentAyah) {
  if (currentAyah > 1) {
    return (currentSurah, currentAyah - 1);
  } else {
    final prevSurah = (currentSurah > 1) ? currentSurah - 1 : 114;
    return (prevSurah, kAyahCount[prevSurah]!);
  }
}

// Helper for download count logic
(int startNumber, int totalToDownload) _testDownloadCount(int surahId) {
  final ayahCount = kAyahCount[surahId]!;
  int startNumber;
  int totalToDownload;

  if (surahId == 1) {
    startNumber = 1;
    totalToDownload = ayahCount;
  } else if (surahId == 9) {
    startNumber = 1;
    totalToDownload = ayahCount;
  } else {
    startNumber = 0; // Includes Bismillah
    totalToDownload = ayahCount + 1;
  }

  return (startNumber, totalToDownload);
}

// Helper for page navigation logic
bool _testCanNavigateToPage(int currentPage, String direction) {
  if (direction == 'next') {
    return currentPage < 604;
  } else if (direction == 'prev') {
    return currentPage > 1;
  }
  return false;
}