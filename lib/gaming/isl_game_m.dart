import 'dart:async';
import 'package:flutter/material.dart';

class ISLGameM extends StatefulWidget {
  const ISLGameM({super.key});

  @override
  State<ISLGameM> createState() => _ISLGameMState();
}

class _ISLGameMState extends State<ISLGameM> {
  final List<String> allLetters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'];

  List<Map<String, dynamic>> imageCards = [];
  List<Map<String, dynamic>> letterOptions = [];

  String? selectedType;
  int?    selectedIndex;

  int hearts   = 3;
  int score    = 0;
  int timeLeft = 5 * 60;
  Timer? _timer;
  bool gameOver = false;

  static const int maxWrong = 3;

  @override
  void initState() {
    super.initState();
    _setupRound();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          t.cancel();
          gameOver = true;
          _showGameOver();
        }
      });
    });
  }

  String get _formattedTime {
    final m = (timeLeft ~/ 60).toString().padLeft(2, '0');
    final s = (timeLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _setupRound() {
    final pool = List<String>.from(allLetters)..shuffle();
    final roundLetters = pool.take(2).toList();
    final decoys = pool.where((l) => !roundLetters.contains(l)).take(2).toList();

    imageCards = roundLetters
        .map((letter) => {'letter': letter, 'isMatched': false})
        .toList()
      ..shuffle();

    letterOptions = [...roundLetters, ...decoys]
        .map((letter) => {
              'letter': letter,
              'isMatched': false,
              'isDecoy': !roundLetters.contains(letter),
            })
        .toList()
      ..shuffle();

    selectedType  = null;
    selectedIndex = null;
  }

  void _handleTap(String type, int index) {
    if (gameOver) return;

    final card = type == 'image' ? imageCards[index] : letterOptions[index];
    if (card['isMatched'] == true) return;

    setState(() {
      if (selectedType == type && selectedIndex == index) {
        selectedType  = null;
        selectedIndex = null;
        return;
      }

      if (selectedType == null) {
        selectedType  = type;
        selectedIndex = index;
        return;
      }

      if (selectedType == type) {
        selectedType  = type;
        selectedIndex = index;
        return;
      }

      final imgIndex = type == 'image' ? index : selectedIndex!;
      final ltrIndex = type == 'letter' ? index : selectedIndex!;

      final imgLetter = imageCards[imgIndex]['letter'] as String;
      final ltrLetter = letterOptions[ltrIndex]['letter'] as String;

      selectedType  = null;
      selectedIndex = null;

      if (imgLetter == ltrLetter) {
        imageCards[imgIndex]['isMatched']    = true;
        letterOptions[ltrIndex]['isMatched'] = true;
        score++;

        if (imageCards.every((c) => c['isMatched'] == true)) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) setState(_setupRound);
          });
        }
      } else {
        hearts--;
        if (hearts <= 0) {
          hearts = 0;
          gameOver = true;
          _timer?.cancel();
          Future.delayed(
              const Duration(milliseconds: 300), () => _showGameOver());
        }
      }
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over',
            style: TextStyle(fontFamily: 'Pixellari')),
        content: Text(
          'Score: $score\nISL Medium complete!',
          style: const TextStyle(fontFamily: 'Pixellari'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                hearts   = 3;
                score    = 0;
                timeLeft = 5 * 60;
                gameOver = false;
                _setupRound();
                _startTimer();
              });
            },
            child: const Text('Play Again',
                style: TextStyle(fontFamily: 'Pixellari')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit',
                style: TextStyle(fontFamily: 'Pixellari')),
          ),
        ],
      ),
    );
  }

  Widget _buildHearts() {
    final wrongAnswers = maxWrong - hearts;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxWrong, (i) {
        final isFull = i < (maxWrong - wrongAnswers);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            isFull ? '❤' : '♡',
            style: const TextStyle(color: Colors.red, fontSize: 30),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final cardWidth    = w * 0.20;
        final cardHeight   = h * 0.28;
        final bubbleWidth  = w * 0.06;
        final bubbleHeight = h * 0.09;

        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/islmed.png'),
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
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.black, size: 25),
                    onPressed: () => Navigator.pop(context),
                  ),
                  _buildHearts(),
                ],
              ),
            ),

            Positioned(
              top: h * 0.12,
              left: 75,
              child: Text(
                'SCORE: $score',
                style: const TextStyle(
                  fontFamily: 'Pixellari',
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Positioned(
              top: h * 0.12,
              width: w,
              child: Text(
                'TIME: $_formattedTime',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Pixellari',
                  fontSize: 18,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Positioned(
              top: h * 0.22,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  imageCards.length,
                  (i) => _buildImageCard(i, cardWidth, cardHeight),
                ),
              ),
            ),

            Positioned(
              bottom: h * 0.04,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  letterOptions.length,
                  (i) => _buildLetterBox(i, bubbleWidth, bubbleHeight),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildImageCard(int index, double width, double height) {
    final card       = imageCards[index];
    final isSelected = selectedType == 'image' && selectedIndex == index;
    final isMatched  = card['isMatched'] == true;
    final letter     = card['letter'] as String;

    return Opacity(
      opacity: isMatched ? 0.0 : 1.0,
      child: IgnorePointer(
        ignoring: isMatched,
        child: GestureDetector(
          onTap: () => _handleTap('image', index),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.yellowAccent.withOpacity(0.3)
                  : Colors.lightBlue.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? Colors.orange
                    : Colors.lightBlueAccent.withOpacity(0.5),
                width: 4,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/${letter.toUpperCase()}.png',
                width: width * 0.75,
                height: height * 0.75,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Text(
                  letter.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Pixellari',
                    fontSize: 52,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBox(int index, double width, double height) {
    final option     = letterOptions[index];
    final isSelected = selectedType == 'letter' && selectedIndex == index;
    final isMatched  = option['isMatched'] == true;
    final letter     = option['letter'] as String;

    return Opacity(
      opacity: isMatched ? 0.0 : 1.0,
      child: IgnorePointer(
        ignoring: isMatched,
        child: GestureDetector(
          onTap: () => _handleTap('letter', index),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.yellowAccent.withOpacity(0.35)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: Colors.orange, width: 2)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              letter.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pixellari',
                fontSize: height * 0.45,
                color: isSelected ? Colors.orange : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}