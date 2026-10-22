import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/progress_model.dart';
import '../../courses/providers/progress_provider.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String courseTitle;

  const QuizScreen({super.key, required this.courseId, required this.courseTitle});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'What language is used to build Flutter apps?',
      options: ['Java', 'Dart', 'Swift', 'Kotlin'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Which widget is used for a scrollable list?',
      options: ['Column', 'Container', 'ListView', 'Row'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: 'What does "Hot Reload" do?',
      options: [
        'Restarts the entire app',
        'Injects updated code without losing state',
        'Deletes the app cache',
        'Compiles for production',
      ],
      correctIndex: 1,
    ),
  ];

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _quizCompleted = false;

  void _selectOption(int index) {
    if (_selectedOption != null) return;

    setState(() {
      _selectedOption = index;
      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
        });
      } else {
        _saveProgress();
        setState(() {
          _quizCompleted = true;
        });
      }
    });
  }

  Future<void> _saveProgress() async {
    final progress = Progress(
      courseId: widget.courseId,
      courseTitle: widget.courseTitle,
      score: _score,
      totalQuestions: _questions.length,
    );
    await ref.read(progressRepositoryProvider).saveProgress(progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: Text('${widget.courseTitle} Quiz', style: const TextStyle(color: Colors.white)),
      ),
      body: _quizCompleted ? _buildResultView() : _buildQuestionView(),
    );
  }

  Widget _buildQuestionView() {
    final question = _questions[_currentIndex];

    return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          LinearProgressIndicator(
            value: _currentIndex / _questions.length,
            backgroundColor: Colors.white12,
            color: const Color(0xFF2979FF),
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${_currentIndex + 1} of ${_questions.length}',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 28),
          Text(
            question.question,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 28),
          ...List.generate(question.options.length, (index) {
            final isSelected = _selectedOption == index;
            final isCorrect = index == question.correctIndex;

            Color borderColor = Colors.white24;
            Color bgColor = Colors.white.withOpacity(0.05);

            if (_selectedOption != null) {
              if (isCorrect) {
                borderColor = Colors.greenAccent;
                bgColor = Colors.greenAccent.withOpacity(0.1);
              } else if (isSelected && !isCorrect) {
                borderColor = Colors.redAccent;
                bgColor = Colors.redAccent.withOpacity(0.1);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _selectOption(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(question.options[index], style: const TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
            );
          }),
        ],
      ),
            ),
        ),
    );
  }

  Widget _buildResultView() {
    final percentage = (_score / _questions.length * 100).round();

    return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Icon(
              percentage >= 60 ? Icons.emoji_events : Icons.refresh,
              size: 80,
              color: const Color(0xFF2979FF),
            ),
            const SizedBox(height: 20),
            const Text('Quiz Completed!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('You scored $_score out of ${_questions.length}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 4),
            Text('$percentage%', style: const TextStyle(color: Color(0xFF2979FF), fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Course', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
        ),
    );
  }
}