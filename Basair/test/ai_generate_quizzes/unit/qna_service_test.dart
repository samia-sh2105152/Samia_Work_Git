// test/ai_generate_quizzes/unit/qna_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:basair_real_app/features/ai_generate_quizzes/service/qna_service.dart';
import 'package:basair_real_app/features/ai_generate_tafsir/service/tafsir_service.dart';
import 'package:basair_real_app/features/ai_generate_quizzes/model/quiz.dart';

class MockTafsirService extends Mock implements TafsirService {}

void main() {
  group('QnAService Unit Tests', () {
    late QnAService qnaService;
    late MockTafsirService mockTafsirService;

    setUp(() async {
      mockTafsirService = MockTafsirService();
      
      // Setup environment variables for testing
      dotenv.testLoad(fileInput: 'OPENAI_API_KEY=test_api_key_123');

      qnaService = QnAService(
        tafsirService: mockTafsirService,
        baseUrl: 'https://api.test-openai.com/v1',
      );
    });

    test('should submit answer and return evaluated question for correct answer', () async {
      print('Running test: should submit answer and return evaluated question for correct answer');
      try {
        // Arrange
        final question = QuizQuestion(
          id: '1',
          question: 'Test question',
          questionType: 'mcq',
          correctAnswer: 'a',
          selectableOptions: [
            SelectableOption(value: 'a', displayText: 'Option A', isSelected: false),
            SelectableOption(value: 'b', displayText: 'Option B', isSelected: false),
          ],
          feedback: 'Test feedback',
          sourceSection: 'Test Section',
        );

        // Act
        final result = await qnaService.submitAnswer(question, 'a');

        // Assert
        expect(result.userAnswer, 'a');
        expect(result.isCorrect, isTrue);
        expect(result.feedback, contains('EXCELLENT'));
        print('✓ PASSED: should submit answer and return evaluated question for correct answer');
      } catch (e) {
        print('✗ FAILED: should submit answer and return evaluated question for correct answer - $e');
        rethrow;
      }
    });

    test('should submit answer and return evaluated question for wrong answer', () async {
      print('Running test: should submit answer and return evaluated question for wrong answer');
      try {
        // Arrange
        final question = QuizQuestion(
          id: '1',
          question: 'Test question',
          questionType: 'mcq',
          correctAnswer: 'a',
          selectableOptions: [
            SelectableOption(value: 'a', displayText: 'Option A', isSelected: false),
            SelectableOption(value: 'b', displayText: 'Option B', isSelected: false),
          ],
          feedback: 'Test feedback',
          sourceSection: 'Test Section',
        );

        // Act
        final result = await qnaService.submitAnswer(question, 'b');

        // Assert
        expect(result.userAnswer, 'b');
        expect(result.isCorrect, isFalse);
        expect(result.feedback, contains('LEARNING OPPORTUNITY'));
        print('✓ PASSED: should submit answer and return evaluated question for wrong answer');
      } catch (e) {
        print('✗ FAILED: should submit answer and return evaluated question for wrong answer - $e');
        rethrow;
      }
    });

    test('should calculate quiz results correctly', () async {
      print('Running test: should calculate quiz results correctly');
      try {
        // Arrange
        final questions = [
          QuizQuestion(
            id: '1',
            question: 'Question 1',
            questionType: 'mcq',
            correctAnswer: 'a',
            selectableOptions: [
              SelectableOption(value: 'a', displayText: 'Correct', isSelected: false),
              SelectableOption(value: 'b', displayText: 'Wrong', isSelected: false),
            ],
            userAnswer: 'a',
            isCorrect: true,
            sourceSection: 'Section 1',
          ),
          QuizQuestion(
            id: '2',
            question: 'Question 2',
            questionType: 'mcq',
            correctAnswer: 'b',
            selectableOptions: [
              SelectableOption(value: 'a', displayText: 'Wrong', isSelected: false),
              SelectableOption(value: 'b', displayText: 'Correct', isSelected: false),
            ],
            userAnswer: 'a', // Wrong answer
            isCorrect: false,
            sourceSection: 'Section 2',
          ),
        ];

        // Act
        final result = await qnaService.calculateResults(questions, 'Surah Al-Nisa');

        // Assert
        expect(result.score, 50); // 1 out of 2 correct = 50%
        expect(result.correctAnswers, 1);
        expect(result.totalQuestions, 2);
        expect(result.incorrectQuestions, hasLength(1));
        expect(result.performanceLevel, isA<String>());
        expect(result.detailedFeedback, contains('SURAH AL-NISA QUIZ RESULTS'));
        print('✓ PASSED: should calculate quiz results correctly');
      } catch (e) {
        print('✗ FAILED: should calculate quiz results correctly - $e');
        rethrow;
      }
    });

    test('should calculate perfect score results', () async {
      print('Running test: should calculate perfect score results');
      try {
        // Arrange
        final questions = [
          QuizQuestion(
            id: '1',
            question: 'Question 1',
            questionType: 'mcq',
            correctAnswer: 'a',
            selectableOptions: [
              SelectableOption(value: 'a', displayText: 'Correct', isSelected: false),
              SelectableOption(value: 'b', displayText: 'Wrong', isSelected: false),
            ],
            userAnswer: 'a',
            isCorrect: true,
            sourceSection: 'Section 1',
          ),
          QuizQuestion(
            id: '2',
            question: 'Question 2',
            questionType: 'mcq',
            correctAnswer: 'b',
            selectableOptions: [
              SelectableOption(value: 'a', displayText: 'Wrong', isSelected: false),
              SelectableOption(value: 'b', displayText: 'Correct', isSelected: false),
            ],
            userAnswer: 'b',
            isCorrect: true,
            sourceSection: 'Section 2',
          ),
        ];

        // Act
        final result = await qnaService.calculateResults(questions, 'Surah Al-Nisa');

        // Assert
        expect(result.score, 100);
        expect(result.correctAnswers, 2);
        expect(result.totalQuestions, 2);
        expect(result.incorrectQuestions, isEmpty);
        expect(result.performanceLevel, 'Quran Scholar 🏆');
        print('✓ PASSED: should calculate perfect score results');
      } catch (e) {
        print('✗ FAILED: should calculate perfect score results - $e');
        rethrow;
      }
    });

    test('should handle empty questions list in results calculation', () async {
      print('Running test: should handle empty questions list in results calculation');
      try {
        // Arrange
        final questions = <QuizQuestion>[];

        // Act
        final result = await qnaService.calculateResults(questions, 'Surah Al-Nisa');

        // Assert
        expect(result.score, 0);
        expect(result.correctAnswers, 0);
        expect(result.totalQuestions, 0);
        expect(result.incorrectQuestions, isEmpty);
        print('✓ PASSED: should handle empty questions list in results calculation');
      } catch (e) {
        print('✗ FAILED: should handle empty questions list in results calculation - $e');
        rethrow;
      }
    });

    test('should handle answer submission without feedback', () async {
      print('Running test: should handle answer submission without feedback');
      try {
        // Arrange
        final question = QuizQuestion(
          id: '1',
          question: 'Test question',
          questionType: 'mcq',
          correctAnswer: 'a',
          selectableOptions: [
            SelectableOption(value: 'a', displayText: 'Option A', isSelected: false),
            SelectableOption(value: 'b', displayText: 'Option B', isSelected: false),
          ],
          sourceSection: 'Test Section',
          // No feedback provided
        );

        // Act
        final result = await qnaService.submitAnswer(question, 'a');

        // Assert
        expect(result.userAnswer, 'a');
        expect(result.isCorrect, isTrue);
        expect(result.feedback, isNotNull);
        print('✓ PASSED: should handle answer submission without feedback');
      } catch (e) {
        print('✗ FAILED: should handle answer submission without feedback - $e');
        rethrow;
      }
    });

    test('should handle empty user answer', () async {
      print('Running test: should handle empty user answer');
      try {
        // Arrange
        final question = QuizQuestion(
          id: '1',
          question: 'Test question',
          questionType: 'mcq',
          correctAnswer: 'a',
          selectableOptions: [
            SelectableOption(value: 'a', displayText: 'Option A', isSelected: false),
            SelectableOption(value: 'b', displayText: 'Option B', isSelected: false),
          ],
          feedback: 'Test feedback',
          sourceSection: 'Test Section',
        );

        // Act
        final result = await qnaService.submitAnswer(question, '');

        // Assert
        expect(result.userAnswer, '');
        expect(result.isCorrect, isFalse);
        print('✓ PASSED: should handle empty user answer');
      } catch (e) {
        print('✗ FAILED: should handle empty user answer - $e');
        rethrow;
      }
    });

    test('should handle case insensitive answer comparison', () async {
      print('Running test: should handle case insensitive answer comparison');
      try {
        // Arrange
        final question = QuizQuestion(
          id: '1',
          question: 'Test question',
          questionType: 'mcq',
          correctAnswer: 'a',
          selectableOptions: [
            SelectableOption(value: 'a', displayText: 'Option A', isSelected: false),
            SelectableOption(value: 'b', displayText: 'Option B', isSelected: false),
          ],
          feedback: 'Test feedback',
          sourceSection: 'Test Section',
        );

        // Act
        final result = await qnaService.submitAnswer(question, 'A'); // Uppercase

        // Assert
        expect(result.userAnswer, 'A');
        expect(result.isCorrect, isTrue);
        print('✓ PASSED: should handle case insensitive answer comparison');
      } catch (e) {
        print('✗ FAILED: should handle case insensitive answer comparison - $e');
        rethrow;
      }
    });
  });
}