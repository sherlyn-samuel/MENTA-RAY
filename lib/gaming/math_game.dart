import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class MathGame extends StatefulWidget {
  const MathGame({super.key});

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  int num1 = 0;
  int num2 = 0;
  List<int> options = [];
  int score = 0;
  int wrongAnswers = 0;
  int totalQuestions = 0;
  final int maxQuestions = 25;
  final int maxWrong = 3;
  Timer? _timer;
  int _timeLeft = 90;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _showGameOver();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void generateQuestion() {
    if (wrongAnswers >= maxWrong || totalQuestions >= maxQuestions) {
      _timer?.cancel();
      _showGameOver();
      return;
    }

    Random rng = Random();
    num1 = rng.nextInt(5) + 1;
    num2 = rng.nextInt(5) + 1;
    int correctAns = num1 + num2;

    Set<int> optionSet = {correctAns};
    while (optionSet.length < 4) {
      int wrongAns = rng.nextInt(10) + 1;
      optionSet.add(wrongAns);
    }

    options = optionSet.toList();
    options.shuffle();
    setState(() {});
  }

  void checkAnswer(int selected) {
    if (wrongAnswers >= maxWrong || _timeLeft <= 0) return;

    setState(() {
      totalQuestions++;
      if (selected == (num1 + num2)) {
        score++;
      } else {
        wrongAnswers++;
      }
    });
    generateQuestion();
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over", style: TextStyle(fontFamily: 'Pixellari')),
        content: Text(
          "Final Score: $score\n" + 
          (_timeLeft <= 0 ? "Time's up!" : wrongAnswers >= maxWrong ? "Out of lives!" : "Quiz finished!"),
          style: const TextStyle(fontFamily: 'Pixellari'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Exit", style: TextStyle(fontFamily: 'Pixellari')),
          ),
        ],
      ),
    );
  }

  Widget _buildHearts() {
    List<Widget> hearts = [];
    for (int i = 0; i < maxWrong; i++) {
      bool isFull = i < (maxWrong - wrongAnswers);
      hearts.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            isFull ? "❤" : "♡",
            style: const TextStyle(color: Colors.red, fontSize: 45),
          ),
        ),
      );
    }
    return Row(mainAxisSize: MainAxisSize.min, children: hearts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        double w = constraints.maxWidth;
        double h = constraints.maxHeight;

        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/mathbg.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            
            Positioned(
              top: 15,
              left: 10,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 25),
                    onPressed: () => Navigator.pop(context),
                  ),
                  _buildHearts(),
                ],
              ),
            ),

            Positioned(
              top: h * 0.11, 
              left: 72, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "QUESTION: $totalQuestions/$maxQuestions",
                    style: const TextStyle(fontFamily: 'Pixellari', fontSize: 14,color: Colors.black,  fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "SCORE: $score",
                    style: const TextStyle(fontFamily: 'Pixellari', fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Positioned(
              top: h * 0.12, 
              width: w,
              child: Column(
                children: [
                  Text(
                    "TIME: $_timeLeft",
                    style: const TextStyle(fontFamily: 'Pixellari', fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "WHAT IS $num1 + $num2?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Pixellari', fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Top row answer boxes (A and C)
            Positioned(
              top: h * 0.66,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _answerBox(options.isNotEmpty ? options[0] : 0, w * 0.42),
                  _answerBox(options.length > 1 ? options[1] : 0, w * 0.42),
                ],
              ),
            ),

            // Bottom row answer boxes (B and D)
            Positioned(
              top: h * 0.85,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _answerBox(options.length > 2 ? options[2] : 0, w * 0.42),
                  _answerBox(options.length > 3 ? options[3] : 0, w * 0.42),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _answerBox(int value, double width) {
    return GestureDetector(
      onTap: () => checkAnswer(value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: 65, 
        alignment: Alignment.center, 
        child: Text(
          "$value",
          style: const TextStyle(fontFamily: 'Pixellari', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
} // msth game.dart