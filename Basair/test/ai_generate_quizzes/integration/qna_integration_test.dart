// test/ai_generate_quizzes/integration/qna_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:basair_real_app/features/ai_generate_quizzes/service/qna_service.dart';
import 'package:basair_real_app/features/ai_generate_tafsir/service/tafsir_service.dart';
import 'package:basair_real_app/features/ai_generate_quizzes/model/quiz.dart';

class MockTafsirService extends Mock implements TafsirService {}

void main() {
  group('QnAService Integration Tests', () {
    late QnAService qnaService;
    late MockTafsirService mockTafsirService;

    setUp(() async {
      mockTafsirService = MockTafsirService();
      
    dotenv.testLoad(fileInput: 'OPENAI_API_KEY=test_api_key_123');

      qnaService = QnAService(
        tafsirService: mockTafsirService,
        baseUrl: 'https://api.test-openai.com/v1',
      );
    });

    test('should submit answer and return evaluated question with comprehensive feedback', () async {
      print('Running test: should submit answer and return evaluated question with comprehensive feedback');
      try {
        // Arrange
        final question = QuizQuestion(
          id: '1',
          question: 'What is the main theme of Surah Al-Nisa?',
          questionType: 'mcq',
          correctAnswer: 'a',
          selectableOptions: [
            SelectableOption(value: 'a', displayText: 'Women\'s rights and social justice', isSelected: false),
            SelectableOption(value: 'b', displayText: 'Historical battles', isSelected: false),
            SelectableOption(value: 'c', displayText: 'Scientific facts', isSelected: false),
            SelectableOption(value: 'd', displayText: 'Future predictions', isSelected: false),
          ],
          feedback: 'Comprehensive explanation about Surah Al-Nisa focusing on women rights and social justice.',
          sourceSection: 'Introduction',
        );

        // Act
        final result = await qnaService.submitAnswer(question, 'a');

        // Assert
        expect(result.userAnswer, 'a');
        expect(result.isCorrect, isTrue);
        expect(result.feedback, contains('EXCELLENT'));
        expect(result.feedback, contains('Comprehensive explanation'));
        print('✓ PASSED: should submit answer and return evaluated question with comprehensive feedback');
      } catch (e) {
        print('✗ FAILED: should submit answer and return evaluated question with comprehensive feedback - $e');
        rethrow;
      }
    });

    test('should calculate comprehensive quiz results with feedback', () async {
      print('Running test: should calculate comprehensive quiz results with feedback');
      try {
        // Arrange
        final questions = [
          QuizQuestion(
            id: '1',
            question: 'What does Surah Al-Nisa primarily address?',
            questionType: 'mcq',
            correctAnswer: 'a',
            selectableOptions: [
              SelectableOption(value: 'a', displayText: 'Women\'s rights and social justice', isSelected: false),
              SelectableOption(value: 'b', displayText: 'Historical events', isSelected: false),
            ],
            userAnswer: 'a',
            isCorrect: true,
            feedback: 'Surah Al-Nisa focuses on social justice, women rights, and orphan protection.',
            sourceSection: 'Theme',
          ),
          QuizQuestion(
            id: '2',
            question: 'Which verse discusses inheritance laws?',
            questionType: 'mcq',
            correctAnswer: 'b',
            selectableOptions: [
              SelectableOption(value: 'a', displayText: 'Verse 4:1', isSelected: false),
              SelectableOption(value: 'b', displayText: 'Verse 4:11', isSelected: false),
            ],
            userAnswer: 'a', // Wrong answer
            isCorrect: false,
            feedback: 'Verse 4:11 establishes detailed inheritance laws in Islam.',
            sourceSection: 'Inheritance',
          ),
        ];

        // Act
        final result = await qnaService.calculateResults(questions, 'Surah Al-Nisa');

        // Assert
        expect(result.score, 50);
        expect(result.correctAnswers, 1);
        expect(result.totalQuestions, 2);
        expect(result.incorrectQuestions, hasLength(1));
        expect(result.performanceLevel, 'Developing Knowledge 📖');
        expect(result.detailedFeedback, contains('Continuing Your Quranic Journey'));
        print('✓ PASSED: should calculate comprehensive quiz results with feedback');
      } catch (e) {
        print('✗ FAILED: should calculate comprehensive quiz results with feedback - $e');
        rethrow;
      }
    });

    test('should handle all incorrect answers scenario', () async {
      print('Running test: should handle all incorrect answers scenario');
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
            userAnswer: 'b', // Wrong
            isCorrect: false,
            feedback: 'Explanation for question 1',
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
            userAnswer: 'a', // Wrong
            isCorrect: false,
            feedback: 'Explanation for question 2',
            sourceSection: 'Section 2',
          ),
        ];

        // Act
        final result = await qnaService.calculateResults(questions, 'Surah Al-Nisa');

        // Assert
        expect(result.score, 0);
        expect(result.correctAnswers, 0);
        expect(result.totalQuestions, 2);
        expect(result.incorrectQuestions, hasLength(2));
        expect(result.performanceLevel, 'Keep Studying 🔍');
        print('✓ PASSED: should handle all incorrect answers scenario');
      } catch (e) {
        print('✗ FAILED: should handle all incorrect answers scenario - $e');
        rethrow;
      }
    });
  });
}