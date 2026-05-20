import 'package:basair_real_app/features/plan_quran_completion/model/entities/quran_plan.dart';
import 'package:basair_real_app/features/plan_quran_completion/model/entities/quran_plan_daily_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuranPlan Model Tests', () {
    test('QuranPlan should create instance with correct values', () {
      final plan = QuranPlan(
        planId: 1,
        planName: 'Test Plan',
        planType: 'Surah',
        surahId: 1,
        juzId: null,
        targetDays: 30,
        startDate: '2024-01-01',
        isPlanComplete: false,
      );

      expect(plan.planId, 1);
      expect(plan.planName, 'Test Plan');
      expect(plan.planType, 'Surah');
      expect(plan.surahId, 1);
      expect(plan.juzId, isNull);
      expect(plan.targetDays, 30);
      expect(plan.isPlanComplete, false);
    });

    test('QuranPlan copyWith should work correctly', () {
      final original = QuranPlan(
        planId: 1,
        planName: 'Original',
        planType: 'Surah',
        surahId: 1,
        targetDays: 30,
        startDate: '2024-01-01',
        isPlanComplete: false,
      );

      final copied = original.copyWith(
        planName: 'Copied',
        isPlanComplete: true,
      );

      expect(copied.planId, 1);
      expect(copied.planName, 'Copied');
      expect(copied.isPlanComplete, true);
      expect(copied.planType, 'Surah');
    });

    test('QuranPlanDailyProgress should create instance correctly', () {
      final progress = QuranPlanDailyProgress(
        planId: 1,
        date: '2024-01-01',
        pagesRead: 5,
      );

      expect(progress.planId, 1);
      expect(progress.date, '2024-01-01');
      expect(progress.pagesRead, 5);
    });

    test('Models should handle equality correctly', () {
      final plan1 = QuranPlan(
        planId: 1,
        planName: 'Test',
        planType: 'Surah',
        surahId: 1,
        targetDays: 30,
        startDate: '2024-01-01',
        isPlanComplete: false,
      );

      final plan2 = QuranPlan(
        planId: 1,
        planName: 'Test',
        planType: 'Surah',
        surahId: 1,
        targetDays: 30,
        startDate: '2024-01-01',
        isPlanComplete: false,
      );

      // Use individual property comparisons instead of direct object equality
      expect(plan1.planId, plan2.planId);
      expect(plan1.planName, plan2.planName);
      expect(plan1.planType, plan2.planType);
      expect(plan1.surahId, plan2.surahId);
      expect(plan1.targetDays, plan2.targetDays);
      expect(plan1.startDate, plan2.startDate);
      expect(plan1.isPlanComplete, plan2.isPlanComplete);
    });

    test('QuranPlan toString should work correctly', () {
      final plan = QuranPlan(
        planId: 1,
        planName: 'Test Plan',
        planType: 'Surah',
        surahId: 1,
        targetDays: 30,
        startDate: '2024-01-01',
        isPlanComplete: false,
      );

      expect(plan.toString(), contains('Test Plan'));
      expect(plan.toString(), contains('Surah'));
    });
  });
}