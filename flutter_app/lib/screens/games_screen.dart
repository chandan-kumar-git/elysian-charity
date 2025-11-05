import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Mini games for user engagement
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Games',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildGameCard(context, 'Charity Trivia', '🧠', const Color(0xFF06b6d4), () {
            _launchTriviaGame(context);
          }),
          _buildGameCard(context, 'Crypto Runner', '🏃', const Color(0xFFf59e0b), () {}),
          _buildGameCard(context, 'Donation Match', '🎯', const Color(0xFF10b981), () {}),
          _buildGameCard(context, 'Block Puzzle', '🧩', const Color(0xFF8b5cf6), () {}),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String name, String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  void _launchTriviaGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TriviaGameScreen()),
    );
  }
}

class TriviaGameScreen extends StatefulWidget {
  const TriviaGameScreen({super.key});

  @override
  State<TriviaGameScreen> createState() => _TriviaGameScreenState();
}

class _TriviaGameScreenState extends State<TriviaGameScreen> {
  int _currentQuestion = 0;
  int _score = 0;

  final List<TriviaQuestion> _questions = [
    TriviaQuestion(
      question: 'What does blockchain ensure in charity donations?',
      options: ['Speed', 'Transparency', 'Fun', 'Complexity'],
      correctIndex: 1,
    ),
    TriviaQuestion(
      question: 'What cryptocurrency is used on Elysian Chain?',
      options: ['Bitcoin', 'Dogecoin', 'Ethereum', 'Litecoin'],
      correctIndex: 2,
    ),
    TriviaQuestion(
      question: 'What percentage of donations typically reach beneficiaries?',
      options: ['50%', '70%', '90%', '97%'],
      correctIndex: 3,
    ),
  ];

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _questions[_currentQuestion].correctIndex) {
      setState(() => _score++);
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() => _currentQuestion++);
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 80, color: Color(0xFFf59e0b)),
            const SizedBox(height: 20),
            const Text(
              'Game Complete!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Score: $_score/${_questions.length}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06b6d4)),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Question ${_currentQuestion + 1}/${_questions.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Score: $_score',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF06b6d4), Color(0xFF0ea5e9)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question.question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn().scale(),
            const SizedBox(height: 40),
            ...List.generate(question.options.length, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                  ),
                  child: Text(
                    question.options[index],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: -0.2, end: 0);
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}
