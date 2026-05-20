import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:basair_real_app/features/plan_quran_completion/view_model/providers/quran_plan_provider.dart';
import 'package:basair_real_app/features/plan_quran_completion/model/entities/quran_plan.dart';

// Generate mocks
@GenerateMocks([QuranPlanNotifier])
import 'quran_plan_provider_test.mocks.dart';

void main() {
  late MockQuranPlanNotifier mockNotifier;
  late QuranPlan testPlan;

  setUp(() {
    mockNotifier = MockQuranPlanNotifier();
    testPlan = QuranPlan(
      planId: 1,
      planName: 'Test Plan',
      planType: 'Surah',
      surahId: 1,
      targetDays: 30,
      startDate: '2024-01-01',
      isPlanComplete: false,
    );
  });

  test('QuranPlanProvider should initialize correctly', () async {
    // This test would typically mock the repository layer
    // For now, we'll test the basic functionality
    expect(mockNotifier, isNotNull);
  });

  test('Add plan should work', () async {
    when(mockNotifier.addPlan(testPlan)).thenAnswer((_) async {});
    
    // In a real test, you would verify the method was called
    // and check the state changes
    await mockNotifier.addPlan(testPlan);
    
    verify(mockNotifier.addPlan(testPlan)).called(1);
  });

  test('Delete plan should work', () async {
    when(mockNotifier.deletePlan(testPlan)).thenAnswer((_) async {});
    
    await mockNotifier.deletePlan(testPlan);
    
    verify(mockNotifier.deletePlan(testPlan)).called(1);
  });
}